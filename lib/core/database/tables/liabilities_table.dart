import 'package:drift/drift.dart';

@DataClassName('LiabilityRow')
class Liabilities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type =>
      text()(); // mortgage, car_loan, student_loan, credit_card, personal_loan, other
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
