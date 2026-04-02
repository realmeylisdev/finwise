import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/savings_goal/domain/repositories/savings_goal_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

typedef ContributeParams = ({String id, double amount});

@injectable
class ContributeSavingsGoalUseCase extends UseCase<void, ContributeParams> {
  ContributeSavingsGoalUseCase(this._repository);
  final SavingsGoalRepository _repository;

  @override
  Future<Either<Failure, void>> call(ContributeParams params) =>
      _repository.contribute(params.id, params.amount);
}
