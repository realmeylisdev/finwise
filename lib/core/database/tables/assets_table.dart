import 'package:drift/drift.dart';

@DataClassName('AssetRow')
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // property, vehicle, crypto, stock, other
  RealColumn get value => real()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
