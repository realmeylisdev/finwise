// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_payments_dao.dart';

// ignore_for_file: type=lint
mixin _$DebtPaymentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DebtPaymentsTable get debtPayments => attachedDatabase.debtPayments;
  DebtPaymentsDaoManager get managers => DebtPaymentsDaoManager(this);
}

class DebtPaymentsDaoManager {
  final _$DebtPaymentsDaoMixin _db;
  DebtPaymentsDaoManager(this._db);
  $$DebtPaymentsTableTableManager get debtPayments =>
      $$DebtPaymentsTableTableManager(_db.attachedDatabase, _db.debtPayments);
}
