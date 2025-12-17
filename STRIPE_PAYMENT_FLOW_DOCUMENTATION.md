# 💳 Complete Documentation: Stripe Payment Flow in Munchups

## 📋 Overview

Munchups is a marketplace platform that connects **Buyers** (customers) with **Chefs** and **Grocers** (sellers). Payments use **Stripe** with **Stripe Connect** to allow sellers to receive payments directly.

---

## 🏗️ System Architecture

### App Modules

1. **👤 Buyer** - Customer who buys food
2. **👨‍🍳 Chef** - Cook who sells dishes
3. **🛒 Grocer** - Store that sells ingredients
4. **👨‍💼 Admin** - Platform administrator

### Stripe Components

- **Stripe Customer** - The buyer who pays
- **Stripe Connect Account** - The chef/grocer account that receives payments
- **Platform Account** - Munchups' main account (for commissions)

---

## 🔄 Complete Payment Flow

### Phase 1: Initial Setup

#### 1.1 Buyer - Save Credit Card

**File:** `lib/Screens/Buyer/Card Payment/card_payment_form.dart`

**Process:**
1. Buyer enters card details (number, expiry, CVV)
2. App creates a `PaymentMethod` using Stripe SDK:
   ```dart
   final paymentMethod = await Stripe.instance.createPaymentMethod(
     params: PaymentMethodParams.card(
       paymentMethodData: PaymentMethodData(billingDetails: billingDetails)
     )
   );
   ```
3. The `paymentMethod.id` is sent to backend via `customerTokenTestApi()`

**Backend API:** `customerTokenTestApi(token)`
- **Endpoint:** `customer_token_test.php`
- **Parameters:**
  - `user_id`: Buyer ID
  - `token`: PaymentMethod ID from Stripe
- **Action:** Creates a `Stripe Customer` and saves `customer_id` in database
- **Database:** Saves `customer_id` and `token` in `user_master` for the buyer

**Backend PHP File:** `stripe_customer.php` (based on files you shared)
- Creates a Stripe Customer
- Saves `customer_id` in database
- Returns success/error

---

#### 1.2 Chef/Grocer - Connect Stripe Account

**File:** `lib/Screens/Chef/manage_account.dart`

**Process:**
1. Chef/Grocer clicks "Connect Stripe Account"
2. App calls `connectStripeAccountApi()` with:
   - `user_id`
   - `user_type` ('chef' or 'grocer')
   - `email`

**Backend API:** `connectStripeAccountApi(body)`
- **Endpoint:** `connect_stripe_account.php`
- **Action:**
  1. Checks if Stripe Connect account already exists for user
  2. If not, creates new `Stripe Account` (Express type)
  3. Generates `AccountLink` for onboarding
  4. Saves `stripe_account_id` in database (`chef_master` or `user_master`)
- **Response:** Returns `account_link_url` to complete onboarding

**Stripe Onboarding:**
- Chef/Grocer is redirected to Stripe to complete:
  - Personal information
  - Bank details
  - Identity verification
- After completion, returns to app via `stripe_return.php`

**Database:**
- `chef_master.stripe_user_id` or `chef_master.stripe_account_id`
- `user_master.stripe_user_id` or `user_master.stripe_account_id`

---

### Phase 2: Order and Payment Process

#### 2.1 Buyer - Create Order and Pay

**File:** `lib/Screens/Buyer/Card Payment/card_payment_form.dart`

**Flow:**
1. Buyer adds dishes to cart
2. Buyer goes to checkout
3. If no saved card, enters card details
4. App creates `PaymentMethod` and calls `customerTokenTestApi()`
5. If type is `'order'`, after saving card calls `orderPlaceApi()`

**Backend API:** `orderPlaceApi(body)`
- **Endpoint:** `order_dish_test.php`
- **Parameters:**
  ```dart
  {
    'user_id': buyer_id,
    'chef_grocer_id': chef/grocer_id,
    'dish_id': dish_id,
    'dish_name': dish_name,
    'quantity': quantity,
    'dish_price': price,
    'total_price': total,
    'grand_total': total,
    'note': notes
  }
  ```
- **Backend Action:**
  1. Creates order in database with status `'pending'`
  2. **Processes Stripe payment:**
     - Uses buyer's `customer_id`
     - Creates a `Charge` or `PaymentIntent` on Stripe
     - **IMPORTANT:** Payment is likely held (hold) or processed immediately
  3. Saves order with:
     - `order_id`
     - `status: 'pending'`
     - `payment_status: 'paid'` or `'pending'`
     - `stripe_charge_id` or `stripe_payment_intent_id`

**Note:** Backend must handle Stripe payment. I don't see the PHP code for this, but it should be similar to:
```php
// In backend (order_dish_test.php or similar)
$charge = \Stripe\Charge::create([
    'amount' => $total_price * 100, // in cents
    'currency' => 'usd',
    'customer' => $buyer_customer_id,
    'description' => "Order #{$order_id}",
    'metadata' => [
        'order_id' => $order_id,
        'buyer_id' => $buyer_id,
        'chef_id' => $chef_id
    ]
]);
```

---

#### 2.2 Chef/Grocer - Order Management

**File:** `lib/Screens/Chef/Chef Orders/chef_myorder_list.dart`

**Order Statuses:**
1. **`'pending'`** - Order just created, awaiting acceptance
2. **`'accept'`** - Chef/Grocer has accepted the order
3. **`'decline'`** - Chef/Grocer has declined the order
4. **`'reject'`** - Chef/Grocer has rejected after accepting
5. **`'completed'`** - Order completed and delivered
6. **`'delivered'`** - Order delivered to buyer

**Backend API:** `changeOrderStatusApi(orderID, buyerID, amount, status)`
- **Endpoint:** `accept_reject_test.php`
- **Parameters:**
  - `chef_grocer_id`: Chef/grocer ID
  - `order_id`: Order ID
  - `user_id`: Buyer ID
  - `amount`: Order amount
  - `status`: New status ('accept', 'decline', 'reject', 'completed')

**Backend Action when Chef accepts:**
- Updates order status to `'accept'`
- **No money transfer yet** (payment already processed)

**Backend Action when Chef completes:**
- Updates status to `'completed'`
- **Transfers money to Chef/Grocer:**
  ```php
  // In backend (accept_reject_test.php when status = 'completed')
  $transfer = \Stripe\Transfer::create([
      'amount' => $amount * 100, // in cents
      'currency' => 'usd',
      'destination' => $chef_stripe_account_id, // Stripe Connect account
      'metadata' => [
          'order_id' => $order_id,
          'type' => 'order_payment'
      ]
  ]);
  ```
- **Platform Commission:** If Munchups takes a commission (e.g., 10%):
  ```php
  $platform_fee = $amount * 0.10; // 10% commission
  $chef_amount = $amount - $platform_fee;
  
  $transfer = \Stripe\Transfer::create([
      'amount' => $chef_amount * 100,
      'currency' => 'usd',
      'destination' => $chef_stripe_account_id,
      'application_fee_amount' => $platform_fee * 100 // Commission
  ]);
  ```

**Backend Action when Chef rejects/declines:**
- Updates status to `'decline'` or `'reject'`
- **Refunds the buyer:**
  ```php
  // In backend
  $refund = \Stripe\Refund::create([
      'charge' => $stripe_charge_id,
      'amount' => $amount * 100, // Full refund
      'metadata' => [
          'order_id' => $order_id,
          'reason' => 'chef_declined'
      ]
  ]);
  ```

---

### Phase 3: Completion and Delivery

#### 3.1 Buyer - Verify OTP and Confirm Delivery

**File:** `lib/Comman widgets/alert boxes/order_confirmation_popup.dart`

**Process:**
1. When order is `'completed'`, buyer receives an OTP
2. Buyer enters OTP to confirm delivery
3. App calls `completeOrderOtpVerifyApi()`

**Backend API:** `completeOrderOtpVerifyApi(orderNumber, otp, buyerId)`
- **Endpoint:** `mark_complete.php`
- **Parameters:**
  - `chef_grocer_id`: Chef/grocer ID
  - `order_unique_number`: Unique order number
  - `payment_otp`: OTP entered by buyer
  - `user_id`: Buyer ID
- **Action:**
  1. Verifies OTP
  2. If correct, updates status to `'delivered'`
  3. **Finalizes transfer to Chef** (if not already done)
  4. Updates `payment_status` to `'completed'`

---

## 📊 Flow Diagram

```
┌─────────┐
│  BUYER  │
└────┬────┘
     │
     │ 1. Enters card
     │ 2. Creates PaymentMethod
     │ 3. Saves Customer (customerTokenTestApi)
     ▼
┌─────────────────┐
│  BACKEND API    │
│ customer_token  │
│ _test.php       │
└────┬────────────┘
     │
     │ Creates Stripe Customer
     │ Saves customer_id in DB
     ▼
┌─────────┐
│  BUYER  │
└────┬────┘
     │
     │ 4. Creates order
     │ 5. Pays (orderPlaceApi)
     ▼
┌─────────────────┐
│  BACKEND API    │
│ order_dish_test │
│ .php            │
└────┬────────────┘
     │
     │ Creates order (status: pending)
     │ Processes Stripe payment
     │ (Charge/PaymentIntent)
     ▼
┌─────────────┐
│   ORDER     │
│  (pending)  │
└────┬───────┘
     │
     │ 6. Notifies Chef
     ▼
┌─────────┐
│  CHEF   │
└────┬────┘
     │
     │ 7. Accepts/Declines
     │ (changeOrderStatusApi)
     ▼
┌─────────────────────┐
│  BACKEND API        │
│ accept_reject_test  │
│ .php                │
└────┬────────────────┘
     │
     ├─ If ACCEPTS → status: 'accept'
     │
     ├─ If DECLINES → status: 'decline'
     │              → Refunds buyer
     │
     │ 8. Chef completes order
     │    (status: 'completed')
     │
     ▼
┌─────────────────────┐
│  BACKEND API        │
│ accept_reject_test  │
│ .php                │
└────┬────────────────┘
     │
     │ Transfers money to Chef
     │ (Stripe Transfer)
     │
     ▼
┌─────────┐
│  BUYER  │
└────┬────┘
     │
     │ 9. Verifies OTP
     │ (completeOrderOtpVerifyApi)
     │
     ▼
┌─────────────────────┐
│  BACKEND API        │
│ mark_complete.php   │
└────┬────────────────┘
     │
     │ Status: 'delivered'
     │ Payment finalized
     ▼
┌─────────────┐
│   ORDER     │
│ (delivered) │
└─────────────┘
```

---

## 🔑 Stripe API Keys

### Frontend (Flutter)
- **Publishable Key:** `pk_test_Qv6FioIn5wfwiVyeQ059x3TQ`
- **File:** `lib/main.dart`
- **Usage:** Create PaymentMethod, initialize Stripe SDK

### Backend (PHP)
- **Secret Key:** `sk_test_N950jTKYw562aEty72yLlaEZ`
- **File:** `connect_stripe_account.php`, `stripe_customer.php`, etc.
- **Usage:** Create Customer, Charge, Transfer, Refund

---

## 📁 Key System Files

### Frontend (Flutter)

1. **`lib/main.dart`**
   - Initializes Stripe with publishable key

2. **`lib/Screens/Buyer/Card Payment/card_payment_form.dart`**
   - Form to enter credit card
   - Creates PaymentMethod
   - Calls `customerTokenTestApi()` and `orderPlaceApi()`

3. **`lib/Screens/Chef/manage_account.dart`**
   - Stripe Connect account connection
   - Calls `connectStripeAccountApi()`

4. **`lib/Screens/Chef/Chef Orders/chef_myorder_list.dart`**
   - Chef order management
   - Accept/Decline/Complete orders
   - Calls `changeOrderStatusApi()`

5. **`lib/Apis/post_apis.dart`**
   - `customerTokenTestApi()` - Saves buyer card
   - `orderPlaceApi()` - Creates order and pays
   - `connectStripeAccountApi()` - Connects chef account
   - `changeOrderStatusApi()` - Changes order status

6. **`lib/Apis/get_apis.dart`**
   - `completeOrderOtpVerifyApi()` - Verifies OTP and completes order

### Backend (PHP)

1. **`connect_stripe_account.php`**
   - Creates Stripe Connect account for chef/grocer
   - Generates AccountLink for onboarding

2. **`customer_token_test.php`**
   - Creates Stripe Customer for buyer
   - Saves customer_id in database
   - Receives PaymentMethod token from frontend

3. **`order_dish_test.php`**
   - Creates order in database
   - Processes Stripe payment (Charge/PaymentIntent)

4. **`accept_reject_test.php`**
   - Handles order acceptance/rejection
   - Transfers money to chef when completed
   - Refunds buyer if rejected

5. **`mark_complete.php`**
   - Verifies OTP
   - Finalizes order and payment

6. **`stripe_return.php`** and **`stripe_refresh.php`**
   - Handle callbacks from Stripe after onboarding

---

## 💰 Money Management

### When is Buyer charged?
- **When order is created** (`orderPlaceApi`)
- Payment is processed immediately or put on hold

### When is money transferred to Chef/Grocer?
- **When Chef completes the order** (`changeOrderStatusApi` with status `'completed'`)
- Backend creates a `Stripe Transfer` to chef's Stripe Connect account

### Platform Commission
- If Munchups takes a commission (e.g., 10%), it's deducted during transfer
- Uses `application_fee_amount` in `Stripe\Transfer::create()`

### Refunds
- If Chef rejects/declines order, buyer is refunded
- Uses `Stripe\Refund::create()` in backend

---

## 🔒 Security

### Frontend
- ✅ Publishable Key can be exposed (it's public)
- ✅ PaymentMethod is created client-side (secure)
- ✅ Token is sent to backend (not full card details)

### Backend
- ⚠️ Secret Key **must never be exposed**
- ⚠️ Secret Key **only on server**
- ✅ All sensitive operations (Charge, Transfer, Refund) on backend

---

## 📝 Important Notes

1. **Stripe Connect is required** to allow chefs/grocers to receive payments
2. **Buyer must have a saved card** before creating an order
3. **Chef/grocer must complete Stripe onboarding** before receiving payments
4. **Payment is processed immediately** when order is created
5. **Transfer to chef happens only when order is completed**
6. **Refunds are automatic** if chef rejects order

---

## 🐛 Common Issues

### Buyer cannot pay
- Verify they have a saved card (`customer_id` in database)
- Verify `customerTokenTestApi()` works correctly

### Chef doesn't receive payments
- Verify they completed Stripe Connect onboarding
- Verify `stripe_account_id` is saved in database
- Verify backend transfers money when order is completed

### Order stays in pending
- Verify backend processes payment correctly
- Verify `order_dish_test.php` works

---

## 🔄 Alternative Flows

### Rejected Order
```
Buyer pays → Order created → Chef rejects → Automatic refund → Order cancelled
```

### Accepted then Rejected Order
```
Buyer pays → Order created → Chef accepts → Chef rejects → Automatic refund → Order cancelled
```

### Completed Order but Wrong OTP
```
Buyer pays → Order created → Chef completes → Buyer enters wrong OTP → OTP not verified → Order stays 'completed'
```

---

## 📚 Additional Resources

- **Stripe Connect Docs:** https://stripe.com/docs/connect
- **Stripe Payment Intents:** https://stripe.com/docs/payments/payment-intents
- **Stripe Transfers:** https://stripe.com/docs/connect/charges-transfers
- **Stripe Refunds:** https://stripe.com/docs/refunds

---

**Last Updated:** December 2025
**Version:** 1.0
