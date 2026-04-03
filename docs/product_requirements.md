# FinWise - Product Requirements Document (PRD)

## 1. Overview

**Product**: FinWise - Personal Finance Management App
**Version**: 1.0.0
**Platform**: iOS, Android (Flutter)
**Architecture**: Clean Architecture + BLoC

---

## 2. User Stories & Acceptance Criteria

### 2.1 Transaction Management

**US-1.1**: As a user, I want to record income, expense, and transfer transactions so that I can track where my money goes.

- AC: User can create a transaction with amount, type (income/expense/transfer), category, account, date, and optional note
- AC: Transactions appear in a chronological list on the transactions page
- AC: User can edit or delete any existing transaction
- AC: Transfer transactions debit one account and credit another

**US-1.2**: As a user, I want to split a single transaction across multiple categories so that I can accurately track mixed purchases.

- AC: User can split a transaction into 2+ line items, each with its own category and amount
- AC: Split amounts must sum to the original transaction total
- AC: Split details are visible on the transaction detail page

**US-1.3**: As a user, I want to search my transactions so that I can quickly find specific entries.

- AC: Search filters by description, amount, category, and date range
- AC: Results update as the user types (restartable transformer, no duplicate API calls)

### 2.2 Account Management

**US-2.1**: As a user, I want to manage multiple financial accounts (checking, savings, credit card, cash) so that I can track balances across all my money.

- AC: User can create, edit, and delete accounts with name, type, currency, and initial balance
- AC: Account balances update automatically when transactions are added or modified
- AC: Accounts page shows all accounts with current balances

### 2.3 Category Management

**US-3.1**: As a user, I want customizable expense and income categories so that I can organize transactions my way.

- AC: App ships with default categories (seeded on first launch)
- AC: User can create custom categories with name, icon, and color
- AC: Categories are filterable by type (income/expense)

**US-3.2**: As a user, I want automatic category rules so that recurring merchants are categorized without manual effort.

- AC: User can create rules that match transaction descriptions to categories
- AC: Rules apply automatically when new transactions match the pattern
- AC: Rules page lists all active rules with edit/delete options

### 2.4 Budgeting

**US-4.1**: As a user, I want to set monthly budgets per category so that I can control my spending.

- AC: User can create budgets with a category, amount, and month/year
- AC: Budget detail page shows spent vs. remaining with a progress bar
- AC: Overspent budgets are visually highlighted
- AC: Budget list shows all budgets for the selected month

### 2.5 Savings Goals

**US-5.1**: As a user, I want to create savings goals with target amounts and deadlines so that I can track progress toward financial milestones.

- AC: User can create goals with name, target amount, target date, and optional icon
- AC: Goal detail page shows current amount, progress percentage, and projected completion
- AC: User can log contributions toward a goal

### 2.6 Net Worth Tracking

**US-6.1**: As a user, I want to track my assets and liabilities so that I can see my net worth over time.

- AC: User can add assets (property, vehicles, investments) with name and value
- AC: User can add liabilities (loans, credit card debt) with name and balance
- AC: Net worth page displays total assets - total liabilities
- AC: Historical snapshots show net worth trend over time

### 2.7 Investment Portfolio

**US-7.1**: As a user, I want to track my investments so that I can monitor portfolio performance.

- AC: User can add investments with name, type, quantity, purchase price, and current value
- AC: Investment history tracks value changes over time
- AC: Portfolio page shows total value, gain/loss, and per-investment breakdown

### 2.8 Debt Payoff Planning

**US-8.1**: As a user, I want a debt payoff planner so that I can optimize my debt repayment strategy.

- AC: User can add debts with name, balance, interest rate, and minimum payment
- AC: Payoff plan page calculates avalanche (highest interest first) and snowball (lowest balance first) strategies
- AC: Plan shows projected payoff date and total interest for each strategy
- AC: User can log payments against debts

### 2.9 Subscription Tracking

**US-9.1**: As a user, I want to track recurring subscriptions so that I know my total monthly commitments.

- AC: User can add subscriptions with name, amount, billing cycle, and category
- AC: Subscriptions page shows total monthly/annual cost
- AC: Active and cancelled subscriptions are visually distinguished

### 2.10 Bill Reminders

**US-10.1**: As a user, I want bill reminders so that I never miss a payment.

- AC: User can create bill reminders with name, amount, due date, and recurrence
- AC: Bills page shows upcoming and overdue bills
- AC: Bills are sortable by due date

### 2.11 Cash Flow Analysis

**US-11.1**: As a user, I want to see my cash flow so that I understand my income vs. expenses over time.

- AC: Cash flow page shows income, expenses, and net flow for a selected period
- AC: Visualized with charts (fl_chart)

### 2.12 Analytics & Reports

**US-12.1**: As a user, I want detailed analytics so that I can understand spending patterns.

- AC: Analytics page shows spending by category, trends over time, and top expenses
- AC: Charts are interactive with tap-to-detail

**US-12.2**: As a user, I want to export reports so that I can share or archive my financial data.

- AC: User can export transactions to CSV
- AC: User can generate PDF reports with summary and charts
- AC: Export uses the system share sheet

### 2.13 AI-Powered Insights

**US-13.1**: As a user, I want AI-generated financial insights so that I can spot trends and anomalies I might miss.

- AC: AI insights page shows automatically detected patterns (unusual spending, recurring charges, saving opportunities)
- AC: Anomaly detection flags transactions that deviate significantly from normal patterns
- AC: Insights are generated from on-device algorithms (no cloud dependency)

### 2.14 Financial Wellness Score

**US-14.1**: As a user, I want a financial wellness score so that I have a simple metric for my overall financial health.

- AC: Wellness score is calculated from savings rate, debt-to-income ratio, budget adherence, and emergency fund status
- AC: Score is displayed as 0-100 with color-coded tiers
- AC: Score page shows breakdown by component with improvement suggestions

### 2.15 Achievements & Gamification

**US-15.1**: As a user, I want to earn achievements so that I stay motivated to maintain good financial habits.

- AC: Achievements are awarded for milestones (first transaction, budget streak, savings goal reached, etc.)
- AC: Achievements page shows earned and locked badges
- AC: Earning an achievement triggers a confetti animation

### 2.16 Security

**US-16.1**: As a user, I want to lock the app with PIN or biometrics so that my financial data is private.

- AC: User can set up a 4-6 digit PIN
- AC: User can enable biometric unlock (fingerprint/Face ID) if device supports it
- AC: Lock screen appears on app launch and resume from background
- AC: Privacy mode hides sensitive amounts with asterisks

### 2.17 Settings & Personalization

**US-17.1**: As a user, I want to customize the app appearance and behavior.

- AC: User can toggle between light and dark theme
- AC: User can select their default currency
- AC: User can enable/disable privacy mode
- AC: Settings page provides access to all configuration options

### 2.18 Multi-Profile & Sharing

**US-18.1**: As a user, I want multiple profiles so that I can manage finances for different household members.

- AC: User can create, switch between, and delete profiles
- AC: Each profile has its own transactions, budgets, and goals

**US-18.2**: As a user, I want shared budgets so that I can collaborate on household spending limits.

- AC: User can create budgets shared across profiles
- AC: Shared budget page shows contributions from each profile

### 2.19 Onboarding

**US-19.1**: As a new user, I want a guided onboarding flow so that I can set up the app quickly.

- AC: First launch shows an onboarding carousel explaining key features
- AC: Onboarding checklist tracks setup steps (add account, create category, record first transaction)
- AC: Checklist persists until all steps are completed

### 2.20 Dashboard

**US-20.1**: As a user, I want a dashboard that summarizes my financial status at a glance.

- AC: Dashboard shows total balance across accounts, recent transactions, budget progress, and savings goal progress
- AC: Dashboard loads data from multiple BLoCs coordinated at the app level
- AC: Quick action buttons provide shortcuts to add transaction, view budgets, etc.

### 2.21 Monetization

**US-21.1**: As a user, I want to understand which features are free vs. premium.

- AC: Free features include transactions, accounts, categories, basic budgets, and basic settings
- AC: Premium features (investments, AI insights, reports, net worth, debt planning) show a lock icon and redirect to the paywall
- AC: Paywall page explains premium benefits and subscription options
- AC: Feature gate service controls access consistently across the app

---

## 3. Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Cold start time | < 3 seconds on mid-range device |
| Frame rate | 60fps during scrolling and animations |
| Database size | Support 50,000+ transactions without degradation |
| Offline | 100% functional with no network connection |
| Accessibility | Semantic labels on all interactive elements, 48dp touch targets |
| Localization | Architecture supports i18n (intl package integrated) |
| Min platform | iOS 14+, Android API 21+ |
