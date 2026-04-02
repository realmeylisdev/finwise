import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/currencies_table.dart';

part 'currencies_dao.g.dart';

@DriftAccessor(tables: [Currencies])
class CurrenciesDao extends DatabaseAccessor<AppDatabase>
    with _$CurrenciesDaoMixin {
  CurrenciesDao(super.db);

  Future<List<CurrencyRow>> getAllCurrencies() => select(currencies).get();

  Stream<List<CurrencyRow>> watchAllCurrencies() =>
      select(currencies).watch();

  Future<CurrencyRow?> getCurrencyByCode(String code) =>
      (select(currencies)..where((t) => t.code.equals(code)))
          .getSingleOrNull();

  Future<CurrencyRow?> getDefaultCurrency() =>
      (select(currencies)..where((t) => t.isDefault.equals(true)))
          .getSingleOrNull();

  Future<int> insertCurrency(CurrenciesCompanion entry) =>
      into(currencies).insert(entry, mode: InsertMode.insertOrIgnore);

  Future<bool> updateCurrency(CurrenciesCompanion entry) =>
      update(currencies).replace(
        CurrencyRow(
          code: entry.code.value,
          name: entry.name.value,
          symbol: entry.symbol.value,
          decimalPlaces: entry.decimalPlaces.value,
          isDefault: entry.isDefault.value,
        ),
      );

  Future<void> setDefaultCurrency(String code) async {
    await transaction(() async {
      await (update(currencies)
            ..where((t) => t.isDefault.equals(true)))
          .write(const CurrenciesCompanion(isDefault: Value(false)));
      await (update(currencies)
            ..where((t) => t.code.equals(code)))
          .write(const CurrenciesCompanion(isDefault: Value(true)));
    });
  }
}
