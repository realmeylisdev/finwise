import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/transactions_dao.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransactionLocalDatasource {
  TransactionLocalDatasource(this._dao);

  final TransactionsDao _dao;

  Future<List<TransactionEntity>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    final rows = await _dao.getAllTransactions(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  Stream<List<TransactionEntity>> watchTransactions({int? limit}) {
    return _dao.watchAllTransactions(limit: limit).map(
          (rows) => rows.map(_toEntity).toList(),
        );
  }

  Future<List<TransactionEntity>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await _dao.getTransactionsByDateRange(start, end);
    return rows.map(_toEntity).toList();
  }

  Future<List<TransactionEntity>> getTransactionsByAccount(
    String accountId,
  ) async {
    final rows = await _dao.getTransactionsByAccount(accountId);
    return rows.map(_toEntity).toList();
  }

  Future<List<TransactionEntity>> getTransactionsByCategory(
    String categoryId, {
    DateTime? start,
    DateTime? end,
  }) async {
    final rows = await _dao.getTransactionsByCategory(
      categoryId,
      start: start,
      end: end,
    );
    return rows.map(_toEntity).toList();
  }

  Future<void> insertTransaction(TransactionEntity entity) async {
    await _dao.insertTransaction(
      TransactionsCompanion.insert(
        id: entity.id,
        amount: entity.amount,
        type: entity.type.name,
        categoryId: Value(entity.categoryId),
        accountId: entity.accountId,
        toAccountId: Value(entity.toAccountId),
        note: Value(entity.note),
        date: entity.date,
        currencyCode: entity.currencyCode,
        exchangeRate: Value(entity.exchangeRate),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateTransaction(TransactionEntity entity) async {
    await _dao.updateTransaction(
      TransactionsCompanion(
        id: Value(entity.id),
        amount: Value(entity.amount),
        type: Value(entity.type.name),
        categoryId: Value(entity.categoryId),
        accountId: Value(entity.accountId),
        toAccountId: Value(entity.toAccountId),
        note: Value(entity.note),
        date: Value(entity.date),
        currencyCode: Value(entity.currencyCode),
        exchangeRate: Value(entity.exchangeRate),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteTransaction(String id) async {
    await _dao.deleteTransaction(id);
  }

  Future<double> getTotalByType(
    String type,
    DateTime start,
    DateTime end,
  ) async {
    return _dao.getTotalByType(type, start, end);
  }

  Future<Map<String, double>> getSpendingByCategory(
    DateTime start,
    DateTime end,
  ) async {
    return _dao.getSpendingByCategory(start, end);
  }

  TransactionEntity _toEntity(TransactionWithDetails row) {
    final txn = row.transaction;
    return TransactionEntity(
      id: txn.id,
      amount: txn.amount,
      type: TransactionEntity.typeFromString(txn.type),
      categoryId: txn.categoryId,
      accountId: txn.accountId,
      toAccountId: txn.toAccountId,
      note: txn.note,
      date: txn.date,
      currencyCode: txn.currencyCode,
      exchangeRate: txn.exchangeRate,
      isRecurring: txn.isRecurring,
      createdAt: txn.createdAt,
      updatedAt: txn.updatedAt,
      categoryName: row.category?.name,
      categoryIcon: row.category?.icon,
      categoryColor: row.category?.color,
      accountName: row.account.name,
      toAccountName: row.toAccount?.name,
    );
  }
}
