import 'package:drift/drift.dart';

@DataClassName('CategoryRuleRow')
class CategoryRules extends Table {
  TextColumn get id => text()();
  TextColumn get keyword => text().withLength(min: 1, max: 100)();
  TextColumn get categoryId => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
