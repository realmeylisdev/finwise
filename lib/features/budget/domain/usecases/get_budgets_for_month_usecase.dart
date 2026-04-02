import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

typedef BudgetMonthParams = ({int year, int month});

@injectable
class GetBudgetsForMonthUseCase
    extends UseCase<List<BudgetWithSpendingEntity>, BudgetMonthParams> {
  GetBudgetsForMonthUseCase(this._repository);
  final BudgetRepository _repository;

  @override
  Future<Either<Failure, List<BudgetWithSpendingEntity>>> call(
    BudgetMonthParams params,
  ) =>
      _repository.getBudgetsForMonth(params.year, params.month);
}
