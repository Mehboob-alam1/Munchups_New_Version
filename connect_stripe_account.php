<?php
/**
 * 🚀 STRIPE CONNECT ACCOUNT API - MUNCHUPS INTEGRATED
 * 
 * Integrato con sistema esistente:
 * - Usa conn.php per database
 * - Usa stripe.config.php per configurazione
 * - Salva in chef_master o user_master
 * 
 * URL: https://munchups.com/webservice/connect_stripe_account.php
 */

// Abilita error logging
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/stripe_error.log');

// Headers immediati per evitare problemi di output
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Gestisci preflight CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Funzione helper per rispondere con JSON
function sendJsonResponse($success, $message, $data = [], $httpCode = 200) {
    http_response_code($httpCode);
    $response = [
        'success' => $success ? 'true' : 'false',
        'msg' => $message
    ];
    if (!empty($data)) {
        $response = array_merge($response, $data);
    }
    echo json_encode($response, JSON_UNESCAPED_SLASHES);
    exit;
}

// Carica connessione database e configurazione Stripe
$mysqli = null;
$db_available = false;

// Prova a caricare conn.php
if (file_exists(__DIR__ . '/conn.php')) {
    try {
        require_once 'conn.php';
        // Verifica che $mysqli sia definito e valido
        if (isset($mysqli) && $mysqli instanceof mysqli && !$mysqli->connect_error) {
            $db_available = true;
            error_log("✅ Database connection loaded successfully");
        } else {
            error_log("⚠️ conn.php loaded but \$mysqli is not valid");
        }
    } catch (Exception $e) {
        error_log("⚠️ Error loading conn.php: " . $e->getMessage());
    } catch (Throwable $e) {
        error_log("⚠️ Fatal error loading conn.php: " . $e->getMessage());
    }
} else {
    error_log("⚠️ conn.php not found - database operations will be skipped");
}

// Prova a caricare stripe.config.php, altrimenti config_test.php
if (file_exists(__DIR__ . '/stripe.config.php')) {
    try {
        require_once 'stripe.config.php';
        error_log("✅ stripe.config.php loaded");
    } catch (Exception $e) {
        error_log("⚠️ Error loading stripe.config.php: " . $e->getMessage());
    }
} elseif (file_exists(__DIR__ . '/config_test.php')) {
    try {
        require_once 'config_test.php';
        error_log("✅ config_test.php loaded");
    } catch (Exception $e) {
        error_log("⚠️ Error loading config_test.php: " . $e->getMessage());
    }
}

// Se Stripe non è ancora configurato, carica manualmente
if (!class_exists('\Stripe\Stripe') || !method_exists('\Stripe\Stripe', 'setApiKey')) {
    // Fallback: carica Stripe SDK manualmente
    $stripe_loaded = false;
    $direct_path = __DIR__ . '/stripe-php/init.php';
    if (file_exists($direct_path)) {
        require_once $direct_path;
        $stripe_loaded = true;
    }
    
    if (!$stripe_loaded) {
        $composer_path = __DIR__ . '/vendor/autoload.php';
        if (file_exists($composer_path)) {
            require_once $composer_path;
            $stripe_loaded = true;
        }
    }
    
    if (!$stripe_loaded || !class_exists('\Stripe\Stripe')) {
        sendJsonResponse(false, 'Stripe SDK not loaded. Please install Stripe PHP SDK.', [
            'error' => 'stripe_sdk_missing'
        ], 500);
    }
    
    // Configura Stripe con chiave hardcoded (fallback)
    \Stripe\Stripe::setApiKey('sk_test_N950jTKYw562aEty72yLlaEZ');
}

// Headers già impostati sopra

// Solo POST è permesso
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(false, 'Method not allowed. Use POST.', ['error' => 'method_not_allowed'], 405);
}

// ============================================
// VALIDAZIONE PARAMETRI
// ============================================
$user_id = isset($_POST['user_id']) ? trim($_POST['user_id']) : '';
$user_type = isset($_POST['user_type']) ? trim($_POST['user_type']) : 'chef';
$email = isset($_POST['email']) ? trim($_POST['email']) : '';

if (empty($user_id)) {
    sendJsonResponse(false, 'Missing required parameter: user_id', ['error' => 'missing_user_id'], 400);
}

if (empty($email)) {
    sendJsonResponse(false, 'Missing required parameter: email', ['error' => 'missing_email'], 400);
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendJsonResponse(false, 'Invalid email address format', ['error' => 'invalid_email'], 400);
}

// Valida user_type
$valid_user_types = ['chef', 'grocer', 'buyer'];
if (!in_array(strtolower($user_type), $valid_user_types)) {
    $user_type = 'chef'; // Default
}

// ============================================
// VERIFICA SE ESISTE GIÀ UN ACCOUNT STRIPE
// ============================================
$existing_account_id = null;
$table_name = '';
$id_column = '';

if (strtolower($user_type) === 'chef') {
    $table_name = 'chef_master';
    $id_column = 'chef_id';
} else {
    $table_name = 'user_master';
    $id_column = 'user_id';
}

// Verifica se esiste già un account Stripe (solo se database è disponibile)
if ($db_available && $mysqli) {
    try {
        $check_stmt = $mysqli->prepare("
            SELECT stripe_user_id, stripe_account_id 
            FROM {$table_name} 
            WHERE {$id_column} = ? 
            AND active_flag = 'yes' 
            AND delete_flag = 'no'
            LIMIT 1
        ");
        
        if ($check_stmt) {
            $check_stmt->bind_param("s", $user_id);
            $check_stmt->execute();
            $result = $check_stmt->get_result();
            
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                // Controlla sia stripe_user_id che stripe_account_id
                $existing_account_id = $row['stripe_user_id'] ?? $row['stripe_account_id'] ?? null;
                error_log("Found existing Stripe account in database: $existing_account_id");
            }
            
            $check_stmt->close();
        } else {
            error_log("⚠️ Failed to prepare database check statement: " . $mysqli->error);
        }
    } catch (Exception $e) {
        error_log("⚠️ Error checking database for existing account: " . $e->getMessage());
        // Continua senza account esistente
    }
} else {
    error_log("⚠️ Database not available - skipping existing account check");
}

// ============================================
// CONFIGURAZIONE
// ============================================
$country = 'US'; // Cambia se necessario: 'IT', 'GB', 'CA', etc.
$refresh_url = 'https://munchups.com/webservice/stripe_refresh.php';
$return_url = 'https://munchups.com/webservice/stripe_return.php';

// ============================================
// CREA O RECUPERA ACCOUNT STRIPE CONNECT
// ============================================
try {
    $account_id = null;
    
    // Se esiste già un account, usalo
    if (!empty($existing_account_id) && strpos($existing_account_id, 'acct_') === 0) {
        $account_id = $existing_account_id;
        error_log("Using existing Stripe account: $account_id for user: $user_id");
        
        // Verifica che l'account esista ancora su Stripe
        try {
            $account = \Stripe\Account::retrieve($account_id);
            if ($account->charges_enabled || $account->payouts_enabled) {
                // Account già configurato, crea nuovo link solo se necessario
                error_log("Account $account_id is already configured");
            }
        } catch (\Stripe\Exception\InvalidRequestException $e) {
            // Account non esiste più su Stripe, creane uno nuovo
            error_log("Existing account $account_id not found on Stripe, creating new one");
            $account_id = null;
        }
    }
    
    // Se non esiste, crea un nuovo account
    if (empty($account_id)) {
        $account = \Stripe\Account::create([
            'type' => 'express',
            'country' => $country,
            'email' => $email,
            'capabilities' => [
                'card_payments' => ['requested' => true],
                'transfers' => ['requested' => true],
            ],
            'metadata' => [
                'user_id' => $user_id,
                'user_type' => $user_type,
                'app' => 'Munchups',
            ],
        ]);
        
        $account_id = $account->id;
        error_log("Stripe account created: $account_id for user: $user_id");
        
        // Salva nel database (solo se database è disponibile)
        if ($db_available && $mysqli) {
            try {
                $update_stmt = $mysqli->prepare("
                    UPDATE {$table_name} 
                    SET stripe_user_id = ?, 
                        stripe_account_id = ?,
                        updated_at = NOW()
                    WHERE {$id_column} = ?
                ");
                
                if ($update_stmt) {
                    $update_stmt->bind_param("sss", $account_id, $account_id, $user_id);
                    $update_stmt->execute();
                    
                    if ($update_stmt->affected_rows > 0) {
                        error_log("✅ Stripe account_id saved to database for user: $user_id in table: $table_name");
                    } else {
                        error_log("⚠️ No rows updated in database. User may not exist in $table_name or already has this account_id");
                    }
                    
                    $update_stmt->close();
                } else {
                    error_log("⚠️ Failed to prepare database update statement: " . $mysqli->error);
                }
            } catch (Exception $e) {
                error_log("⚠️ Error saving to database: " . $e->getMessage());
                // Non bloccare il processo se il database fallisce
            }
        } else {
            error_log("⚠️ Database not available - account_id not saved to database");
        }
    } else {
        // Usa account esistente
        $account = \Stripe\Account::retrieve($account_id);
    }
    
    // ============================================
    // CREA ACCOUNT LINK PER ONBOARDING
    // ============================================
    // Verifica che AccountLink class esista
    if (!class_exists('\Stripe\AccountLink')) {
        error_log("❌ AccountLink class not found. Stripe SDK version may be too old.");
        
        // Prova a caricare manualmente
        $account_link_file = __DIR__ . '/stripe-php/lib/AccountLink.php';
        if (file_exists($account_link_file)) {
            require_once $account_link_file;
        }
        
        if (!class_exists('\Stripe\AccountLink')) {
            sendJsonResponse(false, 'Stripe SDK version is too old. AccountLink class not available. Please update Stripe PHP SDK to version 7.0.0 or higher.', [
                'error' => 'accountlink_class_missing',
                'account_id' => $account_id,
                'download_url' => 'https://github.com/stripe/stripe-php/releases'
            ], 500);
        }
    }
    
    // Crea Account Link
    error_log("Creating AccountLink for account: $account_id");
    try {
        $accountLink = \Stripe\AccountLink::create([
            'account' => $account_id,
            'refresh_url' => $refresh_url,
            'return_url' => $return_url,
            'type' => 'account_onboarding',
        ]);
        
        error_log("✅ AccountLink created successfully: " . $accountLink->url);
        
        // Successo!
        $response = [
            'success' => 'true',
            'msg' => 'Stripe account created successfully',
            'account_id' => $account_id,
            'account_link_url' => $accountLink->url
        ];
        
        error_log("Sending success response: " . json_encode($response));
        
        // Usa la funzione helper per garantire output corretto
        sendJsonResponse(true, 'Stripe account created successfully', [
            'account_id' => $account_id,
            'account_link_url' => $accountLink->url
        ], 200);
        
    } catch (\Stripe\Exception\ApiErrorException $e) {
        error_log("❌ AccountLink creation failed: " . $e->getMessage());
        throw $e; // Rilancia per essere gestito dal catch principale
    }
    
} catch (\Stripe\Exception\ApiErrorException $e) {
    $error_code = $e->getError()->code ?? 'unknown';
    $error_message = $e->getMessage();
    
    error_log("Stripe API Error [$error_code]: $error_message");
    error_log("Stack trace: " . $e->getTraceAsString());
    
    sendJsonResponse(false, "Stripe API error: $error_message", [
        'error' => $error_code,
        'stripe_error' => true
    ], 500);
    
} catch (\Stripe\Exception\AuthenticationException $e) {
    error_log("Stripe Authentication Error: " . $e->getMessage());
    error_log("Stack trace: " . $e->getTraceAsString());
    
    sendJsonResponse(false, 'Stripe authentication failed. Please check API key configuration.', [
        'error' => 'authentication_error'
    ], 401);
    
} catch (\Stripe\Exception\InvalidRequestException $e) {
    error_log("Stripe Invalid Request: " . $e->getMessage());
    error_log("Stack trace: " . $e->getTraceAsString());
    
    sendJsonResponse(false, 'Invalid request to Stripe: ' . $e->getMessage(), [
        'error' => 'invalid_request'
    ], 400);
    
} catch (Exception $e) {
    $error_message = $e->getMessage();
    $error_file = $e->getFile();
    $error_line = $e->getLine();
    
    error_log("❌ General Error in connect_stripe_account.php");
    error_log("Error: $error_message");
    error_log("File: $error_file");
    error_log("Line: $error_line");
    error_log("Stack trace: " . $e->getTraceAsString());
    
    sendJsonResponse(false, 'Server error: ' . $error_message, [
        'error' => 'server_error',
        'error_type' => get_class($e)
    ], 500);
    
} catch (Throwable $e) {
    // Cattura anche Error (non Exception) - PHP 7+
    $error_message = $e->getMessage();
    $error_file = $e->getFile();
    $error_line = $e->getLine();
    
    error_log("❌ Fatal Error in connect_stripe_account.php");
    error_log("Error: $error_message");
    error_log("File: $error_file");
    error_log("Line: $error_line");
    error_log("Stack trace: " . $e->getTraceAsString());
    
    sendJsonResponse(false, 'Server error. Please check server logs or contact support.', [
        'error' => 'fatal_error'
    ], 500);
}

// Se arriviamo qui, qualcosa è andato storto
error_log("❌ Script reached end without sending response");
sendJsonResponse(false, 'Unexpected error occurred', ['error' => 'unexpected_error'], 500);
?>
