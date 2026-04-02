import 'package:drift/drift.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()();
  RealColumn get balance => real().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get icon => text().nullable()();
  IntColumn get color => integer().nullable()();
  BoolColumn get includeInTotal =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
