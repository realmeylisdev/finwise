import 'package:drift/drift.dart';

@DataClassName('SharedBudgetRow')
class SharedBudgets extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text()();
  TextColumn get profileId => text()();
  TextColumn get accessLevel =>
      text().withDefault(const Constant('viewer'))(); // owner, editor, viewer

  @override
  Set<Column> get primaryKey => {id};
}
