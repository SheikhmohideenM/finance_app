# README

                Personal Finance Management API (Rails)

                        📌 Overview

This is a Personal Finance Management application built with Ruby on Rails.
It allows users to:

    1. Manage accounts and balances
    2. Track income & expenses via transactions
    3. Create and enforce budgets
    4. Create saving pots with progress tracking
    5. Schedule recurring bills
    6. Secure authentication
    7. Background jobs using Sidekiq

The application exposes REST APIs under /api/v1 and supports a React frontend via CORS.

                        🧱 Tech Stack

    1. Backend: Ruby on Rails
    2. Database: PostgreSQL / MySQL
    3. Authentication: has_secure_password
    4. Background Jobs: Sidekiq + Sidekiq Cron
    5. Testing: RSpec
    6. Frontend: React (Vite)
    7. API Format: JSON


                        🔐 Authentication Flow

    1. User signs up via /signup
    2. User logs in via /login
    3. Session-based authentication
    4. APIs are scoped to current_user

                        🗂️ Domain Models & Use Cases

                            👤 User
    Associations

        1. has_many accounts
        2. has_many transactions
        3. has_many budgets
        4. has_many pots
        5. has_many recurring_bills

    Validations

        1. Name required
        2. Unique, valid email
        3. Password length: 5–12 chars

    Use Cases

        1. Register new user
        2. Login/logout
        3. Own all finance data
        4. Cascade delete all related data

                            🏦 Account
    Use Cases

        1. Hold money (Cash, Bank, Wallet)
        2. Linked to transactions & recurring bills
        3. Balance updated on transaction creation

                            💸 Transaction
    Rules

        1. Expense = negative amount
        2. Income = positive amount
        3. Editable only within 24 hours
        4. Budget enforced for expenses

    Validations

        1. Amount present
        2. Date present
        3. Expense must not exceed remaining budget

    Use Cases

        1. Create income transaction
        2. Create expense transaction
        3. Assign budget to expense
        4. Undo transaction
        5. Prevent overspending
        6. Enforce 24-hour edit window

                            📊 Budget
    Rules

        1. One budget per category per user
        2. Tracks max, spent, and remaining
        3. Expense transactions reduce budget

    Validations

        1. Title, category, color required
        2. Unique category per user
        3. Unique color per user
        4. Max > 0

    Use Cases

        1. Create monthly budget
        2. Assign budget to transactions
        3. Prevent exceeding limit
        4. View remaining balance

                            💰 Pot (Savings Goals)
    Rules

        1. Has target and saved amount
        2. Percentage auto-calculated

    Use Cases

        1. Create savings goal
        2. Add money
        3. Withdraw money
        4. Track progress

                            🔁 Recurring Bill
    Rules

        1. Frequencies: weekly, monthly, yearly
        2. Future dates only
        3. Budget enforced

    Use Cases

        1. Create auto bills
        2. Validate next run date
        3. Validate budget availability
        4. Generate next run date
        5. Background job execution (Sidekiq)

                                🛣️ API Routes
    1. /api/v1/budgets
    2. /api/v1/accounts
    3. /api/v1/transactions
    4. /api/v1/pots
    5. /api/v1/recurring_bills
    6. /api/v1/categories

        Custom routes:

    1. POST /api/v1/pots/:id/add_money
    2. POST /api/v1/pots/:id/withdraw
    3. POST /api/v1/transactions/:id/undo

                    🔄 Background Jobs (Sidekiq)

    1. Recurring bills processed via cron
    2. Configured in config/sidekiq.yml
    3. Dashboard available at /sidekiq

                    🌐 CORS Configuration

    Allows React frontend: http://localhost:5173