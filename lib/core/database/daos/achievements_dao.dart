import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/achievements_table.dart';

part 'achievements_dao.g.dart';

@DriftAccessor(tables: [Achievements])
class AchievementsDao extends DatabaseAccessor<AppDatabase>
    with _$AchievementsDaoMixin {
  AchievementsDao(super.db);

  Future<List<AchievementRow>> getAllAchievements() =>
      (select(achievements)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<AchievementRow>> getUnlockedAchievements() =>
      (select(achievements)
            ..where((t) => t.unlockedAt.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.unlockedAt)]))
          .get();

  Future<void> unlockAchievement(String id, DateTime unlockedAt) async {
    await (update(achievements)..where((t) => t.id.equals(id))).write(
      AchievementsCompanion(unlockedAt: Value(unlockedAt)),
    );
  }

  Future<int> insertAchievement(AchievementsCompanion entry) =>
      into(achievements).insert(entry);

  Future<bool> isUnlocked(String type) async {
    final row = await (select(achievements)
          ..where(
            (t) => t.type.equals(type) & t.unlockedAt.isNotNull(),
          ))
        .getSingleOrNull();
    return row != null;
  }
}
