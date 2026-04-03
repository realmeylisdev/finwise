# FinWise

A comprehensive personal finance management app built with Flutter. Track transactions, manage budgets, set savings goals, monitor investments, plan debt payoff, and get AI-powered financial insights -- all offline on your device.

## Features

**Core Finance** -- Transactions (income/expense/transfer), accounts, categories, budgets, savings goals, bill reminders

**Advanced** -- Net worth tracking, investment portfolio, debt payoff planning (avalanche/snowball), subscription tracking, cash flow analysis, transaction splitting

**Smart** -- AI-powered insights and anomaly detection, automated category rules, recurring transaction detection, financial wellness scoring

**Engagement** -- Achievement badges, onboarding checklist, notifications, confetti celebrations

**Security** -- PIN lock, biometric authentication, privacy mode, secure credential storage

**Data** -- CSV export, PDF reports, data backup, multi-profile support, shared budgets

**Monetization** -- Freemium model with feature gates and paywall

## Architecture

Clean Architecture with BLoC state management:

```
UI (Presentation) -> BLoC -> UseCase -> Repository -> DataSource (Drift/SQLite)
```

- 32 features, each with strict layer separation
- 21 database tables via Drift ORM
- 25 BLoCs provided at app root
- fpdart Either for error handling
- GetIt + Injectable for dependency injection
- GoRouter for declarative navigation

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart ^3.11.1) |
| State | BLoC ^9.0.0 + Hydrated BLoC |
| Database | Drift ^2.22.1 (SQLite) |
| DI | GetIt + Injectable |
| Navigation | GoRouter ^17.1.0 |
| Charts | fl_chart ^1.2.0 |
| Models | Freezed + json_serializable |
| UI | Material 3, flutter_screenutil |
| Linting | very_good_analysis ^10.2.0 |

## Getting Started

### Prerequisites

- Flutter SDK (stable channel, Dart ^3.11.1)
- Xcode (for iOS) or Android Studio (for Android)
- Git

### Setup

```bash
# Clone the repository
git clone https://github.com/realmeylisdev/finwise.git
cd finwise

# Install dependencies
flutter pub get

# Run code generation (Freezed, Drift, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Running Tests

```bash
flutter test
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart               # Root MultiBlocProvider + MaterialApp
├── core/
│   ├── database/          # Drift database, tables, DAOs, seed data
│   ├── di/                # GetIt + Injectable configuration
│   ├── navigation/        # GoRouter routes
│   ├── theme/             # Material 3 theme (colors, typography, dimensions)
│   ├── errors/            # Failure and Exception base classes
│   ├── usecases/          # Base UseCase abstract classes
│   └── constants/         # App-wide constants
├── shared/
│   └── widgets/           # Reusable UI components
└── features/
    └── {feature}/
        ├── data/          # DataSources, models, repository implementations
        ├── domain/        # Entities, repository interfaces, use cases
        └── presentation/  # BLoC, pages, widgets
```

## Documentation

See the `docs/` folder for:

- [Scope Document](docs/scope_document.md) -- project scope, constraints, and risks
- [Product Requirements](docs/product_requirements.md) -- user stories and acceptance criteria
- [Technical Specification](docs/technical_specification.md) -- architecture decisions and design
- [Build Checklist](docs/build_checklist.md) -- phase-by-phase implementation tracking

## License

This project is for educational and demonstration purposes.
