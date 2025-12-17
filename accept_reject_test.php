<?php
/**
 * accept_reject_test.php
 * Handles order acceptance/rejection and transfers
 * 
 * Flutter sends: MultipartRequest POST with params in URL query string
 * Expected: chef_grocer_id, order_id, user_id, amount, status (in URL)
 */

require_once 'stripe_config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Invalid request method');
}

// Get input data from URL query string (Flutter sends params in URL)
$chef_grocer_id = isset($_GET['chef_grocer_id']) ? intval($_GET['chef_grocer_id']) : null;
$order_id = isset($_GET['order_id']) ? intval($_GET['order_id']) : null;
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : null;
$amount = isset($_GET['amount']) ? floatval($_GET['amount']) : null;
$status = isset($_GET['status']) ? trim($_GET['status']) : null;

if (!$order_id || !$chef_grocer_id || !$user_id || !$amount || !$status) {
    sendResponse(false, 'Missing required parameters');
}

// Valid statuses
$valid_statuses = ['accept', 'decline', 'reject', 'completed'];
if (!in_array($status, $valid_statuses)) {
    sendResponse(false, 'Invalid status');
}

try {
    // Start transaction
    $pdo->beginTransaction();
    
    // 1. Get order details
    $stmt = $pdo->prepare("
        SELECT o.*, um.stripe_customer_id as buyer_stripe_id,
               COALESCE(cm.stripe_account_id, um2.stripe_account_id) as seller_stripe_id
        FROM orders o
        LEFT JOIN user_master um ON o.user_id = um.user_id
        LEFT JOIN chef_master cm ON o.chef_grocer_id = cm.chef_id
        LEFT JOIN user_master um2 ON o.chef_grocer_id = um2.user_id AND um2.user_type IN ('chef', 'grocer')
        WHERE o.order_id = ? AND o.chef_grocer_id = ? AND o.user_id = ?
    ");
    $stmt->execute([$order_id, $chef_grocer_id, $user_id]);
    $order = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$order) {
        throw new Exception('Order not found');
    }
    
    if ($order['status'] === 'delivered') {
        throw new Exception('Order already delivered');
    }
    
    // 2. Handle different statuses
    switch ($status) {
        case 'accept':
            // Update order status to accepted
            $stmt = $pdo->prepare("
                UPDATE orders SET 
                    status = 'accept',
                    accepted_at = NOW(),
                    updated_at = NOW()
                WHERE order_id = ?
            ");
            $stmt->execute([$order_id]);
            
            sendResponse(true, 'Order accepted successfully', [
                'order_id' => $order_id,
                'status' => 'accept'
            ]);
            break;
            
        case 'decline':
        case 'reject':
            // Update order status
            $new_status = ($status === 'decline') ? 'decline' : 'reject';
            
            $stmt = $pdo->prepare("
                UPDATE orders SET 
                    status = ?,
                    cancelled_at = NOW(),
                    updated_at = NOW()
                WHERE order_id = ?
            ");
            $stmt->execute([$new_status, $order_id]);
            
            // 3. Refund the payment
            if (!empty($order['payment_intent_id'])) {
                try {
                    // Cancel the payment intent (if not captured) or create refund
                    $paymentIntent = \Stripe\PaymentIntent::retrieve($order['payment_intent_id']);
                    
                    if ($paymentIntent->status === 'requires_capture') {
                        // Cancel the payment intent
                        $paymentIntent->cancel();
                        
                        // Update order payment status
                        $stmt = $pdo->prepare("
                            UPDATE orders SET 
                                payment_status = 'cancelled',
                                updated_at = NOW()
                            WHERE order_id = ?
                        ");
                        $stmt->execute([$order_id]);
                    } else {
                        // Create refund
                        $refund = \Stripe\Refund::create([
                            'payment_intent' => $order['payment_intent_id'],
                            'amount' => round($order['grand_total'] * 100),
                            'reason' => 'requested_by_customer',
                            'metadata' => [
                                'order_id' => $order_id,
                                'seller_id' => $chef_grocer_id,
                                'reason' => $new_status
                            ]
                        ]);
                        
                        // Update order payment status
                        $stmt = $pdo->prepare("
                            UPDATE orders SET 
                                payment_status = 'refunded',
                                refund_id = ?,
                                updated_at = NOW()
                            WHERE order_id = ?
                        ");
                        $stmt->execute([$refund->id, $order_id]);
                    }
                    
                } catch (Exception $e) {
                    logError('Refund failed: ' . $e->getMessage(), [
                        'order_id' => $order_id,
                        'payment_intent' => $order['payment_intent_id']
                    ]);
                    // Continue with status update even if refund fails
                }
            }
            
            sendResponse(true, 'Order ' . $new_status . ' successfully', [
                'order_id' => $order_id,
                'status' => $new_status,
                'refunded' => true
            ]);
            break;
            
        case 'completed':
            // Update order status to completed
            $stmt = $pdo->prepare("
                UPDATE orders SET 
                    status = 'completed',
                    completed_at = NOW(),
                    updated_at = NOW()
                WHERE order_id = ?
            ");
            $stmt->execute([$order_id]);
            
            // 4. Capture the payment and transfer to seller
            if (!empty($order['payment_intent_id'])) {
                try {
                    // Capture the payment intent
                    $paymentIntent = \Stripe\PaymentIntent::retrieve($order['payment_intent_id']);
                    
                    if ($paymentIntent->status === 'requires_capture') {
                        $paymentIntent->capture();
                    }
                    
                    // Calculate amounts
                    $platform_fee = calculatePlatformFee($order['grand_total']);
                    $seller_amount = $order['grand_total'] - $platform_fee;
                    
                    // Transfer happens automatically via PaymentIntent transfer_data
                    
                    // Update order payment status
                    $stmt = $pdo->prepare("
                        UPDATE orders SET 
                            payment_status = 'paid',
                            platform_fee = ?,
                            seller_amount = ?,
                            captured_at = NOW(),
                            updated_at = NOW()
                        WHERE order_id = ?
                    ");
                    $stmt->execute([$platform_fee, $seller_amount, $order_id]);
                    
                } catch (Exception $e) {
                    logError('Payment capture failed: ' . $e->getMessage(), [
                        'order_id' => $order_id,
                        'payment_intent' => $order['payment_intent_id']
                    ]);
                    throw new Exception('Payment capture failed: ' . $e->getMessage());
                }
            }
            
            sendResponse(true, 'Order marked as completed', [
                'order_id' => $order_id,
                'status' => 'completed',
                'otp' => $order['otp'],
                'seller_amount' => $seller_amount ?? 0,
                'platform_fee' => $platform_fee ?? 0
            ]);
            break;
    }
    
    // Commit transaction
    $pdo->commit();
    
} catch (Exception $e) {
    $pdo->rollBack();
    logError('Error in order status update: ' . $e->getMessage(), $_GET);
    sendResponse(false, 'Failed to update order status: ' . $e->getMessage());
}
?>


