import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/profiles_dao.dart';
import 'package:finwise/features/profiles/domain/entities/profile_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// DAO-backed local datasource for profiles.
@injectable
class ProfileLocalDatasource {
  ProfileLocalDatasource(this._dao);

  final ProfilesDao _dao;
  static const _uuid = Uuid();

  Future<List<ProfileEntity>> getAllProfiles() async {
    final rows = await _dao.getAllProfiles();
    return rows.map(_toEntity).toList();
  }

  Future<ProfileEntity?> getOwnerProfile() async {
    final row = await _dao.getOwnerProfile();
    return row == null ? null : _toEntity(row);
  }

  Future<void> insertProfile(ProfileEntity profile) async {
    final id = profile.id.isEmpty ? _uuid.v4() : profile.id;
    await _dao.insertProfile(
      ProfilesCompanion.insert(
        id: id,
        name: profile.name,
        email: profile.email == null
            ? const Value.absent()
            : Value(profile.email),
        avatarColor: Value(profile.avatarColor),
        isOwner: Value(profile.isOwner),
        createdAt: profile.createdAt,
      ),
    );
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    await _dao.updateProfile(
      ProfilesCompanion(
        id: Value(profile.id),
        name: Value(profile.name),
        email: profile.email == null
            ? const Value.absent()
            : Value(profile.email),
        avatarColor: Value(profile.avatarColor),
        isOwner: Value(profile.isOwner),
        createdAt: Value(profile.createdAt),
      ),
    );
  }

  Future<void> deleteProfile(String id) async {
    await _dao.deleteProfile(id);
  }

  static ProfileEntity _toEntity(ProfileRow row) {
    return ProfileEntity(
      id: row.id,
      name: row.name,
      email: row.email,
      avatarColor: row.avatarColor,
      isOwner: row.isOwner,
      createdAt: row.createdAt,
    );
  }
}
