// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_budgets_dao.dart';

// ignore_for_file: type=lint
mixin _$SharedBudgetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SharedBudgetsTable get sharedBudgets => attachedDatabase.sharedBudgets;
  SharedBudgetsDaoManager get managers => SharedBudgetsDaoManager(this);
}

class SharedBudgetsDaoManager {
  final _$SharedBudgetsDaoMixin _db;
  SharedBudgetsDaoManager(this._db);
  $$SharedBudgetsTableTableManager get sharedBudgets =>
      $$SharedBudgetsTableTableManager(_db.attachedDatabase, _db.sharedBudgets);
}
