import 'package:drift/drift.dart';

@DataClassName('DebtRow')
class Debts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type =>
      text()(); // credit_card, auto_loan, student_loan, mortgage, personal_loan, other
  RealColumn get balance => real()();
  RealColumn get interestRate => real().withDefault(const Constant(0))();
  RealColumn get minimumPayment => real().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
