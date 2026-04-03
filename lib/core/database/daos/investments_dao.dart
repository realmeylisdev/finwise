import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/investments_table.dart';

part 'investments_dao.g.dart';

@DriftAccessor(tables: [Investments])
class InvestmentsDao extends DatabaseAccessor<AppDatabase>
    with _$InvestmentsDaoMixin {
  InvestmentsDao(super.db);

  Future<List<InvestmentRow>> getAllInvestments() =>
      (select(investments)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<InvestmentRow?> getInvestmentById(String id) =>
      (select(investments)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertInvestment(InvestmentsCompanion entry) =>
      into(investments).insert(entry);

  Future<bool> updateInvestment(InvestmentsCompanion entry) =>
      (update(investments)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteInvestment(String id) =>
      (delete(investments)..where((t) => t.id.equals(id))).go();

  Future<double> getTotalValue() async {
    final all = await select(investments).get();
    return all.fold<double>(0, (sum, i) => sum + i.units * i.currentPrice);
  }
}
