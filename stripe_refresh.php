<?php
/**
 * stripe_refresh.php
 * Refreshes Stripe Connect onboarding link
 */

require_once 'stripe_config.php';

$account_id = $_GET['account'] ?? '';

?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Stripe Setup</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        .info-icon {
            width: 80px;
            height: 80px;
            background: #f59e0b;
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
            background: #f59e0b;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: background 0.3s;
        }
        .button:hover {
            background: #d97706;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="info-icon">ℹ</div>
        <h1>Additional Information Required</h1>
        <p>Stripe needs some additional information to complete your account setup.</p>
        <p>Please return to the app and try connecting again, or complete the setup directly on Stripe.</p>
        
        <?php if ($account_id): ?>
        <p style="font-size: 14px; color: #9ca3af; margin-top: 20px;">
            Account ID: <?php echo htmlspecialchars($account_id); ?>
        </p>
        <?php endif; ?>
        
        <p style="font-size: 14px; color: #9ca3af; margin-top: 30px;">
            You can close this window and return to the app.
        </p>
    </div>
    
    <script>
        setTimeout(function() {
            if (window.opener) {
                window.opener.postMessage('stripe_refresh', '*');
                window.close();
            }
        }, 2000);
    </script>
</body>
</html>
