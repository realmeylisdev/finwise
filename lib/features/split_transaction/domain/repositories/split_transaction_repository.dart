import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/split_transaction/domain/entities/transaction_split_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class SplitTransactionRepository {
  Future<Either<Failure, List<TransactionSplitEntity>>> getSplits(
      String transactionId);
  Future<Either<Failure, void>> saveSplits(
      String transactionId, List<TransactionSplitEntity> splits);
  Future<Either<Failure, void>> deleteSplits(String transactionId);
}
