<?php
/**
 * stripe_config.php
 * Central Stripe + DB configuration + safe helpers
 */

// Error logging to file (not to the client)
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/stripe_errors.log');

// 1) Stripe API Keys (test keys for now – OK on staging)
define('STRIPE_SECRET_KEY', 'sk_test_N950jTKYw562aEty72yLlaEZ');
define('STRIPE_PUBLISHABLE_KEY', 'pk_test_Qv6FioIn5wfwiVyeQ059x3TQ');

// 2) Load Stripe SDK (support both composer and direct include)
$stripeLoaded = false;

$pathDirect   = __DIR__ . '/stripe-php/init.php';
$pathComposer = __DIR__ . '/vendor/autoload.php';

if (file_exists($pathDirect)) {
    require_once $pathDirect;
    if (class_exists('\Stripe\Stripe')) {
        $stripeLoaded = true;
    }
} elseif (file_exists($pathComposer)) {
    require_once $pathComposer;
    if (class_exists('\Stripe\Stripe')) {
        $stripeLoaded = true;
    }
}

if (!$stripeLoaded) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => 'false',
        'msg'     => 'Stripe SDK not installed on server'
    ]);
    exit;
}

\Stripe\Stripe::setApiKey(STRIPE_SECRET_KEY);

// 3) Commission & currency
define('PLATFORM_COMMISSION_PERCENT', 10); // 10%
define('CURRENCY', 'usd');

// 4) Database configuration
// NOTE: update these values to match your Hostinger MySQL
$dbHost = 'localhost';
$dbName = 'u171987346_munchup';
$dbUser = 'u171987346_munchup';
$dbPass = 'Munchups123';

try {
    $pdo = new PDO(
        "mysql:host={$dbHost};dbname={$dbName};charset=utf8mb4",
        $dbUser,
        $dbPass,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => 'false',
        'msg'     => 'Database connection failed: ' . $e->getMessage(),
    ]);
    error_log('DB connection error: ' . $e->getMessage());
    exit;
}

// 5) Helper: JSON response (matches Flutter expectations)
function sendResponse($success, $message, array $data = [], int $httpCode = 200)
{
    http_response_code($httpCode);
    header('Content-Type: application/json; charset=utf-8');

    $payload = array_merge([
        'success' => $success ? 'true' : 'false',
        'msg'     => $message,
    ], $data);

    echo json_encode($payload);
    exit;
}

// 6) Helper: fee calculation
function calculatePlatformFee(float $amount): float
{
    return round($amount * (PLATFORM_COMMISSION_PERCENT / 100), 2);
}

// 7) Helper: secure error logging (new name)
function logErrorSecure(string $msg, array $context = []): void
{
    $line  = date('Y-m-d H:i:s') . ' - ' . $msg . PHP_EOL;
    $line .= 'Context: ' . json_encode($context) . PHP_EOL;
    $line .= str_repeat('=', 60) . PHP_EOL;
    @file_put_contents(__DIR__ . '/stripe_errors.log', $line, FILE_APPEND);
}

// 8) Backwards compatibility: provide logError() if old code calls it
if (!function_exists('logError')) {
    function logError(string $msg, array $context = []): void
    {
        logErrorSecure($msg, $context);
    }
}

?>


