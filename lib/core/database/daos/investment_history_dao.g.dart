// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_history_dao.dart';

// ignore_for_file: type=lint
mixin _$InvestmentHistoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $InvestmentHistoryTable get investmentHistory =>
      attachedDatabase.investmentHistory;
  InvestmentHistoryDaoManager get managers => InvestmentHistoryDaoManager(this);
}

class InvestmentHistoryDaoManager {
  final _$InvestmentHistoryDaoMixin _db;
  InvestmentHistoryDaoManager(this._db);
  $$InvestmentHistoryTableTableManager get investmentHistory =>
      $$InvestmentHistoryTableTableManager(
        _db.attachedDatabase,
        _db.investmentHistory,
      );
}
