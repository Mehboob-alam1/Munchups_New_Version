-- Database Schema for Stripe Payment System
-- Munchups App

-- Users table (updated)
ALTER TABLE user_master 
ADD COLUMN IF NOT EXISTS stripe_customer_id VARCHAR(255) NULL,
ADD COLUMN IF NOT EXISTS stripe_account_id VARCHAR(255) NULL,
ADD COLUMN IF NOT EXISTS stripe_onboarded BOOLEAN DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS idx_stripe_customer ON user_master(stripe_customer_id);
CREATE INDEX IF NOT EXISTS idx_stripe_account ON user_master(stripe_account_id);

-- Chefs table (updated)
ALTER TABLE chef_master 
ADD COLUMN IF NOT EXISTS stripe_account_id VARCHAR(255) NULL,
ADD COLUMN IF NOT EXISTS stripe_onboarded BOOLEAN DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS idx_stripe_account_chef ON chef_master(stripe_account_id);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_unique_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    chef_grocer_id INT NOT NULL,
    dish_id INT,
    dish_name VARCHAR(255),
    quantity INT NOT NULL,
    dish_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    grand_total DECIMAL(10,2) NOT NULL,
    note TEXT,
    status ENUM('pending', 'accept', 'decline', 'reject', 'completed', 'delivered') DEFAULT 'pending',
    payment_status ENUM('pending', 'authorized', 'paid', 'refunded', 'failed', 'completed', 'cancelled') DEFAULT 'pending',
    payment_intent_id VARCHAR(255),
    refund_id VARCHAR(255),
    platform_fee DECIMAL(10,2),
    seller_amount DECIMAL(10,2),
    otp VARCHAR(10),
    accepted_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    cancelled_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user_master(user_id),
    INDEX idx_user (user_id),
    INDEX idx_seller (chef_grocer_id),
    INDEX idx_status (status),
    INDEX idx_payment_status (payment_status),
    INDEX idx_payment_intent (payment_intent_id),
    INDEX idx_order_number (order_unique_number)
);

-- Transfers table
CREATE TABLE IF NOT EXISTS transfers (
    transfer_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    chef_grocer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    platform_fee DECIMAL(10,2),
    seller_amount DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'pending',
    stripe_transfer_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    INDEX idx_order (order_id),
    INDEX idx_seller (chef_grocer_id)
);

-- Stripe transfers log
CREATE TABLE IF NOT EXISTS stripe_transfers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    transfer_id VARCHAR(255) NOT NULL,
    order_id INT,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    destination_account VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_transfer (transfer_id),
    INDEX idx_order (order_id)
);


