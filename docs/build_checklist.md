# FinWise - Build Checklist

## Phase 1: Foundation

- [x] Initialize Flutter project with `finwise` name
- [x] Configure `pubspec.yaml` with all dependencies
- [x] Set up `very_good_analysis` linting
- [x] Configure GetIt + Injectable dependency injection (`lib/core/di/`)
- [x] Set up Drift database with `AppDatabase` class
- [x] Define base `UseCase<T, Params>` and `UseCaseStream<T, Params>` abstract classes
- [x] Define `Failure` and `Exception` base classes (`lib/core/errors/`)
- [x] Set up GoRouter with `StatefulShellRoute` for bottom navigation
- [x] Define route constants in `AppRoutes`
- [x] Create Material 3 theme (`AppTheme`, `AppColors`, `AppTypography`, `AppDimensions`)
- [x] Configure `flutter_screenutil` with 375x812 design size
- [x] Set up `HydratedBloc` storage in `main.dart`
- [x] Create `MultiBlocProvider` root in `app.dart`
- [x] Configure portrait-only orientation
- [x] Set up native splash screen (Indigo #6366F1)

## Phase 2: Core Financial Features

- [x] **Transactions**: Table, DAO, DataSource, Repository, UseCases, BLoC, Pages (list, detail, form)
- [x] **Accounts**: Table, DAO, DataSource, Repository, UseCases, BLoC, Pages (list, form)
- [x] **Categories**: Table, DAO, DataSource, Repository, UseCases, BLoC, Pages (list, form)
- [x] **Currencies**: Table, DAO, seed data for default currencies
- [x] **Budgets**: Table, DAO, DataSource, Repository, UseCases, BLoC, Pages (list, detail, form)
- [x] **Savings Goals**: Table, DAO, DataSource, Repository, UseCases, BLoC, Pages (list, detail, form)
- [x] **Bill Reminders**: Table, DAO, DataSource, Repository, UseCases, BLoC, Pages
- [x] **Dashboard**: BLoC aggregating data from multiple sources, summary widgets, quick actions
- [x] **Search**: BLoC with restartable transformer, search page
- [x] **Category seeding**: Default categories populated on first launch
- [x] **Shared widgets**: Reusable UI components (`lib/shared/widgets/`)

## Phase 3: Gamification & Engagement

- [x] **Achievements**: Table, DAO, definitions, BLoC, achievements page with badge grid
- [x] **Wellness Score**: Calculation algorithm (savings rate, debt ratio, budget adherence, emergency fund), BLoC, page with breakdown
- [x] **Onboarding Checklist**: BLoC tracking setup steps, checklist widget
- [x] **Notifications**: Table, DAO, BLoC, notifications page
- [x] **Recurring Detection**: Pattern detection algorithm, BLoC, recurring patterns page
- [x] **Onboarding Flow**: Multi-step onboarding carousel for first launch
- [x] **Confetti animation**: Triggered on achievement unlock (confetti package)
- [x] **Lottie animations**: Asset loading animations

## Phase 4: Advanced Features

- [x] **Net Worth**: Assets table, Liabilities table, Snapshots table, DAOs, BLoC, pages (overview, asset form, liability form)
- [x] **Investments**: Investments table, Investment History table, DAOs, BLoC, pages (portfolio, form)
- [x] **Debt Payoff**: Debts table, Debt Payments table, DAOs, BLoC with avalanche/snowball algorithms, pages (list, form, payoff plan)
- [x] **Subscriptions**: Table, DAO, BLoC, pages (list, form) with monthly/annual cost summary
- [x] **Cash Flow**: BLoC computing income/expense/net flow, page with fl_chart visualization
- [x] **Category Rules**: Table, DAO, BLoC, rules page with auto-apply logic
- [x] **Transaction Splits**: Table, DAO, split UI in transaction form
- [x] **Analytics**: BLoC with spending-by-category, trends, top expenses; page with interactive charts
- [x] **Reports**: CSV export, PDF generation (pdf + printing packages), share via share_plus
- [x] **AI Insights**: Anomaly detection algorithm, pattern recognition, BLoC, insights page
- [x] **Multi-Profile**: Profiles table, BLoC, profile switching, profile form
- [x] **Shared Budgets**: Table, BLoC, shared budgets page

## Phase 5: Monetization & Polish

- [x] **Feature Gate Service**: `FeatureGateService` controlling free vs. premium access
- [x] **Paywall**: Paywall page, premium features page, manage subscription page
- [x] **FeatureGateWrapper**: Widget wrapping premium features with lock icon and paywall redirect
- [x] **Security - PIN**: PIN setup page, lock screen page, `SecurityBloc`
- [x] **Security - Biometrics**: `local_auth` integration with graceful fallback
- [x] **Privacy Mode**: Toggle in settings, amounts hidden with asterisks
- [x] **Backup**: Backup BLoC, backup page
- [x] **Settings**: Theme toggle (light/dark), currency selector, privacy mode toggle, feature gate display
- [x] **Fix FeatureGateWrapper overflow** in settings ListTiles

## Phase 6: Quality & Submission

- [x] **Unit tests**: Core services (FeatureGate, CurrencyService)
- [x] **Domain tests**: UseCase tests (wellness score, debt payoff, dashboard, AI insights)
- [ ] **BLoC tests**: Event/state coverage for all 25 BLoCs
- [ ] **Widget tests**: Key screens (dashboard, transaction form, budget detail)
- [ ] **Integration tests**: End-to-end core flows
- [x] **Linting**: All code passes `very_good_analysis` rules
- [x] **Documentation**: Scope document, PRD, technical spec, build checklist
- [ ] **README**: Comprehensive setup and run instructions
- [ ] **Make repository public**: Push to public GitHub repo
- [ ] **DevPost submission**: Project description, zipped docs folder, repo link
