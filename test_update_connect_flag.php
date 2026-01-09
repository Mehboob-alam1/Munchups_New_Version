<?php
/**
 * test_update_connect_flag.php
 * Diagnostic script to test and debug connect_flag updates
 * 
 * Usage: https://munchups.com/webservice/test_update_connect_flag.php?user_id=118
 */

require_once 'stripe_config.php';

// Get user_id from query string
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : null;

if (!$user_id) {
    die('Error: user_id parameter is required. Usage: test_update_connect_flag.php?user_id=118');
}

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html>
<head>
    <title>Connect Flag Diagnostic Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 8px; max-width: 900px; }
        h1 { color: #333; }
        .section { margin: 20px 0; padding: 15px; background: #f9f9f9; border-left: 4px solid #007bff; }
        .success { border-left-color: #28a745; background: #d4edda; }
        .error { border-left-color: #dc3545; background: #f8d7da; }
        .warning { border-left-color: #ffc107; background: #fff3cd; }
        pre { background: #2d2d2d; color: #f8f8f2; padding: 15px; border-radius: 4px; overflow-x: auto; }
        .label { font-weight: bold; color: #555; }
        .value { color: #333; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #007bff; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Connect Flag Diagnostic Test</h1>
        <p><strong>User ID:</strong> <?php echo htmlspecialchars($user_id); ?></p>
        
        <?php
        try {
            // 1. Check if user exists
            echo '<div class="section">';
            echo '<h2>1. User Check</h2>';
            
            $stmt = $pdo->prepare("SELECT user_id, user_type, email, stripe_account_id FROM user_master WHERE user_id = ?");
            $stmt->execute([$user_id]);
            $user = $stmt->fetch();
            
            if ($user) {
                echo '<div class="success">';
                echo '<p>✅ User found in database</p>';
                echo '<table>';
                echo '<tr><th>Field</th><th>Value</th></tr>';
                foreach ($user as $key => $value) {
                    echo '<tr><td class="label">' . htmlspecialchars($key) . '</td><td class="value">' . htmlspecialchars($value ?? 'NULL') . '</td></tr>';
                }
                echo '</table>';
                echo '</div>';
            } else {
                echo '<div class="error">';
                echo '<p>❌ User not found in database</p>';
                echo '</div>';
                die('</div></div></body></html>');
            }
            echo '</div>';
            
            // 2. Check if connect_flag column exists
            echo '<div class="section">';
            echo '<h2>2. Column Check</h2>';
            
            try {
                $stmt = $pdo->prepare("DESCRIBE user_master");
                $stmt->execute();
                $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                $hasConnectFlag = false;
                foreach ($columns as $col) {
                    if ($col['Field'] === 'connect_flag') {
                        $hasConnectFlag = true;
                        echo '<div class="success">';
                        echo '<p>✅ connect_flag column exists</p>';
                        echo '<table>';
                        echo '<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>';
                        echo '<tr>';
                        echo '<td>' . htmlspecialchars($col['Field']) . '</td>';
                        echo '<td>' . htmlspecialchars($col['Type']) . '</td>';
                        echo '<td>' . htmlspecialchars($col['Null']) . '</td>';
                        echo '<td>' . htmlspecialchars($col['Key']) . '</td>';
                        echo '<td>' . htmlspecialchars($col['Default'] ?? 'NULL') . '</td>';
                        echo '<td>' . htmlspecialchars($col['Extra'] ?? '') . '</td>';
                        echo '</tr>';
                        echo '</table>';
                        echo '</div>';
                        break;
                    }
                }
                
                if (!$hasConnectFlag) {
                    echo '<div class="warning">';
                    echo '<p>⚠️ connect_flag column does NOT exist</p>';
                    echo '<p>We will try to create it...</p>';
                    echo '</div>';
                    
                    try {
                        $pdo->exec("ALTER TABLE user_master ADD COLUMN connect_flag VARCHAR(10) DEFAULT 'no'");
                        echo '<div class="success">';
                        echo '<p>✅ Successfully created connect_flag column</p>';
                        echo '</div>';
                    } catch (PDOException $e) {
                        echo '<div class="error">';
                        echo '<p>❌ Failed to create column: ' . htmlspecialchars($e->getMessage()) . '</p>';
                        echo '</div>';
                    }
                }
            } catch (PDOException $e) {
                echo '<div class="error">';
                echo '<p>❌ Error checking columns: ' . htmlspecialchars($e->getMessage()) . '</p>';
                echo '</div>';
            }
            echo '</div>';
            
            // 3. Get current connect_flag value
            echo '<div class="section">';
            echo '<h2>3. Current Value</h2>';
            
            try {
                $stmt = $pdo->prepare("SELECT connect_flag FROM user_master WHERE user_id = ?");
                $stmt->execute([$user_id]);
                $result = $stmt->fetch();
                
                if ($result) {
                    $currentFlag = $result['connect_flag'] ?? 'NULL';
                    echo '<p><span class="label">Current connect_flag:</span> <span class="value">' . htmlspecialchars($currentFlag) . '</span></p>';
                } else {
                    echo '<div class="error">';
                    echo '<p>❌ Could not retrieve current value</p>';
                    echo '</div>';
                }
            } catch (PDOException $e) {
                echo '<div class="error">';
                echo '<p>❌ Error retrieving current value: ' . htmlspecialchars($e->getMessage()) . '</p>';
                echo '</div>';
            }
            echo '</div>';
            
            // 4. Test update methods
            echo '<div class="section">';
            echo '<h2>4. Update Test</h2>';
            
            $user_type = $user['user_type'] ?? 'chef';
            
            // Method 1: Update with WHERE clause
            echo '<h3>Method 1: UPDATE with WHERE clause</h3>';
            try {
                $stmt = $pdo->prepare("UPDATE user_master SET connect_flag = 'yes' WHERE user_id = ? AND user_type = ?");
                $stmt->execute([$user_id, $user_type]);
                $rowsAffected = $stmt->rowCount();
                
                if ($rowsAffected > 0) {
                    echo '<div class="success">';
                    echo '<p>✅ Update successful! Rows affected: ' . $rowsAffected . '</p>';
                    echo '</div>';
                } else {
                    echo '<div class="warning">';
                    echo '<p>⚠️ Update executed but no rows were affected</p>';
                    echo '</div>';
                }
            } catch (PDOException $e) {
                echo '<div class="error">';
                echo '<p>❌ Update failed: ' . htmlspecialchars($e->getMessage()) . '</p>';
                echo '</div>';
            }
            
            // Method 2: Update without user_type
            echo '<h3>Method 2: UPDATE without user_type</h3>';
            try {
                $stmt = $pdo->prepare("UPDATE user_master SET connect_flag = 'yes' WHERE user_id = ?");
                $stmt->execute([$user_id]);
                $rowsAffected = $stmt->rowCount();
                
                if ($rowsAffected > 0) {
                    echo '<div class="success">';
                    echo '<p>✅ Update successful! Rows affected: ' . $rowsAffected . '</p>';
                    echo '</div>';
                } else {
                    echo '<div class="warning">';
                    echo '<p>⚠️ Update executed but no rows were affected</p>';
                    echo '</div>';
                }
            } catch (PDOException $e) {
                echo '<div class="error">';
                echo '<p>❌ Update failed: ' . htmlspecialchars($e->getMessage()) . '</p>';
                echo '</div>';
            }
            echo '</div>';
            
            // 5. Verify update
            echo '<div class="section">';
            echo '<h2>5. Verification</h2>';
            
            try {
                $stmt = $pdo->prepare("SELECT user_id, user_type, stripe_account_id, connect_flag FROM user_master WHERE user_id = ?");
                $stmt->execute([$user_id]);
                $updated = $stmt->fetch();
                
                if ($updated) {
                    $newFlag = $updated['connect_flag'] ?? 'NULL';
                    
                    if ($newFlag === 'yes') {
                        echo '<div class="success">';
                        echo '<p>✅ connect_flag is now set to "yes"</p>';
                        echo '</div>';
                    } else {
                        echo '<div class="warning">';
                        echo '<p>⚠️ connect_flag is still: ' . htmlspecialchars($newFlag) . '</p>';
                        echo '</div>';
                    }
                    
                    echo '<table>';
                    echo '<tr><th>Field</th><th>Value</th></tr>';
                    foreach ($updated as $key => $value) {
                        echo '<tr><td class="label">' . htmlspecialchars($key) . '</td><td class="value">' . htmlspecialchars($value ?? 'NULL') . '</td></tr>';
                    }
                    echo '</table>';
                } else {
                    echo '<div class="error">';
                    echo '<p>❌ Could not verify update</p>';
                    echo '</div>';
                }
            } catch (PDOException $e) {
                echo '<div class="error">';
                echo '<p>❌ Error verifying: ' . htmlspecialchars($e->getMessage()) . '</p>';
                echo '</div>';
            }
            echo '</div>';
            
            // 6. Summary
            echo '<div class="section">';
            echo '<h2>6. Summary</h2>';
            echo '<p><strong>User ID:</strong> ' . htmlspecialchars($user_id) . '</p>';
            echo '<p><strong>User Type:</strong> ' . htmlspecialchars($user_type) . '</p>';
            echo '<p><strong>Stripe Account ID:</strong> ' . htmlspecialchars($user['stripe_account_id'] ?? 'NULL') . '</p>';
            
            $stmt = $pdo->prepare("SELECT connect_flag FROM user_master WHERE user_id = ?");
            $stmt->execute([$user_id]);
            $final = $stmt->fetch();
            $finalFlag = $final['connect_flag'] ?? 'NULL';
            echo '<p><strong>Final connect_flag:</strong> <span style="color: ' . ($finalFlag === 'yes' ? 'green' : 'red') . '; font-weight: bold;">' . htmlspecialchars($finalFlag) . '</span></p>';
            echo '</div>';
            
        } catch (Exception $e) {
            echo '<div class="error">';
            echo '<h2>❌ Fatal Error</h2>';
            echo '<p>' . htmlspecialchars($e->getMessage()) . '</p>';
            echo '<pre>' . htmlspecialchars($e->getTraceAsString()) . '</pre>';
            echo '</div>';
        }
        ?>
        
        <div class="section">
            <h2>📝 Notes</h2>
            <ul>
                <li>This script tests all update methods</li>
                <li>If connect_flag column doesn't exist, it will try to create it</li>
                <li>Check the results above to see which method worked</li>
                <li>Use this information to fix the update_stripe_status.php endpoint</li>
            </ul>
        </div>
    </div>
</body>
</html>





