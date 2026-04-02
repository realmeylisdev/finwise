import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteBudgetUseCase extends UseCase<void, String> {
  DeleteBudgetUseCase(this._repository);
  final BudgetRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.deleteBudget(params);
}
