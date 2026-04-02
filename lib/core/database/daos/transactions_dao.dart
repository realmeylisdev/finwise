import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/accounts_table.dart';
import '../tables/categories_table.dart';
import '../tables/transactions_table.dart';

part 'transactions_dao.g.dart';

class TransactionWithDetails {
  const TransactionWithDetails({
    required this.transaction,
    this.category,
    required this.account,
    this.toAccount,
  });

  final TransactionRow transaction;
  final CategoryRow? category;
  final AccountRow account;
  final AccountRow? toAccount;
}

@DriftAccessor(tables: [Transactions, Categories, Accounts])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Future<List<TransactionWithDetails>> getAllTransactions({
    int? limit,
    int? offset,
  }) async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      innerJoin(
        accounts,
        accounts.id.equalsExp(transactions.accountId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    if (limit != null) query.limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map(_mapToTransactionWithDetails).toList();
  }

  Stream<List<TransactionWithDetails>> watchAllTransactions({
    int? limit,
  }) {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      innerJoin(
        accounts,
        accounts.id.equalsExp(transactions.accountId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    if (limit != null) query.limit(limit);

    return query.watch().map(
          (rows) => rows.map(_mapToTransactionWithDetails).toList(),
        );
  }

  Future<List<TransactionWithDetails>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      innerJoin(
        accounts,
        accounts.id.equalsExp(transactions.accountId),
      ),
    ])
      ..where(
        transactions.date.isBiggerOrEqualValue(start) &
            transactions.date.isSmallerOrEqualValue(end),
      )
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    final rows = await query.get();
    return rows.map(_mapToTransactionWithDetails).toList();
  }

  Future<List<TransactionWithDetails>> getTransactionsByAccount(
    String accountId,
  ) async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      innerJoin(
        accounts,
        accounts.id.equalsExp(transactions.accountId),
      ),
    ])
      ..where(transactions.accountId.equals(accountId))
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    final rows = await query.get();
    return rows.map(_mapToTransactionWithDetails).toList();
  }

  Future<List<TransactionWithDetails>> getTransactionsByCategory(
    String categoryId, {
    DateTime? start,
    DateTime? end,
  }) async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      innerJoin(
        accounts,
        accounts.id.equalsExp(transactions.accountId),
      ),
    ])
      ..where(transactions.categoryId.equals(categoryId))
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    if (start != null) {
      query.where(transactions.date.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where(transactions.date.isSmallerOrEqualValue(end));
    }

    final rows = await query.get();
    return rows.map(_mapToTransactionWithDetails).toList();
  }

  Future<TransactionRow?> getTransactionById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> insertTransaction(TransactionsCompanion entry) async {
    await transaction(() async {
      await into(transactions).insert(entry);
      await _updateAccountBalance(
        entry.accountId.value,
        entry.amount.value,
        entry.type.value,
        isDelete: false,
      );
      if (entry.type.value == 'transfer' &&
          entry.toAccountId.value != null) {
        await _updateAccountBalance(
          entry.toAccountId.value!,
          entry.amount.value,
          'transfer_in',
          isDelete: false,
        );
      }
    });
  }

  Future<void> deleteTransaction(String id) async {
    final txn = await getTransactionById(id);
    if (txn == null) return;

    await transaction(() async {
      await _updateAccountBalance(
        txn.accountId,
        txn.amount,
        txn.type,
        isDelete: true,
      );
      if (txn.type == 'transfer' && txn.toAccountId != null) {
        await _updateAccountBalance(
          txn.toAccountId!,
          txn.amount,
          'transfer_in',
          isDelete: true,
        );
      }
      await (delete(transactions)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> updateTransaction(TransactionsCompanion entry) async {
    final oldTxn = await getTransactionById(entry.id.value);
    if (oldTxn == null) return;

    await transaction(() async {
      // Reverse old transaction
      await _updateAccountBalance(
        oldTxn.accountId,
        oldTxn.amount,
        oldTxn.type,
        isDelete: true,
      );
      if (oldTxn.type == 'transfer' && oldTxn.toAccountId != null) {
        await _updateAccountBalance(
          oldTxn.toAccountId!,
          oldTxn.amount,
          'transfer_in',
          isDelete: true,
        );
      }

      // Apply new transaction
      await (update(transactions)
            ..where((t) => t.id.equals(entry.id.value)))
          .write(entry);
      await _updateAccountBalance(
        entry.accountId.value,
        entry.amount.value,
        entry.type.value,
        isDelete: false,
      );
      if (entry.type.value == 'transfer' &&
          entry.toAccountId.value != null) {
        await _updateAccountBalance(
          entry.toAccountId.value!,
          entry.amount.value,
          'transfer_in',
          isDelete: false,
        );
      }
    });
  }

  Future<double> getTotalByType(
    String type,
    DateTime start,
    DateTime end,
  ) async {
    final sum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([sum])
      ..where(
        transactions.type.equals(type) &
            transactions.date.isBiggerOrEqualValue(start) &
            transactions.date.isSmallerOrEqualValue(end),
      );
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  Future<Map<String, double>> getSpendingByCategory(
    DateTime start,
    DateTime end,
  ) async {
    final sum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([transactions.categoryId, sum])
      ..where(
        transactions.type.equals('expense') &
            transactions.date.isBiggerOrEqualValue(start) &
            transactions.date.isSmallerOrEqualValue(end),
      )
      ..groupBy([transactions.categoryId]);

    final results = await query.get();
    final map = <String, double>{};
    for (final row in results) {
      final categoryId = row.read(transactions.categoryId);
      final total = row.read(sum) ?? 0;
      if (categoryId != null) {
        map[categoryId] = total;
      }
    }
    return map;
  }

  Future<void> _updateAccountBalance(
    String accountId,
    double amount,
    String type, {
    required bool isDelete,
  }) async {
    final account = await (select(accounts)
          ..where((t) => t.id.equals(accountId)))
        .getSingle();

    double newBalance;
    final sign = isDelete ? -1.0 : 1.0;

    switch (type) {
      case 'income':
      case 'transfer_in':
        newBalance = account.balance + (amount * sign);
      case 'expense':
      case 'transfer':
        newBalance = account.balance - (amount * sign);
      default:
        return;
    }

    await (update(accounts)..where((t) => t.id.equals(accountId))).write(
      AccountsCompanion(
        balance: Value(newBalance),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  TransactionWithDetails _mapToTransactionWithDetails(TypedResult row) {
    return TransactionWithDetails(
      transaction: row.readTable(transactions),
      category: row.readTableOrNull(categories),
      account: row.readTable(accounts),
    );
  }
}
