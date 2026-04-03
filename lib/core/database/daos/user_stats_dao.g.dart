// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_dao.dart';

// ignore_for_file: type=lint
mixin _$UserStatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserStatsTable get userStats => attachedDatabase.userStats;
  UserStatsDaoManager get managers => UserStatsDaoManager(this);
}

class UserStatsDaoManager {
  final _$UserStatsDaoMixin _db;
  UserStatsDaoManager(this._db);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db.attachedDatabase, _db.userStats);
}
