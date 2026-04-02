import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    int? limit,
    int? offset,
  });
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByAccount(
    String accountId,
  );
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByCategory(
    String categoryId, {
    DateTime? start,
    DateTime? end,
  });
  Future<Either<Failure, TransactionEntity>> createTransaction(
    TransactionEntity transaction,
  );
  Future<Either<Failure, TransactionEntity>> updateTransaction(
    TransactionEntity transaction,
  );
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, double>> getTotalByType(
    String type,
    DateTime start,
    DateTime end,
  );
  Future<Either<Failure, Map<String, double>>> getSpendingByCategory(
    DateTime start,
    DateTime end,
  );
  Stream<List<TransactionEntity>> watchTransactions({int? limit});
}
