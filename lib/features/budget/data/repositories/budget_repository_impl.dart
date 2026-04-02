import 'package:finwise/core/errors/exceptions.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._datasource);

  final BudgetLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<BudgetWithSpendingEntity>>> getBudgetsForMonth(
    int year,
    int month,
  ) async {
    try {
      final budgets = await _datasource.getBudgetsForMonth(year, month);
      return Right(budgets);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetEntity>> getBudgetById(String id) async {
    try {
      final budget = await _datasource.getBudgetById(id);
      if (budget == null) {
        return const Left(NotFoundFailure(message: 'Budget not found'));
      }
      return Right(budget);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetEntity>> createBudget(
    BudgetEntity budget,
  ) async {
    try {
      await _datasource.insertBudget(budget);
      return Right(budget);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetEntity>> updateBudget(
    BudgetEntity budget,
  ) async {
    try {
      await _datasource.updateBudget(budget);
      return Right(budget);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await _datasource.deleteBudget(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
