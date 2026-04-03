import 'package:drift/drift.dart';

@DataClassName('DebtPaymentRow')
class DebtPayments extends Table {
  TextColumn get id => text()();
  TextColumn get debtId => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
