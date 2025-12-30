<?php
/**
 * connect_stripe_account.php
 * Creates Stripe Connect account for chefs/grocers
 * 
 * Flutter sends: MultipartRequest with form data
 * Expected: user_id, user_type, email
 */

require_once 'stripe_config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Invalid request method');
}

// Get input data from POST (form data, not JSON)
$user_id   = isset($_POST['user_id'])   ? intval($_POST['user_id'])   : null;
$user_type = isset($_POST['user_type']) ? trim($_POST['user_type'])   : null;
$email     = isset($_POST['email'])     ? trim($_POST['email'])       : null;

if (!$user_id || !$user_type || !$email) {
    sendResponse(false, 'Missing required parameters');
}

// Validate user type
if (!in_array($user_type, ['chef', 'grocer'])) {
    sendResponse(false, 'Invalid user type');
}

// Validate email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendResponse(false, 'Invalid email address format');
}

try {
    // Check if user already has a Stripe account
    // NOTE: we use only user_master to avoid missing table errors (no chef_master table)
    $stripe_account_id = null;

    // First, check if stripe_account_id column exists
    try {
        $stmt = $pdo->prepare("SELECT stripe_account_id FROM user_master WHERE user_id = ? AND user_type = ?");
        $stmt->execute([$user_id, $user_type]);
        $user = $stmt->fetch();

        if ($user && !empty($user['stripe_account_id'])) {
            $stripe_account_id = $user['stripe_account_id'];
        }
    } catch (PDOException $e) {
        // Column might not exist yet - that's OK, we'll create it when saving
        if (strpos($e->getMessage(), 'stripe_account_id') === false) {
            // If it's a different error, log it
            logErrorSecure('Error checking existing Stripe account: ' . $e->getMessage(), ['user_id' => $user_id]);
        }
        // Continue to create new account
        $stripe_account_id = null;
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
            if (function_exists('logError')) {
                logError('Error retrieving Stripe account: ' . $e->getMessage(), ['user_id' => $user_id]);
            } else {
                logErrorSecure('Error retrieving Stripe account: ' . $e->getMessage(), ['user_id' => $user_id]);
            }
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
        
        // Save Stripe account ID to database (only user_master is used)
        // Try to update stripe_account_id column (it might not exist yet)
        try {
            // First, try to add the column if it doesn't exist
            try {
                $pdo->exec("ALTER TABLE user_master ADD COLUMN stripe_account_id VARCHAR(255) NULL");
            } catch (PDOException $e) {
                // Column might already exist, that's OK
                if (strpos($e->getMessage(), 'Duplicate column') === false && 
                    strpos($e->getMessage(), 'already exists') === false) {
                    // Only log if it's a different error
                    logErrorSecure('Error adding stripe_account_id column: ' . $e->getMessage(), ['user_id' => $user_id]);
                }
            }
            
            // Now update the account ID (without updated_at since it might not exist)
            $stmt = $pdo->prepare("UPDATE user_master SET stripe_account_id = ? WHERE user_id = ? AND user_type = ?");
            $stmt->execute([$stripe_account_id, $user_id, $user_type]);
        } catch (PDOException $e) {
            // Log the error but don't fail - the account is created in Stripe
            logErrorSecure('Error saving stripe_account_id to database: ' . $e->getMessage(), [
                'user_id' => $user_id,
                'stripe_account_id' => $stripe_account_id
            ]);
            // Continue anyway - the account is created in Stripe
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
    // Log full error for debugging
    logErrorSecure('Stripe API error: ' . $e->getMessage(), [
        'user_id'    => $user_id,
        'user_type'  => $user_type,
        'email'      => $email,
        'stripe_code'=> $e->getError()->code ?? null,
        'stripe_type'=> $e->getError()->type ?? null,
    ]);

    $msg = 'Stripe API error: ' . ($e->getError()->message ?? $e->getMessage());
    sendResponse(false, $msg);
} catch (Exception $e) {
    logErrorSecure('General error in connect_stripe_account', [
        'user_id'   => $user_id,
        'user_type' => $user_type,
        'email'     => $email,
        'error'     => $e->getMessage(),
    ]);
    sendResponse(false, 'Failed to create/connect Stripe account: ' . $e->getMessage());
}
?>
