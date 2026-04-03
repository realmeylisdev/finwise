import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/achievements/data/datasources/achievement_local_datasource.dart';
import 'package:finwise/features/achievements/domain/entities/achievement_entity.dart';
import 'package:finwise/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AchievementRepository)
class AchievementRepositoryImpl implements AchievementRepository {
  AchievementRepositoryImpl(this._datasource);

  final AchievementLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<AchievementEntity>>> getAchievements() async {
    try {
      final achievements = await _datasource.getAllAchievements();
      return Right(achievements);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AchievementEntity>>>
      getUnlockedAchievements() async {
    try {
      final achievements = await _datasource.getUnlockedAchievements();
      return Right(achievements);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AchievementEntity>>>
      checkAndUnlockAchievements(Map<String, double> stats) async {
    try {
      final newlyUnlocked =
          await _datasource.checkAndUnlockAchievements(stats);
      return Right(newlyUnlocked);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getStats() async {
    try {
      final stats = await _datasource.getAllStats();
      return Right(stats);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStat(String key, double value) async {
    try {
      await _datasource.setStat(key, value);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
