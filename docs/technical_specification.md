# FinWise - Technical Specification

## 1. Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Framework | Flutter | Stable channel |
| Language | Dart | ^3.11.1 |
| State Management | BLoC / Cubit | bloc ^9.0.0, flutter_bloc ^9.1.1 |
| State Persistence | Hydrated BLoC | ^11.0.0 |
| Database | Drift (SQLite) | ^2.22.1 |
| DI | GetIt + Injectable | get_it ^9.0.5, injectable ^2.5.0 |
| Navigation | GoRouter | ^17.1.0 |
| Error Handling | fpdart (Either) | ^1.1.0 |
| Models | Freezed + json_serializable | ^3.2.5, ^6.9.5 |
| Form Validation | Formz | ^0.8.0 |
| Charts | fl_chart | ^1.2.0 |
| Responsive UI | flutter_screenutil | ^5.9.3 |
| Linting | very_good_analysis | ^10.2.0 |
| Testing | bloc_test + mocktail | ^10.0.0, ^1.0.4 |

---

## 2. Architecture

### 2.1 Clean Architecture (4 Layers)

```
Presentation (UI)
    |
    v
Business Logic (BLoC)
    |
    v
Domain (UseCase + Repository Interface + Entity)
    |
    v
Data (Repository Impl + DataSource)
```

**Data flow**: `UI dispatches Event -> BLoC calls UseCase -> UseCase calls Repository -> Repository calls DataSource -> DataSource queries Drift DB`

**Return flow**: `DB result -> DataSource -> Repository (model -> entity conversion, Either wrapping) -> UseCase -> BLoC (fold Either, emit State) -> UI rebuilds`

### 2.2 Layer Rules

| Layer | May Import | Must Not Import |
|-------|-----------|----------------|
| Presentation | BLoC, Entities, Flutter | Repositories, DataSources, Drift |
| BLoC | UseCases, Entities, flutter_bloc | Repositories, DataSources, Flutter SDK (except flutter_bloc) |
| Domain | fpdart, Equatable | Flutter, Drift, any framework |
| Data | Drift, Domain interfaces, fpdart | BLoC, Presentation, Flutter |

### 2.3 Feature Structure

Every feature follows this directory layout:

```
lib/features/{feature}/
├── data/
│   ├── datasources/     # Drift DAO wrappers
│   ├── models/          # DB table definitions, model extensions
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Pure Dart domain objects
│   ├── repositories/    # Abstract repository contracts
│   └── usecases/        # Single-purpose business logic
└── presentation/
    ├── bloc/            # BLoC + Events + State
    ├── pages/           # Route-level Page widgets
    └── widgets/         # Feature-specific UI components
```

---

## 3. Database Design

### 3.1 Drift ORM

The app uses Drift (SQLite) with 21 tables, organized by domain:

**Financial Core**:
- `transactions` - income/expense/transfer records (FK to accounts, categories)
- `accounts` - bank/payment accounts with type and currency
- `categories` - expense/income categories with icon and color
- `currencies` - multi-currency support with symbols

**Money Management**:
- `budgets` - monthly category budgets
- `savings_goals` - target-based savings tracking
- `bill_reminders` - upcoming payment reminders
- `subscriptions` - recurring subscription tracking
- `debts` - debt records with interest rates
- `debt_payments` - payment history per debt
- `investments` - portfolio holdings
- `investment_history` - historical value tracking

**Relationships & Rules**:
- `category_rules` - automated categorization patterns
- `transaction_splits` - multi-category transaction breakdowns
- `shared_budgets` - cross-profile budget sharing

**Net Worth**:
- `assets` - asset valuations
- `liabilities` - liability balances
- `net_worth_snapshots` - historical net worth records

**User Data**:
- `profiles` - multi-profile support
- `user_stats` - aggregated statistics
- `notifications` - notification history
- `achievements` - earned badges

### 3.2 Database Initialization

- Database is created on first launch via Drift's `LazyDatabase`
- Default categories and currencies are seeded from `lib/core/database/seed/`
- Schema migrations are handled via Drift's versioned migration system

### 3.3 Data Access

Each table has a dedicated DAO (Data Access Object) in `lib/core/database/daos/`. DAOs provide typed query methods and are injected into feature-level DataSources.

---

## 4. State Management

### 4.1 BLoC Pattern

Every feature has a dedicated BLoC with:
- **Events**: Sealed classes or Equatable classes representing user actions and system triggers
- **States**: Single class with enum status (for forms/persistent data) or sealed classes (for fetch-once flows)
- **Event transformers**: `sequential()`, `droppable()`, or `restartable()` from bloc_concurrency as appropriate

### 4.2 BLoC Rules

1. **No BLoC-to-BLoC dependencies** -- BLoCs never reference each other. UI coordinates via `BlocListener`
2. **No mutable instance variables** -- all mutable state lives in the state object
3. **No error strings in state** -- use `addError()` + status enum, never `String? errorMessage`
4. **UseCase-only** -- BLoCs call UseCases, never repositories directly
5. **Either folding** -- all UseCase results are `Either<Failure, T>`, folded in the BLoC handler

### 4.3 Global BLoC Provision

25 BLoCs are provided at the app root via `MultiBlocProvider` in `app.dart`. Data-loading BLoCs dispatch their initial load event immediately on creation (e.g., `TransactionsLoaded`, `AccountsLoaded`).

### 4.4 State Persistence

`HydratedBloc` is used for state that must survive app restarts (e.g., `SettingsBloc` for theme mode). Storage is initialized in `main.dart` before `runApp`.

---

## 5. Dependency Injection

### 5.1 GetIt + Injectable

- **Configuration**: `lib/core/di/injection.dart` + generated `injection.config.dart`
- **Registration**:
  - `@lazySingleton` for DataSources, Repositories, UseCases (shared instances)
  - `@LazySingleton(as: AbstractType)` for binding implementations to interfaces
  - `@injectable` for BLoCs (fresh instance per provider)
- **Resolution**: `getIt<T>()` used only in `BlocProvider` create callbacks

### 5.2 Dependency Graph

```
AppDatabase (singleton)
    |
    v
DAOs (lazy singletons)
    |
    v
DataSources (lazy singletons, depend on DAOs)
    |
    v
Repositories (lazy singletons, implement domain interfaces, depend on DataSources)
    |
    v
UseCases (lazy singletons, depend on abstract Repositories)
    |
    v
BLoCs (injectable/fresh, depend on UseCases)
```

---

## 6. Navigation

### 6.1 GoRouter

- Declarative routing with `GoRouter` configured in `lib/core/navigation/app_router.dart`
- Routes defined in `lib/core/navigation/app_routes.dart` as string constants
- `StatefulShellRoute` for bottom navigation with 5 tabs: Dashboard, Transactions, Budgets, Goals, Settings
- Each tab has its own `GlobalKey<NavigatorState>` for independent back stacks

### 6.2 Route Structure

```
/ (MainShell - bottom nav)
├── /dashboard
├── /transactions
│   └── /transactions/new
│   └── /transactions/:id
├── /budgets
│   └── /budgets/new
│   └── /budgets/:id
├── /goals
│   └── /goals/new
│   └── /goals/:id
└── /settings
    └── /settings/security
    └── /settings/backup
    └── ...

/onboarding (outside shell)
/lock-screen (outside shell)
/accounts, /analytics, /investments, ... (full-screen routes)
```

---

## 7. Theming

### 7.1 Material 3

- Light and dark themes defined in `lib/core/theme/app_theme.dart`
- Theme mode controlled by `SettingsBloc` and applied via `BlocBuilder` in `app.dart`
- Design tokens:
  - `AppColors` -- semantic color constants (primary: Indigo #6366F1, income: green, expense: red)
  - `AppTypography` -- Plus Jakarta Sans via Google Fonts
  - `AppDimensions` -- spacing tokens (paddingXS through paddingXL), radius tokens, icon sizes

### 7.2 Responsive Design

- Base design size: 375x812 (iPhone 11)
- `flutter_screenutil` for adaptive sizing (`.w`, `.h`, `.sp`, `.r` extensions)
- Portrait orientation only

---

## 8. Error Handling

### 8.1 Either Pattern

All repository methods return `Future<Either<Failure, T>>` using fpdart. Failure types:
- `DatabaseFailure` -- SQLite/Drift errors
- `ValidationFailure` -- input validation errors
- `NotFoundFailure` -- entity not found

### 8.2 BLoC Error Handling

```dart
result.fold(
  (failure) {
    addError(failure, StackTrace.current);
    emit(state.copyWith(status: Status.failure));
  },
  (data) => emit(state.copyWith(status: Status.success, data: data)),
);
```

---

## 9. Security

| Feature | Implementation |
|---------|---------------|
| App lock | PIN (4-6 digits) stored in `flutter_secure_storage` |
| Biometrics | `local_auth` package (fingerprint/Face ID) |
| Privacy mode | Amounts replaced with asterisks, controlled via `SettingsBloc` |
| Secure storage | `flutter_secure_storage` for credentials and sensitive config |

---

## 10. Code Generation

Build runner generates:
- **Freezed** models (immutable data classes with copyWith, equality)
- **json_serializable** (toJson/fromJson)
- **Injectable** (DI registration config)
- **Drift** (database code, DAOs, query builders)

Command: `dart run build_runner build --delete-conflicting-outputs`

---

## 11. Testing Strategy

| Test Type | Location | Tools | Coverage Target |
|-----------|----------|-------|-----------------|
| Unit (UseCases) | `test/features/*/domain/usecases/` | mocktail | All use cases |
| Unit (Services) | `test/core/services/` | mocktail | All services |
| BLoC | `test/features/*/presentation/bloc/` | bloc_test, mocktail | All BLoCs |
| Widget | `test/features/*/presentation/` | flutter_test | Key screens |
| Integration | `test/` | flutter_test | Core flows |

---

## 12. Build & Deployment

| Config | Value |
|--------|-------|
| Min iOS | 14.0 |
| Min Android API | 21 |
| Target Android API | 34 |
| Splash screen | Native splash via flutter_native_splash (Indigo #6366F1) |
| App icon | Material Design based |
| Orientation | Portrait only |
| Build modes | Debug (JIT), Release (AOT) |
