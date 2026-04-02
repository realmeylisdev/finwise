import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<BudgetWithSpendingEntity>>> getBudgetsForMonth(
    int year,
    int month,
  );
  Future<Either<Failure, BudgetEntity>> getBudgetById(String id);
  Future<Either<Failure, BudgetEntity>> createBudget(BudgetEntity budget);
  Future<Either<Failure, BudgetEntity>> updateBudget(BudgetEntity budget);
  Future<Either<Failure, void>> deleteBudget(String id);
}
