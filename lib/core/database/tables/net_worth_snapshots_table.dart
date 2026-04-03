import 'package:drift/drift.dart';

@DataClassName('NetWorthSnapshotRow')
class NetWorthSnapshots extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get totalAssets => real()();
  RealColumn get totalLiabilities => real()();
  RealColumn get netWorth => real()();

  @override
  Set<Column> get primaryKey => {id};
}
