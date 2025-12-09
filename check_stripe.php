<?php
/**
 * Simple Stripe SDK Check
 * 
 * Open this in browser: https://munchups.com/webservice/check_stripe.php
 */

header('Content-Type: application/json');

$result = [
    'current_directory' => __DIR__,
    'paths_checked' => [],
    'stripe_loaded' => false,
    'error' => null
];

// Check path 1: Composer
$path1 = __DIR__ . '/vendor/autoload.php';
$result['paths_checked']['composer'] = [
    'path' => $path1,
    'exists' => file_exists($path1)
];

// Check path 2: Direct stripe-php
$path2 = __DIR__ . '/stripe-php/init.php';
$result['paths_checked']['direct'] = [
    'path' => $path2,
    'exists' => file_exists($path2)
];

// Check path 3: Vendor stripe-php
$path3 = __DIR__ . '/vendor/stripe-php/init.php';
$result['paths_checked']['vendor'] = [
    'path' => $path3,
    'exists' => file_exists($path3)
];

// Try to load
if (file_exists($path2)) {
    try {
        require_once $path2;
        if (class_exists('\Stripe\Stripe')) {
            $result['stripe_loaded'] = true;
            $result['loaded_from'] = 'direct path';
        }
    } catch (Exception $e) {
        $result['error'] = $e->getMessage();
    }
} elseif (file_exists($path1)) {
    try {
        require_once $path1;
        if (class_exists('\Stripe\Stripe')) {
            $result['stripe_loaded'] = true;
            $result['loaded_from'] = 'composer';
        }
    } catch (Exception $e) {
        $result['error'] = $e->getMessage();
    }
} elseif (file_exists($path3)) {
    try {
        require_once $path3;
        if (class_exists('\Stripe\Stripe')) {
            $result['stripe_loaded'] = true;
            $result['loaded_from'] = 'vendor path';
        }
    } catch (Exception $e) {
        $result['error'] = $e->getMessage();
    }
}

// List directory contents
$result['directory_contents'] = [];
if (is_dir(__DIR__)) {
    $contents = scandir(__DIR__);
    $result['directory_contents'] = array_filter($contents, function($item) {
        return $item !== '.' && $item !== '..';
    });
    $result['directory_contents'] = array_values($result['directory_contents']);
}

echo json_encode($result, JSON_PRETTY_PRINT);
?>

