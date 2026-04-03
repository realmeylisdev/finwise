import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transaction_splits_table.dart';
import '../tables/categories_table.dart';

part 'transaction_splits_dao.g.dart';

class SplitWithCategory {
  const SplitWithCategory({required this.split, required this.category});
  final TransactionSplitRow split;
  final CategoryRow category;
}

@DriftAccessor(tables: [TransactionSplits, Categories])
class TransactionSplitsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionSplitsDaoMixin {
  TransactionSplitsDao(super.db);

  Future<List<SplitWithCategory>> getSplitsForTransaction(
      String transactionId) async {
    final query = select(transactionSplits).join([
      innerJoin(
          categories, categories.id.equalsExp(transactionSplits.categoryId)),
    ])
      ..where(transactionSplits.transactionId.equals(transactionId));

    return (await query.get())
        .map((row) => SplitWithCategory(
              split: row.readTable(transactionSplits),
              category: row.readTable(categories),
            ))
        .toList();
  }

  Future<int> insertSplit(TransactionSplitsCompanion entry) =>
      into(transactionSplits).insert(entry);

  Future<void> deleteSplitsForTransaction(String transactionId) =>
      (delete(transactionSplits)
            ..where((t) => t.transactionId.equals(transactionId)))
          .go();
}
