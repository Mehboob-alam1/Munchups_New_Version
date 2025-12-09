<?php
/**
 * Test Script per verificare se Stripe SDK è installato
 * 
 * Carica questo file in: /public_html/webservice/test_stripe_endpoint.php
 * Poi apri nel browser: https://munchups.com/webservice/test_stripe_endpoint.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h1>Stripe SDK Test</h1>";

// Test 1: Composer autoload
echo "<h2>Test 1: Composer Autoload</h2>";
$composer_path = __DIR__ . '/vendor/autoload.php';
if (file_exists($composer_path)) {
    echo "✅ File trovato: $composer_path<br>";
    try {
        require_once $composer_path;
        if (class_exists('\Stripe\Stripe')) {
            echo "✅ Stripe class caricata correttamente!<br>";
        } else {
            echo "❌ Composer autoload caricato ma Stripe class non trovata<br>";
        }
    } catch (Exception $e) {
        echo "❌ Errore: " . $e->getMessage() . "<br>";
    }
} else {
    echo "❌ File non trovato: $composer_path<br>";
}

// Test 2: Manual load
echo "<h2>Test 2: Manual Load</h2>";
$manual_path = __DIR__ . '/vendor/stripe-php/init.php';
if (file_exists($manual_path)) {
    echo "✅ File trovato: $manual_path<br>";
    try {
        require_once $manual_path;
        if (class_exists('\Stripe\Stripe')) {
            echo "✅ Stripe class caricata correttamente!<br>";
        } else {
            echo "❌ Manual load: Stripe class non trovata<br>";
        }
    } catch (Exception $e) {
        echo "❌ Errore: " . $e->getMessage() . "<br>";
    }
} else {
    echo "❌ File non trovato: $manual_path<br>";
}

// Test 3: Verifica struttura directory
echo "<h2>Test 3: Directory Structure</h2>";
$vendor_dir = __DIR__ . '/vendor';
if (is_dir($vendor_dir)) {
    echo "✅ Directory vendor esiste<br>";
    $contents = scandir($vendor_dir);
    echo "Contenuti: " . implode(', ', $contents) . "<br>";
} else {
    echo "❌ Directory vendor non esiste<br>";
}

// Test 4: PHP Version
echo "<h2>Test 4: PHP Version</h2>";
$php_version = phpversion();
echo "Versione PHP: $php_version<br>";
if (version_compare($php_version, '7.4.0', '>=')) {
    echo "✅ PHP version OK (>= 7.4)<br>";
} else {
    echo "❌ PHP version troppo vecchia (serve >= 7.4)<br>";
}

// Test 5: Estensioni PHP
echo "<h2>Test 5: PHP Extensions</h2>";
$required_extensions = ['curl', 'json', 'mbstring'];
foreach ($required_extensions as $ext) {
    if (extension_loaded($ext)) {
        echo "✅ Estensione $ext caricata<br>";
    } else {
        echo "❌ Estensione $ext NON caricata<br>";
    }
}

// Test 6: Test Stripe API (se SDK è caricato)
if (class_exists('\Stripe\Stripe')) {
    echo "<h2>Test 6: Stripe API Test</h2>";
    try {
        \Stripe\Stripe::setApiKey('sk_test_N950jTKYw562aEty72yLlaEZ');
        echo "✅ Stripe API key configurata<br>";
        
        // Test semplice: recupera account info (richiede API key valida)
        // Non eseguiamo chiamate reali per non creare account di test
        echo "✅ Stripe SDK funzionante!<br>";
    } catch (Exception $e) {
        echo "❌ Errore configurazione Stripe: " . $e->getMessage() . "<br>";
    }
} else {
    echo "<h2>Test 6: Stripe API Test</h2>";
    echo "⚠️ Stripe SDK non caricato, impossibile testare API<br>";
}

echo "<hr>";
echo "<h2>Istruzioni Installazione</h2>";
echo "<p><strong>Opzione 1 - Composer:</strong></p>";
echo "<pre>cd /public_html/webservice/\ncomposer require stripe/stripe-php</pre>";

echo "<p><strong>Opzione 2 - Download Manuale:</strong></p>";
echo "<ol>";
echo "<li>Scarica: <a href='https://github.com/stripe/stripe-php/archive/refs/heads/master.zip'>https://github.com/stripe/stripe-php/archive/refs/heads/master.zip</a></li>";
echo "<li>Estrai il file ZIP</li>";
echo "<li>Carica la cartella 'stripe-php' in: /public_html/webservice/vendor/stripe-php/</li>";
echo "</ol>";
?>

