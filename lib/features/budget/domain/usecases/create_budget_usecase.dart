import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateBudgetUseCase extends UseCase<BudgetEntity, BudgetEntity> {
  CreateBudgetUseCase(this._repository);
  final BudgetRepository _repository;

  @override
  Future<Either<Failure, BudgetEntity>> call(BudgetEntity params) =>
      _repository.createBudget(params);
}
