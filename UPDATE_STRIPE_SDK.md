# ⚠️ URGENT: Update Stripe PHP SDK

## Problem Identified

Your Stripe PHP SDK version is **TOO OLD**. The `AccountLink` class is not available in your current version.

**Error from logs:**
```
PHP Fatal error: Class 'Stripe\AccountLink' not found
```

## Solution: Update Stripe PHP SDK

### Option 1: Download Latest Version (RECOMMENDED)

1. **Download the latest Stripe PHP SDK:**
   - Go to: https://github.com/stripe/stripe-php/releases
   - Download the latest release (ZIP file)
   - Or direct download: https://github.com/stripe/stripe-php/archive/refs/heads/master.zip

2. **Replace the old stripe-php folder:**
   - Go to Hostinger File Manager
   - Navigate to: `/public_html/webservice/`
   - **DELETE** the old `stripe-php` folder
   - **UPLOAD** the new `stripe-php` folder from the downloaded ZIP

3. **Verify:**
   - Make sure `stripe-php/lib/AccountLink.php` exists
   - Test with: https://munchups.com/webservice/check_stripe.php

### Option 2: Use Composer (if you have SSH access)

```bash
cd /public_html/webservice/
composer require stripe/stripe-php:^10.0
```

## Required Version

- **Minimum:** Stripe PHP SDK 7.0.0 (for AccountLink support)
- **Recommended:** Latest version (currently 10.x or higher)

## Verification

After updating, check that these files exist:
- ✅ `/webservice/stripe-php/lib/AccountLink.php`
- ✅ `/webservice/stripe-php/lib/Account.php`
- ✅ `/webservice/stripe-php/init.php`

## Test

After updating, test with:
```bash
curl -X POST https://munchups.com/webservice/connect_stripe_account.php \
  -d "user_id=118&user_type=chef&email=test@example.com"
```

You should get:
```json
{
  "success": "true",
  "account_id": "acct_xxxxx",
  "account_link_url": "https://connect.stripe.com/setup/s/xxxxx"
}
```

## Current Status

✅ Stripe SDK is loading correctly
❌ AccountLink class is missing (SDK too old)
✅ Account creation works
❌ AccountLink creation fails

**After updating SDK, everything will work!**

