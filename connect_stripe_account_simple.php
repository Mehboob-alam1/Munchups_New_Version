<?php
/**
 * Stripe Connect Account Endpoint - Versione Semplificata
 * 
 * Questa versione NON richiede Composer
 * Carica Stripe SDK manualmente
 * 
 * CARICA QUESTO FILE IN:
 * /public_html/webservice/connect_stripe_account.php
 */

// ⚠️ IMPORTANTE: Scarica Stripe PHP SDK e caricalo in /vendor/stripe-php/
// Download: https://github.com/stripe/stripe-php/archive/refs/heads/master.zip
// Estrai e carica la cartella "stripe-php" in /public_html/webservice/vendor/

// Carica Stripe SDK manualmente
$stripe_path = __DIR__ . '/vendor/stripe-php/init.php';
if (file_exists($stripe_path)) {
    require_once $stripe_path;
} else {
    // Fallback: prova con autoload di Composer
    $composer_autoload = __DIR__ . '/vendor/autoload.php';
    if (file_exists($composer_autoload)) {
        require_once $composer_autoload;
    } else {
        http_response_code(500);
        echo json_encode([
            'success' => 'false',
            'msg' => 'Stripe PHP SDK not found. Please install it.'
        ]);
        exit;
    }
}

// ⚠️ SECURITY: Questa chiave deve essere SOLO sul server, mai nel frontend!
$stripe_secret_key = 'sk_test_N950jTKYw562aEty72yLlaEZ';
\Stripe\Stripe::setApiKey($stripe_secret_key);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Gestisci preflight CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Solo POST è permesso
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => 'false',
        'msg' => 'Method not allowed. Use POST.'
    ]);
    exit;
}

// Ricevi i parametri
$user_id = $_POST['user_id'] ?? '';
$user_type = $_POST['user_type'] ?? 'chef';
$email = $_POST['email'] ?? '';

// Validazione
if (empty($user_id) || empty($email)) {
    http_response_code(400);
    echo json_encode([
        'success' => 'false',
        'msg' => 'Missing required parameters: user_id and email are required'
    ]);
    exit;
}

// Validazione email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode([
        'success' => 'false',
        'msg' => 'Invalid email address'
    ]);
    exit;
}

// ⚠️ CONFIGURA: Modifica queste variabili secondo le tue esigenze
$country = 'US'; // Cambia con: 'IT', 'GB', 'CA', etc.
$refresh_url = 'https://munchups.com/app/refresh'; // Cambia con il tuo URL
$return_url = 'https://munchups.com/app/return';   // Cambia con il tuo URL

// ⚠️ CONFIGURA: Credenziali database (se vuoi salvare l'account_id)
$db_host = 'localhost'; // Modifica se necessario
$db_name = 'tuo_database'; // Modifica
$db_user = 'tuo_username'; // Modifica
$db_pass = 'tua_password'; // Modifica

try {
    // Crea nuovo account Stripe Connect
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
        ],
    ]);
    
    $account_id = $account->id;
    
    // ⚠️ OPZIONALE: Salva l'account_id nel database
    // Decommenta e configura se vuoi salvare nel database
    /*
    try {
        $pdo = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $stmt = $pdo->prepare("UPDATE users SET stripe_account_id = ? WHERE user_id = ?");
        $stmt->execute([$account_id, $user_id]);
    } catch (PDOException $e) {
        // Log error but continue (non critico)
        error_log("Database error: " . $e->getMessage());
    }
    */
    
    // Crea il link di onboarding
    $accountLink = \Stripe\AccountLink::create([
        'account' => $account_id,
        'refresh_url' => $refresh_url,
        'return_url' => $return_url,
        'type' => 'account_onboarding',
    ]);
    
    // Risposta di successo
    http_response_code(200);
    echo json_encode([
        'success' => 'true',
        'account_id' => $account_id,
        'account_link_url' => $accountLink->url,
        'msg' => 'Stripe account created successfully'
    ]);
    
} catch (\Stripe\Exception\ApiErrorException $e) {
    // Errore da Stripe
    http_response_code(500);
    echo json_encode([
        'success' => 'false',
        'msg' => 'Stripe error: ' . $e->getMessage(),
        'error' => $e->getError()->code ?? 'unknown'
    ]);
    
} catch (Exception $e) {
    // Errore generico
    http_response_code(500);
    echo json_encode([
        'success' => 'false',
        'msg' => 'Server error: ' . $e->getMessage()
    ]);
}
?>

