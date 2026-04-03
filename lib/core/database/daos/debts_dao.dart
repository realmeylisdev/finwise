import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/debts_table.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Future<List<DebtRow>> getAllDebts() =>
      (select(debts)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Future<DebtRow?> getDebtById(String id) =>
      (select(debts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertDebt(DebtsCompanion entry) => into(debts).insert(entry);

  Future<bool> updateDebt(DebtsCompanion entry) =>
      (update(debts)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteDebt(String id) =>
      (delete(debts)..where((t) => t.id.equals(id))).go();

  Future<double> getTotalDebtBalance() async {
    final rows = await getAllDebts();
    var total = 0.0;
    for (final row in rows) {
      total += row.balance;
    }
    return total;
  }
}
