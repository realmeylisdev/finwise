import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/achievements/domain/entities/achievement_entity.dart';
import 'package:finwise/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckAchievementsUseCase {
  CheckAchievementsUseCase(this._repository);

  final AchievementRepository _repository;

  Future<Either<Failure, List<AchievementEntity>>> call() async {
    final statsResult = await _repository.getStats();

    return statsResult.fold(
      (failure) => Left(failure),
      (stats) => _repository.checkAndUnlockAchievements(stats),
    );
  }
}
