import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/assets_table.dart';

part 'assets_dao.g.dart';

@DriftAccessor(tables: [Assets])
class AssetsDao extends DatabaseAccessor<AppDatabase> with _$AssetsDaoMixin {
  AssetsDao(super.db);

  Future<List<AssetRow>> getAllAssets() =>
      (select(assets)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Future<AssetRow?> getAssetById(String id) =>
      (select(assets)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertAsset(AssetsCompanion entry) =>
      into(assets).insert(entry);

  Future<bool> updateAsset(AssetsCompanion entry) =>
      (update(assets)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteAsset(String id) =>
      (delete(assets)..where((t) => t.id.equals(id))).go();

  Future<double> getTotalValue() async {
    final allAssets = await select(assets).get();
    return allAssets.fold<double>(0, (sum, a) => sum + a.value);
  }
}
