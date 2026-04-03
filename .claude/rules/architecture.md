# Architecture

Layered clean architecture is used to build a highly scalable, maintainable, and testable app. The architecture consists of four layers: the data layer, the domain layer, the business logic layer, and the presentation layer. Each layer has a single responsibility and there are clear boundaries between each one.

Benefits:
- Each layer can be developed independently without impacting other layers
- Testing is simplified since only one layer needs to be mocked
- A structured approach clarifies component ownership, streamlining development and code reviews

## The Flow

```
UI (Presentation) → BLoC (Business Logic) → UseCase → Repository → DataSource (Data)
```

## Layers

### Data Layer (DataSource)

This is the lowest layer of the stack. It is the layer that is closest to the retrieval and persistence of data.

**Responsibility**: Retrieving and persisting raw data from external sources and making it available to the repository layer. Examples include:
- Drift database (SQLite)
- Shared Preferences / local storage
- File system (backups, exports)

**Key Rule**: The data layer should be free of any specific domain or business logic. DataSources handle raw CRUD operations only.

**Location**: `lib/features/{feature}/data/datasources/`

### Domain Layer (Repository Interface + UseCase + Entity)

The domain layer defines the contract (abstract repository) and business rules (use cases) that the app operates on. Entities live here as pure domain objects.

**Repository (abstract)**: Defines the interface that the data layer must implement. Located in `lib/features/{feature}/domain/repositories/`.

**UseCase**: Encapsulates a single piece of business logic. Every use case extends `UseCase<T, Params>` or `UseCaseStream<T, Params>` from `lib/core/usecases/usecase.dart` and returns `Future<Either<Failure, T>>` or `Stream<Either<Failure, T>>` using fpdart.

**Entity**: Pure domain objects with no framework dependencies. Located in `lib/features/{feature}/domain/entities/`.

**Key Rules**:
- Should not import any Flutter dependencies
- Use cases should be single-purpose (one public `call` method)
- Repository interfaces define what data operations are available; implementations in the data layer decide how

**Location**: `lib/features/{feature}/domain/`

### Repository Implementation (Data Layer)

This compositional layer implements the domain repository interface. It composes one or more data sources and applies domain-specific rules to the data.

**Responsibility**: Fetching data from one or more data sources, applying domain-specific logic to that raw data, converting between data models and domain entities, and providing results to use cases.

**Key Rules**:
- Should not import any Flutter dependencies
- Should not be dependent on other repositories
- **Fallback and composition logic belongs here** -- when data can come from multiple sources (e.g., try database first, fall back to defaults), the repository decides the strategy. BLoCs and UI should never implement source-selection or fallback logic
- Error handling: catch exceptions from data sources and return `Left(Failure)` using fpdart's Either type

**Location**: `lib/features/{feature}/data/repositories/`

### Business Logic Layer (BLoC)

This layer consumes one or more use cases and contains logic for how to surface the business rules via a specific feature.

**Responsibility**: Receives events from the UI, calls use cases, and emits new states to the presentation layer.

**Key Rules**:
- Should have no dependency on the Flutter SDK (except `flutter_bloc`)
- Should not have direct dependencies on other BLoCs
- Should not call repositories directly -- always go through use cases
- Should fold `Either<Failure, T>` results from use cases and emit appropriate states
- This layer can be considered the "feature" layer -- design and product determine the rules for how a particular feature will function

**Location**: `lib/features/{feature}/presentation/bloc/`

### Presentation Layer (UI)

The presentation layer is the top layer in the stack. It is the UI layer of the app where we use Flutter to "paint pixels" on the screen.

**Responsibility**: Building widgets, managing the widget lifecycle, and dispatching events to BLoCs. Listens to BLoC states and rebuilds accordingly.

**Key Rule**: No business logic should exist in this layer. The presentation layer should only interact with BLoCs.

**Location**: `lib/features/{feature}/presentation/pages/` and `lib/features/{feature}/presentation/widgets/`

## Project Organization

```
lib/
├── app.dart
├── main.dart
├── core/
│   ├── constants/         # App-wide constants
│   ├── database/          # Drift database setup
│   ├── di/                # get_it + injectable DI configuration
│   ├── errors/            # Failure and Exception base classes
│   ├── navigation/        # GoRouter configuration
│   ├── theme/             # App theme definitions
│   ├── usecases/          # Base UseCase abstract classes
│   └── utils/             # Shared utilities
├── shared/
│   ├── extensions/        # Dart extension methods
│   ├── validators/        # Reusable validation logic
│   └── widgets/           # Shared widgets used across features
└── features/
    └── {feature}/
        ├── data/
        │   ├── datasources/    # Drift DAOs, local data access
        │   ├── models/         # Data models (DB tables, DTOs)
        │   └── repositories/   # Repository implementations
        ├── domain/
        │   ├── entities/       # Pure domain objects
        │   ├── repositories/   # Abstract repository contracts
        │   └── usecases/       # Business logic use cases
        └── presentation/
            ├── bloc/           # BLoC classes (events, states, bloc)
            ├── pages/          # Full-screen page widgets
            └── widgets/        # Feature-specific widgets
```

## Dependency Graph (What Can Import What)

```
Presentation → BLoC → UseCase → Repository (abstract) ← Repository (impl) → DataSource
                                      ↑
                                   Entity
```

- **Entities** are referenced by all layers except data sources
- **Data models** live in data/ and are converted to entities in the repository implementation
- **Use cases** depend only on abstract repository interfaces (domain layer)
- **BLoCs** depend only on use cases
- **Pages/Widgets** depend only on BLoCs and entities (for displaying data)

### Anti-patterns (Do NOT Do This)

```dart
// BAD: BLoC calling a DataSource directly
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionLocalDataSource dataSource; // WRONG -- skip layers
}

// BAD: BLoC calling a Repository directly (skipping UseCase)
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository; // WRONG -- use UseCase instead
}

// BAD: UI implementing business logic
BlocBuilder<BudgetBloc, BudgetState>(
  builder: (context, state) {
    final remaining = state.budget.amount - state.totalSpent; // WRONG
    final isOverBudget = remaining < 0; // WRONG -- belongs in UseCase/BLoC
  },
)

// BAD: Repository depending on another repository
class TransactionRepositoryImpl implements TransactionRepository {
  final CategoryRepository categoryRepo; // WRONG -- repos are independent
}
```

### Correct Pattern

```dart
// GOOD: BLoC depends on UseCase
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;

  TransactionBloc({
    required this.getTransactions,
    required this.addTransaction,
  }) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await getTransactions(NoParams());
    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (transactions) => emit(TransactionLoaded(transactions)),
    );
  }
}

// GOOD: UseCase depends on abstract Repository
class GetTransactions extends UseCase<List<Transaction>, NoParams> {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(NoParams params) {
    return repository.getTransactions();
  }
}

// GOOD: Repository impl composes DataSources and returns Either
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final models = await localDataSource.getAllTransactions();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
```

## Dependency Injection

Finwise uses **get_it** with **injectable** for dependency injection. All injectable classes are registered via annotations and configured in `lib/core/di/`.

### Registration

```dart
// DataSource
@lazySingleton
class TransactionLocalDataSource {
  final AppDatabase db;
  TransactionLocalDataSource(this.db);
}

// Repository -- register the implementation as the abstract type
@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  TransactionRepositoryImpl(this.localDataSource);
}

// UseCase
@lazySingleton
class GetTransactions extends UseCase<List<Transaction>, NoParams> {
  final TransactionRepository repository;
  GetTransactions(this.repository);
}

// BLoC
@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(GetTransactions getTransactions, AddTransaction addTransaction)
      : super(TransactionInitial());
}
```

### Usage in Presentation

```dart
// Access via get_it in the widget tree
BlocProvider(
  create: (_) => getIt<TransactionBloc>()..add(LoadTransactions()),
  child: const TransactionPage(),
)
```

### Key DI Rules
- Use `@injectable` for BLoCs (new instance each time)
- Use `@lazySingleton` for repositories, use cases, and data sources
- Use `@LazySingleton(as: AbstractType)` to bind implementations to their abstract interfaces
- Constructor injection is the primary mechanism -- injectable resolves the dependency graph automatically
- After adding or changing registrations, run `dart run build_runner build` to regenerate `injection.config.dart`

## Barrel Files

Every directory within a feature should have a barrel file (e.g., `transaction.dart`) that exports all public files from that directory. This keeps imports clean and manageable.

```dart
// lib/features/transaction/domain/usecases/usecases.dart
export 'add_transaction.dart';
export 'delete_transaction.dart';
export 'get_transactions.dart';
export 'update_transaction.dart';
```

### Rules
- One barrel file per directory that has multiple public files
- Never import individual files when a barrel file exists
- Barrel files should only contain `export` statements -- no logic
- Barrel files make refactoring easier: moving or renaming internal files only requires updating the barrel file, not every consumer
