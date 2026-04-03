import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/transaction_splits_dao.dart';
import 'package:finwise/features/split_transaction/domain/entities/transaction_split_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class SplitTransactionLocalDatasource {
  SplitTransactionLocalDatasource(this._dao);

  final TransactionSplitsDao _dao;

  Future<List<TransactionSplitEntity>> getSplits(
      String transactionId) async {
    final rows = await _dao.getSplitsForTransaction(transactionId);
    return rows.map(_toEntity).toList();
  }

  Future<void> saveSplits(
    String transactionId,
    List<TransactionSplitEntity> splits,
  ) async {
    // Delete existing splits first, then insert new ones
    await _dao.deleteSplitsForTransaction(transactionId);
    for (final split in splits) {
      await _dao.insertSplit(
        TransactionSplitsCompanion.insert(
          id: split.id,
          transactionId: split.transactionId,
          categoryId: split.categoryId,
          amount: split.amount,
          note: Value(split.note),
        ),
      );
    }
  }

  Future<void> deleteSplits(String transactionId) async {
    await _dao.deleteSplitsForTransaction(transactionId);
  }

  TransactionSplitEntity _toEntity(SplitWithCategory row) {
    return TransactionSplitEntity(
      id: row.split.id,
      transactionId: row.split.transactionId,
      categoryId: row.split.categoryId,
      amount: row.split.amount,
      note: row.split.note,
      categoryName: row.category.name,
      categoryIcon: row.category.icon,
      categoryColor: row.category.color,
    );
  }
}
