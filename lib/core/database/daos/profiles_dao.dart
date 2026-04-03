import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/tables/profiles_table.dart';

part 'profiles_dao.g.dart';

@DriftAccessor(tables: [Profiles])
class ProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$ProfilesDaoMixin {
  ProfilesDao(super.db);

  Future<List<ProfileRow>> getAllProfiles() =>
      (select(profiles)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Future<ProfileRow?> getOwnerProfile() =>
      (select(profiles)..where((t) => t.isOwner.equals(true)))
          .getSingleOrNull();

  Future<ProfileRow?> getProfileById(String id) =>
      (select(profiles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertProfile(ProfilesCompanion entry) =>
      into(profiles).insert(entry);

  Future<bool> updateProfile(ProfilesCompanion entry) =>
      (update(profiles)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteProfile(String id) =>
      (delete(profiles)..where((t) => t.id.equals(id))).go();
}
