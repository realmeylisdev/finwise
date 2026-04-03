import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/assets_dao.dart';
import 'package:finwise/core/database/daos/liabilities_dao.dart';
import 'package:finwise/core/database/daos/net_worth_snapshots_dao.dart';
import 'package:finwise/features/net_worth/domain/entities/asset_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/liability_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/net_worth_snapshot_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class NetWorthLocalDatasource {
  NetWorthLocalDatasource(
    this._assetsDao,
    this._liabilitiesDao,
    this._snapshotsDao,
  );

  final AssetsDao _assetsDao;
  final LiabilitiesDao _liabilitiesDao;
  final NetWorthSnapshotsDao _snapshotsDao;

  // ── Assets ──

  Future<List<AssetEntity>> getAssets() async {
    final rows = await _assetsDao.getAllAssets();
    return rows.map(_assetToEntity).toList();
  }

  Future<void> insertAsset(AssetEntity entity) async {
    await _assetsDao.insertAsset(
      AssetsCompanion.insert(
        id: entity.id,
        name: entity.name,
        type: AssetEntity.typeToString(entity.type),
        value: entity.value,
        currencyCode: entity.currencyCode,
        notes: Value(entity.notes),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateAsset(AssetEntity entity) async {
    await _assetsDao.updateAsset(
      AssetsCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        type: Value(AssetEntity.typeToString(entity.type)),
        value: Value(entity.value),
        currencyCode: Value(entity.currencyCode),
        notes: Value(entity.notes),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteAsset(String id) async {
    await _assetsDao.deleteAsset(id);
  }

  Future<double> getTotalAssets() async {
    return _assetsDao.getTotalValue();
  }

  // ── Liabilities ──

  Future<List<LiabilityEntity>> getLiabilities() async {
    final rows = await _liabilitiesDao.getAllLiabilities();
    return rows.map(_liabilityToEntity).toList();
  }

  Future<void> insertLiability(LiabilityEntity entity) async {
    await _liabilitiesDao.insertLiability(
      LiabilitiesCompanion.insert(
        id: entity.id,
        name: entity.name,
        type: LiabilityEntity.typeToString(entity.type),
        balance: entity.balance,
        interestRate: Value(entity.interestRate),
        minimumPayment: Value(entity.minimumPayment),
        currencyCode: entity.currencyCode,
        notes: Value(entity.notes),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateLiability(LiabilityEntity entity) async {
    await _liabilitiesDao.updateLiability(
      LiabilitiesCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        type: Value(LiabilityEntity.typeToString(entity.type)),
        balance: Value(entity.balance),
        interestRate: Value(entity.interestRate),
        minimumPayment: Value(entity.minimumPayment),
        currencyCode: Value(entity.currencyCode),
        notes: Value(entity.notes),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteLiability(String id) async {
    await _liabilitiesDao.deleteLiability(id);
  }

  Future<double> getTotalLiabilities() async {
    return _liabilitiesDao.getTotalBalance();
  }

  // ── Snapshots ──

  Future<List<NetWorthSnapshotEntity>> getSnapshots() async {
    final rows = await _snapshotsDao.getAllSnapshots();
    return rows.map(_snapshotToEntity).toList();
  }

  Future<NetWorthSnapshotEntity> takeSnapshot() async {
    final totalAssets = await getTotalAssets();
    final totalLiabilities = await getTotalLiabilities();
    final netWorth = totalAssets - totalLiabilities;

    final entity = NetWorthSnapshotEntity(
      id: const Uuid().v4(),
      date: DateTime.now(),
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      netWorth: netWorth,
    );

    await _snapshotsDao.insertSnapshot(
      NetWorthSnapshotsCompanion.insert(
        id: entity.id,
        date: entity.date,
        totalAssets: entity.totalAssets,
        totalLiabilities: entity.totalLiabilities,
        netWorth: entity.netWorth,
      ),
    );

    return entity;
  }

  Future<double> getCurrentNetWorth() async {
    final totalAssets = await getTotalAssets();
    final totalLiabilities = await getTotalLiabilities();
    return totalAssets - totalLiabilities;
  }

  // ── Mappers ──

  AssetEntity _assetToEntity(AssetRow row) {
    return AssetEntity(
      id: row.id,
      name: row.name,
      type: AssetEntity.typeFromString(row.type),
      value: row.value,
      currencyCode: row.currencyCode,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  LiabilityEntity _liabilityToEntity(LiabilityRow row) {
    return LiabilityEntity(
      id: row.id,
      name: row.name,
      type: LiabilityEntity.typeFromString(row.type),
      balance: row.balance,
      interestRate: row.interestRate,
      minimumPayment: row.minimumPayment,
      currencyCode: row.currencyCode,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  NetWorthSnapshotEntity _snapshotToEntity(NetWorthSnapshotRow row) {
    return NetWorthSnapshotEntity(
      id: row.id,
      date: row.date,
      totalAssets: row.totalAssets,
      totalLiabilities: row.totalLiabilities,
      netWorth: row.netWorth,
    );
  }
}
