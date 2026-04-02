import 'package:drift/drift.dart';

@DataClassName('CurrencyRow')
class Currencies extends Table {
  TextColumn get code => text().withLength(min: 3, max: 3)();
  TextColumn get name => text()();
  TextColumn get symbol => text()();
  IntColumn get decimalPlaces => integer().withDefault(const Constant(2))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {code};
}
