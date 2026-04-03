import 'package:finwise/core/database/daos/achievements_dao.dart';
import 'package:finwise/core/database/daos/user_stats_dao.dart';
import 'package:finwise/features/achievements/domain/constants/achievement_definitions.dart';
import 'package:finwise/features/achievements/domain/entities/achievement_entity.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@injectable
class AchievementLocalDatasource {
  AchievementLocalDatasource(this._achievementsDao, this._userStatsDao);

  final AchievementsDao _achievementsDao;
  final UserStatsDao _userStatsDao;

  Future<List<AchievementEntity>> getAllAchievements() async {
    final rows = await _achievementsDao.getAllAchievements();
    return rows.map(_toEntity).toList();
  }

  Future<List<AchievementEntity>> getUnlockedAchievements() async {
    final rows = await _achievementsDao.getUnlockedAchievements();
    return rows.map(_toEntity).toList();
  }

  Future<List<AchievementEntity>> checkAndUnlockAchievements(
    Map<String, double> stats,
  ) async {
    final newlyUnlocked = <AchievementEntity>[];
    final allAchievements = await _achievementsDao.getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.unlockedAt != null) continue;

      final definition = achievementDefinitions.where(
        (d) => d.type == achievement.type,
      );
      if (definition.isEmpty) continue;

      if (definition.first.condition(stats)) {
        final now = DateTime.now();
        await _achievementsDao.unlockAchievement(achievement.id, now);
        newlyUnlocked.add(
          _toEntity(achievement).copyWith(unlockedAt: now),
        );
      }
    }

    return newlyUnlocked;
  }

  Future<Map<String, double>> getAllStats() async {
    return _userStatsDao.getAllStats();
  }

  Future<void> setStat(String key, double value) async {
    await _userStatsDao.setStat(key, value);
  }

  AchievementEntity _toEntity(AchievementRow row) {
    return AchievementEntity(
      id: row.id,
      type: row.type,
      title: row.title,
      description: row.description,
      iconName: row.iconName,
      unlockedAt: row.unlockedAt,
      createdAt: row.createdAt,
    );
  }
}
