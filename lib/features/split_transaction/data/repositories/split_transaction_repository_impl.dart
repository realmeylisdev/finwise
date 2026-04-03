import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/split_transaction/data/datasources/split_transaction_local_datasource.dart';
import 'package:finwise/features/split_transaction/domain/entities/transaction_split_entity.dart';
import 'package:finwise/features/split_transaction/domain/repositories/split_transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SplitTransactionRepository)
class SplitTransactionRepositoryImpl implements SplitTransactionRepository {
  SplitTransactionRepositoryImpl(this._datasource);

  final SplitTransactionLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<TransactionSplitEntity>>> getSplits(
      String transactionId) async {
    try {
      final splits = await _datasource.getSplits(transactionId);
      return Right(splits);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSplits(
    String transactionId,
    List<TransactionSplitEntity> splits,
  ) async {
    try {
      await _datasource.saveSplits(transactionId, splits);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSplits(String transactionId) async {
    try {
      await _datasource.deleteSplits(transactionId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
