<?php
/**
 * order_dish_test.php
 * Creates order and processes Stripe payment
 * 
 * Flutter sends: MultipartRequest with form data
 * Expected: user_id, chef_grocer_id, dish_id, dish_name, quantity, dish_price, total_price, grand_total, note
 */

require_once 'stripe_config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Invalid request method');
}

// Get input data from POST (form data, not JSON)
$user_id = isset($_POST['user_id']) ? intval($_POST['user_id']) : null;
$chef_grocer_id = isset($_POST['chef_grocer_id']) ? intval($_POST['chef_grocer_id']) : null;
$dish_id = isset($_POST['dish_id']) ? intval($_POST['dish_id']) : null;
$dish_name = isset($_POST['dish_name']) ? trim($_POST['dish_name']) : null;
$quantity = isset($_POST['quantity']) ? intval($_POST['quantity']) : null;
$dish_price = isset($_POST['dish_price']) ? floatval($_POST['dish_price']) : null;
$total_price = isset($_POST['total_price']) ? floatval($_POST['total_price']) : null;
$grand_total = isset($_POST['grand_total']) ? floatval($_POST['grand_total']) : null;
$note = isset($_POST['note']) ? trim($_POST['note']) : '';

// Validate required parameters
if (!$user_id || !$chef_grocer_id || !$dish_id || !$dish_name || !$quantity || 
    !$dish_price || !$total_price || !$grand_total) {
    sendResponse(false, 'Missing required parameters');
}

try {
    // Start transaction
    $pdo->beginTransaction();
    
    // 1. Get buyer's Stripe customer ID
    $stmt = $pdo->prepare("SELECT stripe_customer_id FROM user_master WHERE user_id = ?");
    $stmt->execute([$user_id]);
    $buyer = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$buyer || empty($buyer['stripe_customer_id'])) {
        throw new Exception('Buyer does not have a saved payment method');
    }
    
    $stripeCustomerId = $buyer['stripe_customer_id'];
    
    // 2. Get chef/grocer's Stripe account ID
    // Try chef_master first
    $stmt = $pdo->prepare("SELECT stripe_account_id FROM chef_master WHERE chef_id = ?");
    $stmt->execute([$chef_grocer_id]);
    $seller = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // If not found in chef_master, try user_master
    if (!$seller || empty($seller['stripe_account_id'])) {
        $stmt = $pdo->prepare("SELECT stripe_account_id FROM user_master WHERE user_id = ? AND user_type IN ('chef', 'grocer')");
        $stmt->execute([$chef_grocer_id]);
        $seller = $stmt->fetch(PDO::FETCH_ASSOC);
    }
    
    $stripeAccountId = $seller['stripe_account_id'] ?? null;
    
    if (!$stripeAccountId) {
        throw new Exception('Seller does not have a connected Stripe account');
    }
    
    // 3. Generate unique order number
    $order_number = 'ORD' . date('YmdHis') . rand(1000, 9999);
    $otp = rand(1000, 9999); // OTP for delivery verification
    
    // 4. Create order in database
    $stmt = $pdo->prepare("
        INSERT INTO orders (
            order_unique_number, user_id, chef_grocer_id, dish_id, dish_name, 
            quantity, dish_price, total_price, grand_total, note, 
            status, payment_status, otp, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', 'pending', ?, NOW())
    ");
    
    $stmt->execute([
        $order_number, $user_id, $chef_grocer_id, $dish_id, $dish_name,
        $quantity, $dish_price, $total_price, $grand_total, $note,
        $otp
    ]);
    
    $order_id = $pdo->lastInsertId();
    
    // 5. Process Stripe payment
    $amount_in_cents = round($grand_total * 100); // Convert to cents
    
    // Get buyer's default payment method
    $customer = \Stripe\Customer::retrieve($stripeCustomerId);
    $defaultPaymentMethod = $customer->invoice_settings->default_payment_method;
    
    if (!$defaultPaymentMethod) {
        // Get first payment method
        $paymentMethods = \Stripe\PaymentMethod::all([
            'customer' => $stripeCustomerId,
            'type' => 'card',
        ]);
        
        if (empty($paymentMethods->data)) {
            throw new Exception('No payment method found');
        }
        
        $defaultPaymentMethod = $paymentMethods->data[0]->id;
    }
    
    // Create PaymentIntent with connected account
    $paymentIntent = \Stripe\PaymentIntent::create([
        'amount' => $amount_in_cents,
        'currency' => CURRENCY,
        'customer' => $stripeCustomerId,
        'payment_method' => $defaultPaymentMethod,
        'off_session' => true,
        'confirm' => true,
        'capture_method' => 'manual', // Capture later when order is completed
        'transfer_data' => [
            'destination' => $stripeAccountId,
        ],
        'application_fee_amount' => calculatePlatformFee($grand_total) * 100,
        'metadata' => [
            'order_id' => $order_id,
            'order_number' => $order_number,
            'buyer_id' => $user_id,
            'seller_id' => $chef_grocer_id,
            'dish_id' => $dish_id,
            'platform' => 'Munchups'
        ]
    ]);
    
    // 6. Update order with payment information
    $stmt = $pdo->prepare("
        UPDATE orders SET 
            payment_intent_id = ?,
            payment_status = 'authorized',
            updated_at = NOW()
        WHERE order_id = ?
    ");
    $stmt->execute([$paymentIntent->id, $order_id]);
    
    // 7. Commit transaction
    $pdo->commit();
    
    sendResponse(true, 'Order created successfully', [
        'order_id' => $order_id,
        'order_number' => $order_number,
        'payment_intent_id' => $paymentIntent->id,
        'otp' => $otp,
        'amount' => $grand_total,
        'status' => 'pending'
    ]);
    
} catch (\Stripe\Exception\CardException $e) {
    $pdo->rollBack();
    logError('Card error in order creation: ' . $e->getMessage(), $_POST);
    sendResponse(false, 'Payment failed: ' . $e->getError()->message);
} catch (Exception $e) {
    $pdo->rollBack();
    logError('Error in order creation: ' . $e->getMessage(), $_POST);
    sendResponse(false, 'Order creation failed: ' . $e->getMessage());
}
?>


