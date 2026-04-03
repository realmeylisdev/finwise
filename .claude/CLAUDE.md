# finwise assistant notes

## Workflow And Standards

- `rules/workflow.md`: plan mode, subagent strategy, self-improvement loop, verification quality bar, autonomous bug fixing
- Use `/investigate` for deep, complex bug analysis. Use `/plan` for routine issue planning.

### Standards Reference

Generic Flutter and Dart standards live in `.claude/rules/`:

- `rules/architecture.md`: clean architecture layers, UseCase pattern, DI with get_it/injectable, barrel files
- `rules/state_management.md`: BLoC-only, event transformers, error handling in BLoC, sealed vs enum state
- `rules/code_style.md`: naming, widget composition, Effective Dart guidance
- `rules/testing.md`: test structure, assertions, BLoC tests, goldens
- `rules/routing.md`: `go_router` patterns
- `rules/ui_theming.md`: theme usage, Page/View split, spacing and typography
- `rules/error_handling.md`: exceptions, failures, and fpdart Either handling

## Project Rules

- Key entry points are `lib/main.dart` and `lib/core/navigation/app_router.dart`.
- Use current code as source of truth. If documentation disagrees with code, trust the current implementation.

## Architecture And State

- Follow `UI -> BLoC/Cubit -> UseCase -> Repository -> DataSource` for all work.
- Use fpdart `Either<Failure, T>` for error handling across layers.
- Use get_it + injectable for dependency injection (`lib/core/di/`).
- Use drift for local database (`lib/core/database/`).
- Keep changes incremental, test-backed, and small enough to review.
- Prefer constructor injection and small widget classes over hidden dependencies.

## UI And Product Constraints

- Use `AppTheme`, `AppColors`, `AppTypography`, and `AppDimensions` from `lib/core/theme/` before adding one-off styling or raw `Colors.*`.
- Prefer full-screen flows over introducing new dialogs or bottom sheets unless the task explicitly asks for one.

## Verification

- If dependencies change, run `flutter pub get`.
- If you touch generated-code inputs (Freezed, JSON, Injectable, Drift), run `dart run build_runner build --delete-conflicting-outputs` and commit the generated files.
- Add or update tests with the change.
