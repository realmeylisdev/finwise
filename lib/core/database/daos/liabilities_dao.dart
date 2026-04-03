import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/liabilities_table.dart';

part 'liabilities_dao.g.dart';

@DriftAccessor(tables: [Liabilities])
class LiabilitiesDao extends DatabaseAccessor<AppDatabase>
    with _$LiabilitiesDaoMixin {
  LiabilitiesDao(super.db);

  Future<List<LiabilityRow>> getAllLiabilities() =>
      (select(liabilities)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<LiabilityRow?> getLiabilityById(String id) =>
      (select(liabilities)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertLiability(LiabilitiesCompanion entry) =>
      into(liabilities).insert(entry);

  Future<bool> updateLiability(LiabilitiesCompanion entry) =>
      (update(liabilities)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteLiability(String id) =>
      (delete(liabilities)..where((t) => t.id.equals(id))).go();

  Future<double> getTotalBalance() async {
    final allLiabilities = await select(liabilities).get();
    return allLiabilities.fold<double>(0, (sum, l) => sum + l.balance);
  }
}
