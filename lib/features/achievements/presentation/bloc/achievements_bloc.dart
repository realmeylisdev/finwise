import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/achievements/domain/entities/achievement_entity.dart';
import 'package:finwise/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:finwise/features/achievements/domain/usecases/check_achievements_usecase.dart';
import 'package:injectable/injectable.dart';

part 'achievements_event.dart';
part 'achievements_state.dart';

@injectable
class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  AchievementsBloc({
    required AchievementRepository repository,
    required CheckAchievementsUseCase checkAchievementsUseCase,
  })  : _repository = repository,
        _checkAchievementsUseCase = checkAchievementsUseCase,
        super(const AchievementsState()) {
    on<AchievementsLoaded>(_onLoaded, transformer: droppable());
    on<AchievementCheckRequested>(_onCheckRequested, transformer: droppable());
    on<StatUpdated>(_onStatUpdated, transformer: droppable());
  }

  final AchievementRepository _repository;
  final CheckAchievementsUseCase _checkAchievementsUseCase;

  Future<void> _onLoaded(
    AchievementsLoaded event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(state.copyWith(status: AchievementsStatus.loading));

    final result = await _repository.getAchievements();
    final statsResult = await _repository.getStats();

    result.fold(
      (failure) => emit(state.copyWith(
        status: AchievementsStatus.failure,
        failureMessage: failure.message,
      )),
      (achievements) {
        final unlocked = achievements.where((a) => a.isUnlocked).length;
        final streak = statsResult.fold(
          (_) => 0,
          (stats) => (stats['current_streak'] ?? 0).toInt(),
        );

        emit(state.copyWith(
          status: AchievementsStatus.success,
          achievements: achievements,
          unlockedCount: unlocked,
          totalCount: achievements.length,
          currentStreak: streak,
        ));
      },
    );
  }

  Future<void> _onCheckRequested(
    AchievementCheckRequested event,
    Emitter<AchievementsState> emit,
  ) async {
    await _checkAchievementsUseCase();
    add(const AchievementsLoaded());
  }

  Future<void> _onStatUpdated(
    StatUpdated event,
    Emitter<AchievementsState> emit,
  ) async {
    await _repository.updateStat(event.key, event.value);
    await _checkAchievementsUseCase();
    add(const AchievementsLoaded());
  }
}
