-- -------------------------------
-- Drop tables if they already exist (careful in prod!)
-- -------------------------------
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS budgets CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS currencies CASCADE;
DROP TABLE IF EXISTS families CASCADE;

-- -------------------------------
-- Table: families
-- -------------------------------
CREATE TABLE MAIN.families (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL
);

-- -------------------------------
-- Table: currencies
-- -------------------------------
CREATE TABLE MAIN.currencies (
    code VARCHAR(10) PRIMARY KEY,      -- e.g., 'USD'
    name VARCHAR(50) NOT NULL,         -- e.g., 'US Dollar'
    rate_to_base DECIMAL(15,6) NOT NULL, -- conversion rate to base currency (e.g., INR)
    last_updated TIMESTAMP NOT NULL
);

-- -------------------------------
-- Table: users
-- -------------------------------
CREATE TABLE MAIN.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    family_id UUID REFERENCES main.families(id) ON DELETE CASCADE,
    fcm_token VARCHAR(255)
);

-- -------------------------------
-- Table: transactions
-- -------------------------------
CREATE TABLE MAIN.transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    family_id UUID REFERENCES main.families(id) ON DELETE CASCADE,
    user_id UUID REFERENCES main.users(id) ON DELETE SET NULL,
    amount DECIMAL(15,2) NOT NULL,           -- original amount in original currency
    currency_code VARCHAR(10) REFERENCES main.currencies(code),
    converted_amount DECIMAL(15,2) NOT NULL, -- amount converted to base currency (e.g., INR)
    type VARCHAR(10) CHECK (type IN ('INCOME', 'EXPENSE')),
    category VARCHAR(100) NOT NULL,
    description TEXT,
    date TIMESTAMP NOT NULL
);

-- -------------------------------
-- Table: budgets
-- -------------------------------
CREATE TABLE MAIN.budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    family_id UUID REFERENCES main.families(id) ON DELETE CASCADE,
    month VARCHAR(10) NOT NULL,               -- e.g., '2025-06'
    total_budget DECIMAL(15,2) NOT NULL,      -- planned budget in base currency
    actual_spend DECIMAL(15,2) DEFAULT 0.00   -- actual spend to date in base currency
);

-- -------------------------------
-- Indexes for performance (recommended)
-- -------------------------------
CREATE INDEX idx_transactions_family_date ON MAIN.transactions(family_id, date);
CREATE INDEX idx_transactions_user ON MAIN.transactions(user_id);
CREATE INDEX idx_budgets_family_month ON MAIN.budgets(family_id, month);

-- -------------------------------
-- Seed example currencies (optional)
-- -------------------------------
INSERT INTO currencies (code, name, rate_to_base, last_updated)
VALUES 
  ('INR', 'Indian Rupee', 1.0, CURRENT_TIMESTAMP),
  ('USD', 'US Dollar', 83.00, CURRENT_TIMESTAMP),
  ('EUR', 'Euro', 90.50, CURRENT_TIMESTAMP);




  SET search_path TO MAIN, public;


GRANT USAGE ON SCHEMA MAIN TO smart_family_budget_tracker_admin;
GRANT CREATE ON SCHEMA MAIN TO smart_family_budget_tracker_admin;