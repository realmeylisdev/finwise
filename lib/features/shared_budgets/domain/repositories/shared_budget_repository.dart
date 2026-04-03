import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/shared_budgets/domain/entities/shared_budget_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class SharedBudgetRepository {
  Future<Either<Failure, List<SharedBudgetEntity>>> getSharesForBudget(
    String budgetId,
  );
  Future<Either<Failure, SharedBudgetEntity>> shareBudget(
    SharedBudgetEntity share,
  );
  Future<Either<Failure, void>> unshareBudget(
    String budgetId,
    String profileId,
  );
}
