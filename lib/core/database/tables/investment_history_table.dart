import 'package:drift/drift.dart';

@DataClassName('InvestmentHistoryRow')
class InvestmentHistory extends Table {
  TextColumn get id => text()();
  TextColumn get investmentId => text()();
  RealColumn get price => real()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
