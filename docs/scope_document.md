# FinWise - Scope Document

## Project Vision

FinWise is a comprehensive personal finance management app built with Flutter that empowers users to take control of their financial life. It provides transaction tracking, budgeting, savings goals, investment monitoring, debt payoff planning, and AI-powered financial insights -- all in a single, offline-first mobile application.

## Problem Statement

Most personal finance apps either oversimplify (only tracking expenses) or overwhelm users with complexity. Users need a tool that grows with them -- starting simple with transaction tracking and budgets, then unlocking advanced features like net worth tracking, investment portfolios, and AI-driven anomaly detection as they become more engaged. Existing solutions also typically require cloud accounts and subscriptions for basic functionality, creating privacy concerns for sensitive financial data.

## Target Users

- **Primary**: Individuals aged 22-45 managing personal or household finances
- **Secondary**: Budget-conscious users wanting to reduce debt or grow savings
- **Tertiary**: Financially engaged users tracking investments and net worth

## Scope Definition

### In Scope

| Category | Features |
|----------|----------|
| **Core Finance** | Transaction CRUD (income/expense/transfer), account management, category management, budget tracking |
| **Savings & Goals** | Savings goal creation, progress tracking, contribution logging |
| **Advanced Finance** | Net worth tracking (assets + liabilities), investment portfolio, debt payoff planning (avalanche/snowball), subscription tracking, cash flow analysis, bill reminders |
| **Smart Features** | Automated category rules, recurring transaction detection, AI-powered insights and anomaly detection, financial wellness scoring |
| **Engagement** | Achievement/badge system, onboarding checklist, notifications |
| **Data & Export** | CSV export, PDF report generation, data backup, multi-profile support, shared budgets |
| **Security** | PIN lock, biometric authentication, privacy mode, secure credential storage |
| **Monetization** | Freemium feature gates, paywall, premium subscription management |
| **UX** | Onboarding flow, dark/light theme, responsive design, search, dashboard with summary widgets |

### Out of Scope

| Excluded | Rationale |
|----------|-----------|
| Cloud sync / backend server | Offline-first by design; avoids infrastructure costs and privacy concerns |
| Bank account linking (Plaid/Yodlee) | Requires financial API partnerships and compliance certifications |
| Multi-currency real-time conversion | Currencies are stored but live FX rates require an external API |
| Tax calculation or filing | Regulatory complexity varies by jurisdiction |
| Social features beyond shared budgets | Keeps the app focused on personal finance |
| Web or desktop targets | Mobile-first; Flutter supports these but they are deferred |

### Constraints

- **Platform**: iOS and Android (Flutter cross-platform)
- **Data storage**: Local SQLite only (Drift ORM) -- no cloud backend
- **SDK**: Dart 3.11.1+, Flutter stable channel
- **Design**: Material 3, iPhone 11 (375x812) as base design size
- **Orientation**: Portrait only
- **State**: BLoC pattern exclusively -- no setState, Provider, or Riverpod
- **Architecture**: Clean Architecture with strict layer separation (UI -> BLoC -> UseCase -> Repository -> DataSource)

### Assumptions

1. Users will manually enter transactions (no bank import)
2. A single device holds the user's data (no cross-device sync)
3. Premium features are gated but the payment provider integration is stubbed
4. AI insights use on-device heuristic algorithms, not cloud-based LLMs

### Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Database migration errors on schema changes | Medium | High | Drift migration tests, versioned schema |
| Feature bloat slowing development | Medium | Medium | Freemium gates allow phased delivery |
| Platform-specific biometric issues | Low | Medium | Graceful fallback to PIN |
| Large transaction datasets impacting performance | Low | High | Drift query optimization, pagination |

## Success Criteria

1. All 32 features are functional and navigable
2. Clean Architecture is enforced with no layer violations
3. Core flows (add transaction, create budget, set savings goal) complete end-to-end
4. App launches without errors on both iOS and Android
5. Existing tests pass
