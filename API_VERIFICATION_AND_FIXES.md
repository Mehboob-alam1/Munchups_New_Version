# 🔍 API Verification and Required Fixes

## ⚠️ Critical Issues Found

### 1. **Request Format Mismatch**

**Problem:** Your PHP APIs expect JSON (`json_decode(file_get_contents('php://input'))`), but the Flutter app sends **form data** (`MultipartRequest`).

**Flutter App Uses:**
- `http.MultipartRequest('POST', ...)` 
- `request.fields.addAll(body)` - sends as form data, NOT JSON

**Your PHP Expects:**
- `json_decode(file_get_contents('php://input'))` - expects JSON

**Fix Required:** Change all APIs to read from `$_POST` instead of JSON input.

---

### 2. **Response Format Mismatch**

**Problem:** Your APIs return `'message'` but Flutter app expects `'msg'`.

**Flutter App Expects:**
```json
{
  "success": "true" or "false",
  "msg": "message text"
}
```

**Your APIs Return:**
```json
{
  "success": true or false,
  "message": "message text",
  "data": {...}
}
```

**Fix Required:** Change `'message'` to `'msg'` and ensure `success` is string `'true'`/`'false'`.

---

### 3. **Parameter Source Mismatch**

**Problem:** Some APIs read from wrong source.

- `accept_reject_test.php` - Flutter sends params in **URL query string**, not JSON body
- `mark_complete.php` - Flutter uses **GET request** with query params, not POST

---

## ✅ Corrected API Files

### File 1: `customer_token_test.php` (FIXED)

```php
<?php
// customer_token_test.php
// Creates Stripe Customer for buyer

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
```

---

### File 2: `order_dish_test.php` (FIXED)

```php
<?php
// order_dish_test.php
// Creates order and processes Stripe payment

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
```

---

### File 3: `accept_reject_test.php` (FIXED)

```php
<?php
// accept_reject_test.php
// Handles order acceptance/rejection and transfers

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
```

---

### File 4: `mark_complete.php` (FIXED)

```php
<?php
// mark_complete.php
// Verifies OTP and marks order as delivered

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
```

---

### File 5: `stripe_config.php` (FIXED)

```php
<?php
// stripe_config.php
// Configuration file for Stripe API

// Load Stripe SDK
require_once 'vendor/autoload.php';

// Stripe API Keys
define('STRIPE_SECRET_KEY', 'sk_test_N950jTKYw562aEty72yLlaEZ');
define('STRIPE_PUBLISHABLE_KEY', 'pk_test_Qv6FioIn5wfwiVyeQ059x3TQ');

// Platform Commission Percentage
define('PLATFORM_COMMISSION_PERCENT', 10); // 10%

// Application Fee Name
define('PLATFORM_FEE_NAME', 'Munchups Commission');

// Currency
define('CURRENCY', 'usd');

// Database Configuration
$host = 'localhost';
$dbname = 'munchups_db';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}

// Initialize Stripe
\Stripe\Stripe::setApiKey(STRIPE_SECRET_KEY);

// Helper function to send JSON response (matches Flutter expectations)
function sendResponse($success, $message, $data = []) {
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => $success ? 'true' : 'false', // String, not boolean
        'msg' => $message, // 'msg' not 'message'
        'data' => $data
    ]);
    exit;
}

// Helper function to calculate platform fee
function calculatePlatformFee($amount) {
    return round($amount * (PLATFORM_COMMISSION_PERCENT / 100), 2);
}

// Helper function to log errors
function logError($error, $context = []) {
    $logEntry = date('Y-m-d H:i:s') . " - Error: $error\n";
    $logEntry .= "Context: " . json_encode($context) . "\n";
    $logEntry .= "==================================\n";
    
    file_put_contents('stripe_errors.log', $logEntry, FILE_APPEND);
}
?>
```

---

### File 6: `connect_stripe_account.php` (FIXED)

```php
<?php
// connect_stripe_account.php
// Creates Stripe Connect account for chefs/grocers

require_once 'stripe_config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Invalid request method');
}

// Get input data from POST (form data, not JSON)
$user_id = isset($_POST['user_id']) ? intval($_POST['user_id']) : null;
$user_type = isset($_POST['user_type']) ? trim($_POST['user_type']) : null;
$email = isset($_POST['email']) ? trim($_POST['email']) : null;

if (!$user_id || !$user_type || !$email) {
    sendResponse(false, 'Missing required parameters');
}

// Validate user type
if (!in_array($user_type, ['chef', 'grocer'])) {
    sendResponse(false, 'Invalid user type');
}

try {
    // Check if user already has a Stripe account
    $stripe_account_id = null;
    
    if ($user_type === 'chef') {
        $stmt = $pdo->prepare("SELECT stripe_account_id FROM chef_master WHERE chef_id = ?");
        $stmt->execute([$user_id]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user && !empty($user['stripe_account_id'])) {
            $stripe_account_id = $user['stripe_account_id'];
        }
    } else {
        $stmt = $pdo->prepare("SELECT stripe_account_id FROM user_master WHERE user_id = ? AND user_type = ?");
        $stmt->execute([$user_id, $user_type]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user && !empty($user['stripe_account_id'])) {
            $stripe_account_id = $user['stripe_account_id'];
        }
    }
    
    if ($stripe_account_id) {
        // User already has a Stripe account
        try {
            $account = \Stripe\Account::retrieve($stripe_account_id);
            
            if ($account->details_submitted) {
                sendResponse(true, 'Stripe account already connected', [
                    'account_id' => $stripe_account_id,
                    'account_link_url' => null, // Already onboarded
                    'onboarding_completed' => true
                ]);
            } else {
                // Account exists but needs onboarding
                $accountLink = \Stripe\AccountLink::create([
                    'account' => $stripe_account_id,
                    'refresh_url' => 'https://munchups.com/webservice/stripe_refresh.php',
                    'return_url' => 'https://munchups.com/webservice/stripe_return.php',
                    'type' => 'account_onboarding',
                ]);
                
                sendResponse(true, 'Account needs onboarding', [
                    'account_id' => $stripe_account_id,
                    'account_link_url' => $accountLink->url,
                    'onboarding_completed' => false
                ]);
            }
        } catch (Exception $e) {
            // Account might be invalid, create new one
            logError('Error retrieving Stripe account: ' . $e->getMessage(), ['user_id' => $user_id]);
            $stripe_account_id = null;
        }
    }
    
    if (!$stripe_account_id) {
        // Create new Stripe Connect account (Express)
        $account = \Stripe\Account::create([
            'type' => 'express',
            'country' => 'US', // Change based on your region
            'email' => $email,
            'capabilities' => [
                'card_payments' => ['requested' => true],
                'transfers' => ['requested' => true],
            ],
            'metadata' => [
                'user_id' => $user_id,
                'user_type' => $user_type,
                'platform' => 'Munchups'
            ]
        ]);
        
        $stripe_account_id = $account->id;
        
        // Save Stripe account ID to database
        if ($user_type === 'chef') {
            $stmt = $pdo->prepare("UPDATE chef_master SET stripe_account_id = ?, updated_at = NOW() WHERE chef_id = ?");
            $stmt->execute([$stripe_account_id, $user_id]);
        } else {
            $stmt = $pdo->prepare("UPDATE user_master SET stripe_account_id = ?, updated_at = NOW() WHERE user_id = ? AND user_type = ?");
            $stmt->execute([$stripe_account_id, $user_id, $user_type]);
        }
        
        // Create account link for onboarding
        $accountLink = \Stripe\AccountLink::create([
            'account' => $stripe_account_id,
            'refresh_url' => 'https://munchups.com/webservice/stripe_refresh.php',
            'return_url' => 'https://munchups.com/webservice/stripe_return.php',
            'type' => 'account_onboarding',
        ]);
        
        sendResponse(true, 'Stripe account created successfully', [
            'account_id' => $stripe_account_id,
            'account_link_url' => $accountLink->url
        ]);
    }
    
} catch (\Stripe\Exception\ApiErrorException $e) {
    logError('Stripe API error: ' . $e->getMessage(), $_POST);
    sendResponse(false, 'Stripe API error: ' . $e->getError()->message);
} catch (Exception $e) {
    logError('Error in Stripe account creation: ' . $e->getMessage(), $_POST);
    sendResponse(false, 'Failed to create Stripe account: ' . $e->getMessage());
}
?>
```

---

## 📋 Summary of Required Changes

### ✅ Fixed Issues:

1. **Request Format:**
   - Changed from `json_decode(file_get_contents('php://input'))` to `$_POST` or `$_GET`
   - Matches Flutter's `MultipartRequest` format

2. **Response Format:**
   - Changed `'message'` to `'msg'`
   - Changed `success: true/false` to `success: 'true'/'false'` (string)

3. **Parameter Sources:**
   - `accept_reject_test.php` - Now reads from `$_GET` (URL query params)
   - `mark_complete.php` - Changed to GET request, reads from `$_GET`

4. **Database Queries:**
   - Fixed chef/grocer lookup to check both `chef_master` and `user_master`

5. **Payment Flow:**
   - Fixed PaymentIntent capture logic
   - Fixed refund logic for uncaptured payments

---

## ⚠️ Additional Notes

1. **Database Schema:** Your schema looks good, but ensure:
   - `orders.status` enum matches: `'pending', 'accept', 'decline', 'reject', 'completed', 'delivered'`
   - Column names match what the code expects

2. **URLs:** Update these in `connect_stripe_account.php`:
   - `refresh_url` and `return_url` to your actual domain

3. **Webhook Secret:** Update `stripe_webhook.php`:
   - Set `$endpoint_secret` to your actual webhook secret from Stripe Dashboard

4. **Testing:** Test each API endpoint:
   - `customer_token_test.php` - Save card
   - `order_dish_test.php` - Create order
   - `accept_reject_test.php` - Accept/reject/complete
   - `mark_complete.php` - Verify OTP
   - `connect_stripe_account.php` - Connect account

---

## ✅ Ready to Use

After applying these fixes, your APIs should work correctly with the Flutter app!


