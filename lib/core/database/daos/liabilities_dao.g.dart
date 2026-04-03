// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liabilities_dao.dart';

// ignore_for_file: type=lint
mixin _$LiabilitiesDaoMixin on DatabaseAccessor<AppDatabase> {
  $LiabilitiesTable get liabilities => attachedDatabase.liabilities;
  LiabilitiesDaoManager get managers => LiabilitiesDaoManager(this);
}

class LiabilitiesDaoManager {
  final _$LiabilitiesDaoMixin _db;
  LiabilitiesDaoManager(this._db);
  $$LiabilitiesTableTableManager get liabilities =>
      $$LiabilitiesTableTableManager(_db.attachedDatabase, _db.liabilities);
}
