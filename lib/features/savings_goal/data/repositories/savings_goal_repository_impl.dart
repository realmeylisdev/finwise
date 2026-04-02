import 'package:finwise/core/errors/exceptions.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/savings_goal/data/datasources/savings_goal_local_datasource.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/savings_goal/domain/repositories/savings_goal_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SavingsGoalRepository)
class SavingsGoalRepositoryImpl implements SavingsGoalRepository {
  SavingsGoalRepositoryImpl(this._datasource);

  final SavingsGoalLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<SavingsGoalEntity>>> getGoals() async {
    try {
      final goals = await _datasource.getGoals();
      return Right(goals);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingsGoalEntity>> getGoalById(String id) async {
    try {
      final goal = await _datasource.getGoalById(id);
      if (goal == null) {
        return const Left(NotFoundFailure(message: 'Goal not found'));
      }
      return Right(goal);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingsGoalEntity>> createGoal(
    SavingsGoalEntity goal,
  ) async {
    try {
      await _datasource.insertGoal(goal);
      return Right(goal);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingsGoalEntity>> updateGoal(
    SavingsGoalEntity goal,
  ) async {
    try {
      await _datasource.updateGoal(goal);
      return Right(goal);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String id) async {
    try {
      await _datasource.deleteGoal(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> contribute(String id, double amount) async {
    try {
      await _datasource.contribute(id, amount);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> withdraw(String id, double amount) async {
    try {
      await _datasource.withdraw(id, amount);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
