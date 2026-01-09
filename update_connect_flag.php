<?php
/**
 * update_connect_flag.php
 * Simple script to manually update connect_flag
 * 
 * Usage: https://munchups.com/webservice/update_connect_flag.php?user_id=118
 */

require_once 'stripe_config.php';

// Get user_id from query string
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : null;

if (!$user_id) {
    sendResponse(false, 'user_id parameter is required');
}

try {
    // Get user info
    $stmt = $pdo->prepare("SELECT user_id, user_type, stripe_account_id FROM user_master WHERE user_id = ?");
    $stmt->execute([$user_id]);
    $user = $stmt->fetch();

    if (!$user) {
        sendResponse(false, 'User not found');
    }

    $user_type = $user['user_type'] ?? 'chef';

    // Check if connect_flag column exists, if not create it
    try {
        $stmt = $pdo->prepare("SELECT connect_flag FROM user_master WHERE user_id = ? LIMIT 1");
        $stmt->execute([$user_id]);
        $stmt->fetch();
    } catch (PDOException $e) {
        if (strpos($e->getMessage(), 'connect_flag') !== false || 
            strpos($e->getMessage(), "doesn't exist") !== false ||
            strpos($e->getMessage(), "Unknown column") !== false) {
            try {
                $pdo->exec("ALTER TABLE user_master ADD COLUMN connect_flag VARCHAR(10) DEFAULT 'no'");
            } catch (PDOException $addError) {
                // Column might have been created by another request
            }
        }
    }

    // Update connect_flag
    $stmt = $pdo->prepare("UPDATE user_master SET connect_flag = 'yes' WHERE user_id = ? AND user_type = ?");
    $stmt->execute([$user_id, $user_type]);
    
    $rowsAffected = $stmt->rowCount();
    
    if ($rowsAffected > 0) {
        // Get updated value
        $stmt = $pdo->prepare("SELECT connect_flag FROM user_master WHERE user_id = ?");
        $stmt->execute([$user_id]);
        $result = $stmt->fetch();
        
        sendResponse(true, 'connect_flag updated successfully', [
            'user_id' => $user_id,
            'connect_flag' => $result['connect_flag'] ?? 'yes',
            'rows_affected' => $rowsAffected
        ]);
    } else {
        sendResponse(false, 'Update executed but no rows were affected');
    }

} catch (Exception $e) {
    logErrorSecure('Error in update_connect_flag', [
        'user_id' => $user_id,
        'error' => $e->getMessage()
    ]);
    sendResponse(false, 'Failed to update connect_flag: ' . $e->getMessage());
}
?>





