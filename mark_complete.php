<?php
/**
 * mark_complete.php
 * Verifies OTP and marks order as delivered
 * 
 * Flutter sends: GET request with query parameters
 * Expected: chef_grocer_id, order_unique_number, payment_otp, user_id (in URL)
 */

require_once 'stripe_config.php';

// Flutter uses GET request, not POST
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendResponse(false, 'Invalid request method');
}

// Get input data from URL query string
$chef_grocer_id = isset($_GET['chef_grocer_id']) ? intval($_GET['chef_grocer_id']) : null;
$order_unique_number = isset($_GET['order_unique_number']) ? trim($_GET['order_unique_number']) : null;
$payment_otp = isset($_GET['payment_otp']) ? trim($_GET['payment_otp']) : null;
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : null;

if (!$chef_grocer_id || !$order_unique_number || !$payment_otp || !$user_id) {
    sendResponse(false, 'Missing required parameters');
}

try {
    // Start transaction
    $pdo->beginTransaction();
    
    // 1. Get order details
    $stmt = $pdo->prepare("
        SELECT * FROM orders 
        WHERE order_unique_number = ? 
        AND chef_grocer_id = ? 
        AND user_id = ?
        AND status = 'completed'
    ");
    $stmt->execute([$order_unique_number, $chef_grocer_id, $user_id]);
    $order = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$order) {
        throw new Exception('Order not found or not completed');
    }
    
    // 2. Verify OTP
    if ($order['otp'] != $payment_otp) {
        throw new Exception('Invalid OTP');
    }
    
    // 3. Update order status to delivered
    $stmt = $pdo->prepare("
        UPDATE orders SET 
            status = 'delivered',
            delivered_at = NOW(),
            payment_status = 'completed',
            updated_at = NOW()
        WHERE order_id = ?
    ");
    $stmt->execute([$order['order_id']]);
    
    // 4. Release funds to seller (if not already done)
    if ($order['payment_status'] === 'paid' && !empty($order['payment_intent_id'])) {
        try {
            // Funds were already transferred when order was marked as completed
            // Create transfer record in database
            $stmt = $pdo->prepare("
                INSERT INTO transfers (
                    order_id, chef_grocer_id, amount, platform_fee, 
                    seller_amount, status, created_at
                ) VALUES (?, ?, ?, ?, ?, 'completed', NOW())
            ");
            $stmt->execute([
                $order['order_id'],
                $chef_grocer_id,
                $order['grand_total'],
                $order['platform_fee'] ?? calculatePlatformFee($order['grand_total']),
                $order['seller_amount'] ?? ($order['grand_total'] - calculatePlatformFee($order['grand_total']))
            ]);
            
        } catch (Exception $e) {
            logError('Transfer record creation failed: ' . $e->getMessage(), [
                'order_id' => $order['order_id']
            ]);
            // Continue with order update even if transfer record fails
        }
    }
    
    // 5. Commit transaction
    $pdo->commit();
    
    sendResponse(true, 'Order delivered successfully', [
        'order_id' => $order['order_id'],
        'order_number' => $order['order_unique_number'],
        'status' => 'delivered',
        'delivered_at' => date('Y-m-d H:i:s')
    ]);
    
} catch (Exception $e) {
    $pdo->rollBack();
    logError('Error in OTP verification: ' . $e->getMessage(), $_GET);
    sendResponse(false, 'Failed to verify OTP: ' . $e->getMessage());
}
?>


