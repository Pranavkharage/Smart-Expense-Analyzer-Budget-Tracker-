-- ============================================
-- Smart Expense Analyzer & Budget Tracker
-- Complete Database Setup
-- ============================================

-- Clean start (safe for re-run)
DROP DATABASE IF EXISTS expense_tracker;

-- Create database
CREATE DATABASE expense_tracker;
USE expense_tracker;

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- ============================================
-- EXPENSES TABLE
-- ============================================
CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DOUBLE NOT NULL,
    category VARCHAR(30) NOT NULL,
    description VARCHAR(100),
    expense_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ============================================
-- BUDGET TABLE
-- ============================================
CREATE TABLE budget (
    user_id INT PRIMARY KEY,
    monthly_limit DOUBLE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ============================================
-- OPTIONAL: SAMPLE TEST DATA (REMOVE IF NOT NEEDED)
-- ============================================
-- INSERT INTO users (name, email, password)
-- VALUES ('Test User', 'test@gmail.com', '1234');

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
SHOW TABLES;
DESCRIBE users;
DESCRIBE expenses;
DESCRIBE budget;
