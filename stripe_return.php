<?php
/**
 * stripe_return.php
 * Handles return from Stripe Connect onboarding
 */

require_once 'stripe_config.php';

$account_id = $_GET['account'] ?? '';

?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stripe Account Connected</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        .success-icon {
            width: 80px;
            height: 80px;
            background: #10b981;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 40px;
            color: white;
        }
        h1 {
            color: #1f2937;
            margin: 0 0 10px;
        }
        p {
            color: #6b7280;
            line-height: 1.6;
            margin: 10px 0;
        }
        .button {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: background 0.3s;
        }
        .button:hover {
            background: #5568d3;
        }
        .info {
            background: #f3f4f6;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            font-size: 14px;
            color: #4b5563;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">✓</div>
        <h1>Account Connected Successfully!</h1>
        <p>Your Stripe account has been connected and is ready to receive payments.</p>
        
        <?php if ($account_id): ?>
        <div class="info">
            <strong>Account ID:</strong> <?php echo htmlspecialchars($account_id); ?>
        </div>
        <?php endif; ?>
        
        <p>You can now close this window and return to the app.</p>
        <p style="font-size: 14px; color: #9ca3af; margin-top: 30px;">
            The app will automatically detect that your account is connected.
        </p>
    </div>
    
    <script>
        // Try to close the window if opened in a popup
        setTimeout(function() {
            // If opened in a new window, try to close it
            if (window.opener) {
                window.opener.postMessage('stripe_connected', '*');
                window.close();
            }
        }, 2000);
        
        // Send message to parent if in iframe
        if (window.parent !== window) {
            window.parent.postMessage('stripe_connected', '*');
        }
    </script>
</body>
</html>
