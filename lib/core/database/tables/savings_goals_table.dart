import 'package:drift/drift.dart';

@DataClassName('SavingsGoalRow')
class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get targetAmount => real()();
  RealColumn get savedAmount => real().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
