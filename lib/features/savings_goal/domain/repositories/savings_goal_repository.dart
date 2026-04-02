import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class SavingsGoalRepository {
  Future<Either<Failure, List<SavingsGoalEntity>>> getGoals();
  Future<Either<Failure, SavingsGoalEntity>> getGoalById(String id);
  Future<Either<Failure, SavingsGoalEntity>> createGoal(
    SavingsGoalEntity goal,
  );
  Future<Either<Failure, SavingsGoalEntity>> updateGoal(
    SavingsGoalEntity goal,
  );
  Future<Either<Failure, void>> deleteGoal(String id);
  Future<Either<Failure, void>> contribute(String id, double amount);
  Future<Either<Failure, void>> withdraw(String id, double amount);
}
