// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_splits_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionSplitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransactionSplitsTable get transactionSplits =>
      attachedDatabase.transactionSplits;
  $CategoriesTable get categories => attachedDatabase.categories;
  TransactionSplitsDaoManager get managers => TransactionSplitsDaoManager(this);
}

class TransactionSplitsDaoManager {
  final _$TransactionSplitsDaoMixin _db;
  TransactionSplitsDaoManager(this._db);
  $$TransactionSplitsTableTableManager get transactionSplits =>
      $$TransactionSplitsTableTableManager(
        _db.attachedDatabase,
        _db.transactionSplits,
      );
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
}
