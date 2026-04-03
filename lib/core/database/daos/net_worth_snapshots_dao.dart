import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/net_worth_snapshots_table.dart';

part 'net_worth_snapshots_dao.g.dart';

@DriftAccessor(tables: [NetWorthSnapshots])
class NetWorthSnapshotsDao extends DatabaseAccessor<AppDatabase>
    with _$NetWorthSnapshotsDaoMixin {
  NetWorthSnapshotsDao(super.db);

  Future<List<NetWorthSnapshotRow>> getAllSnapshots() =>
      (select(netWorthSnapshots)
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<int> insertSnapshot(NetWorthSnapshotsCompanion entry) =>
      into(netWorthSnapshots).insert(entry);

  Future<NetWorthSnapshotRow?> getLatestSnapshot() =>
      (select(netWorthSnapshots)
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<NetWorthSnapshotRow>> getSnapshotsByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(netWorthSnapshots)
            ..where(
              (t) =>
                  t.date.isBiggerOrEqualValue(start) &
                  t.date.isSmallerOrEqualValue(end),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();
}
