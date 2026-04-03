import 'package:drift/drift.dart';

@DataClassName('InvestmentRow')
class Investments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // stock, etf, mutual_fund, crypto, bond, other
  TextColumn get ticker => text().nullable()();
  RealColumn get units => real()();
  RealColumn get costBasis => real()();
  RealColumn get currentPrice => real()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
