import 'package:finwise/core/errors/exceptions.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._datasource);

  final TransactionLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    try {
      final txns = await _datasource.getTransactions(
        limit: limit,
        offset: offset,
      );
      return Right(txns);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final txns = await _datasource.getTransactionsByDateRange(start, end);
      return Right(txns);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByAccount(
    String accountId,
  ) async {
    try {
      final txns = await _datasource.getTransactionsByAccount(accountId);
      return Right(txns);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByCategory(
    String categoryId, {
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final txns = await _datasource.getTransactionsByCategory(
        categoryId,
        start: start,
        end: end,
      );
      return Right(txns);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> createTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      await _datasource.insertTransaction(transaction);
      return Right(transaction);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      await _datasource.updateTransaction(transaction);
      return Right(transaction);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await _datasource.deleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalByType(
    String type,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final total = await _datasource.getTotalByType(type, start, end);
      return Right(total);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getSpendingByCategory(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final map = await _datasource.getSpendingByCategory(start, end);
      return Right(map);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions({int? limit}) {
    return _datasource.watchTransactions(limit: limit);
  }
}
