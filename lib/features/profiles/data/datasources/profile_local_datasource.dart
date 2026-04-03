import 'package:finwise/features/profiles/domain/entities/profile_entity.dart';
import 'package:injectable/injectable.dart';

/// In-memory datasource for profiles.
///
/// TODO(batch-4.4): Replace with DAO-backed datasource once [ProfilesDao]
/// is registered in [AppDatabase] and schema v10 migration is added.
@singleton
class ProfileLocalDatasource {
  final List<ProfileEntity> _store = [
    ProfileEntity(
      id: 'owner-default',
      name: 'Me',
      avatarColor: 0xFF6366F1,
      isOwner: true,
      createdAt: DateTime.now(),
    ),
  ];

  Future<List<ProfileEntity>> getAllProfiles() async {
    return List.unmodifiable(_store);
  }

  Future<ProfileEntity?> getOwnerProfile() async {
    try {
      return _store.firstWhere((p) => p.isOwner);
    } catch (_) {
      return null;
    }
  }

  Future<void> insertProfile(ProfileEntity profile) async {
    _store.add(profile);
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    final index = _store.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _store[index] = profile;
    }
  }

  Future<void> deleteProfile(String id) async {
    _store.removeWhere((p) => p.id == id);
  }
}
