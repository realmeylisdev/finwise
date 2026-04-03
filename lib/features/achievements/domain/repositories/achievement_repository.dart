import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/achievements/domain/entities/achievement_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AchievementRepository {
  Future<Either<Failure, List<AchievementEntity>>> getAchievements();
  Future<Either<Failure, List<AchievementEntity>>> getUnlockedAchievements();
  Future<Either<Failure, List<AchievementEntity>>>
      checkAndUnlockAchievements(Map<String, double> stats);
  Future<Either<Failure, Map<String, double>>> getStats();
  Future<Either<Failure, void>> updateStat(String key, double value);
}
