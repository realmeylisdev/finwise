// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_worth_snapshots_dao.dart';

// ignore_for_file: type=lint
mixin _$NetWorthSnapshotsDaoMixin on DatabaseAccessor<AppDatabase> {
  $NetWorthSnapshotsTable get netWorthSnapshots =>
      attachedDatabase.netWorthSnapshots;
  NetWorthSnapshotsDaoManager get managers => NetWorthSnapshotsDaoManager(this);
}

class NetWorthSnapshotsDaoManager {
  final _$NetWorthSnapshotsDaoMixin _db;
  NetWorthSnapshotsDaoManager(this._db);
  $$NetWorthSnapshotsTableTableManager get netWorthSnapshots =>
      $$NetWorthSnapshotsTableTableManager(
        _db.attachedDatabase,
        _db.netWorthSnapshots,
      );
}
