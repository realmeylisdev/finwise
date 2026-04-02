import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/savings_goal/domain/repositories/savings_goal_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateSavingsGoalUseCase
    extends UseCase<SavingsGoalEntity, SavingsGoalEntity> {
  CreateSavingsGoalUseCase(this._repository);
  final SavingsGoalRepository _repository;

  @override
  Future<Either<Failure, SavingsGoalEntity>> call(
    SavingsGoalEntity params,
  ) =>
      _repository.createGoal(params);
}
