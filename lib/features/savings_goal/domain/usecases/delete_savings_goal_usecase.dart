import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/savings_goal/domain/repositories/savings_goal_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteSavingsGoalUseCase extends UseCase<void, String> {
  DeleteSavingsGoalUseCase(this._repository);
  final SavingsGoalRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.deleteGoal(params);
}
