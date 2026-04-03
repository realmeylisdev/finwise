import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/shared_budgets/data/datasources/shared_budget_local_datasource.dart';
import 'package:finwise/features/shared_budgets/domain/entities/shared_budget_entity.dart';
import 'package:finwise/features/shared_budgets/domain/repositories/shared_budget_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SharedBudgetRepository)
class SharedBudgetRepositoryImpl implements SharedBudgetRepository {
  SharedBudgetRepositoryImpl(this._datasource);

  final SharedBudgetLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<SharedBudgetEntity>>> getSharesForBudget(
    String budgetId,
  ) async {
    try {
      final shares = await _datasource.getSharesForBudget(budgetId);
      return Right(shares);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedBudgetEntity>> shareBudget(
    SharedBudgetEntity share,
  ) async {
    try {
      await _datasource.shareBudget(share);
      return Right(share);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unshareBudget(
    String budgetId,
    String profileId,
  ) async {
    try {
      await _datasource.unshareBudget(budgetId, profileId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
