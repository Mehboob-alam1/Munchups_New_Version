<?php
/**
 * customer_token_test.php
 * Creates Stripe Customer for buyer
 * 
 * Flutter sends: MultipartRequest with form data
 * Expected: user_id, token
 */

require_once 'stripe_config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Invalid request method');
}

// Get input data from POST (form data, not JSON)
$user_id = isset($_POST['user_id']) ? intval($_POST['user_id']) : null;
$token = isset($_POST['token']) ? trim($_POST['token']) : null;

if (!$user_id || !$token) {
    sendResponse(false, 'Missing required parameters');
}

try {
    // Check if user already has a Stripe customer ID
    $stmt = $pdo->prepare("SELECT stripe_customer_id FROM user_master WHERE user_id = ?");
    $stmt->execute([$user_id]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    $stripeCustomerId = null;
    
    if ($user && !empty($user['stripe_customer_id'])) {
        // User already has a Stripe customer
        $stripeCustomerId = $user['stripe_customer_id'];
        
        // Attach the new payment method to existing customer
        $paymentMethod = \Stripe\PaymentMethod::retrieve($token);
        $paymentMethod->attach(['customer' => $stripeCustomerId]);
        
        // Set as default payment method
        $customer = \Stripe\Customer::update($stripeCustomerId, [
            'invoice_settings' => ['default_payment_method' => $paymentMethod->id]
        ]);
        
        sendResponse(true, 'Payment method added successfully', [
            'customer_id' => $stripeCustomerId,
            'payment_method_id' => $paymentMethod->id
        ]);
    } else {
        // Create new Stripe customer
        $customer = \Stripe\Customer::create([
            'payment_method' => $token,
            'invoice_settings' => [
                'default_payment_method' => $token
            ],
            'metadata' => [
                'user_id' => $user_id,
                'platform' => 'Munchups'
            ]
        ]);
        
        // Save Stripe customer ID to database
        $stmt = $pdo->prepare("UPDATE user_master SET stripe_customer_id = ?, updated_at = NOW() WHERE user_id = ?");
        $stmt->execute([$customer->id, $user_id]);
        
        sendResponse(true, 'Customer created successfully', [
            'customer_id' => $customer->id
        ]);
    }
    
} catch (\Stripe\Exception\CardException $e) {
    logError('Card error: ' . $e->getMessage(), ['user_id' => $user_id]);
    sendResponse(false, 'Card error: ' . $e->getError()->message);
} catch (\Stripe\Exception\RateLimitException $e) {
    logError('Rate limit error: ' . $e->getMessage(), ['user_id' => $user_id]);
    sendResponse(false, 'Too many requests. Please try again later.');
} catch (\Stripe\Exception\InvalidRequestException $e) {
    logError('Invalid request: ' . $e->getMessage(), ['user_id' => $user_id]);
    sendResponse(false, 'Invalid request: ' . $e->getError()->message);
} catch (\Stripe\Exception\AuthenticationException $e) {
    logError('Authentication error: ' . $e->getMessage(), ['user_id' => $user_id]);
    sendResponse(false, 'Authentication error. Please contact support.');
} catch (\Stripe\Exception\ApiConnectionException $e) {
    logError('API connection error: ' . $e->getMessage(), ['user_id' => $user_id]);
    sendResponse(false, 'Network error. Please check your connection.');
} catch (Exception $e) {
    logError('General error: ' . $e->getMessage(), ['user_id' => $user_id]);
    sendResponse(false, 'An error occurred: ' . $e->getMessage());
}
?>


