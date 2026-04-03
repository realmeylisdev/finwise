import 'package:drift/drift.dart';

@DataClassName('BudgetRow')
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text()();
  RealColumn get amount => real()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  RealColumn get rolloverAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {categoryId, year, month},
      ];
}
