part of 'achievements_bloc.dart';

enum AchievementsStatus { initial, loading, success, failure }

class AchievementsState extends Equatable {
  const AchievementsState({
    this.status = AchievementsStatus.initial,
    this.achievements = const [],
    this.unlockedCount = 0,
    this.totalCount = 0,
    this.currentStreak = 0,
    this.failureMessage,
  });

  final AchievementsStatus status;
  final List<AchievementEntity> achievements;
  final int unlockedCount;
  final int totalCount;
  final int currentStreak;
  final String? failureMessage;

  AchievementsState copyWith({
    AchievementsStatus? status,
    List<AchievementEntity>? achievements,
    int? unlockedCount,
    int? totalCount,
    int? currentStreak,
    String? failureMessage,
  }) {
    return AchievementsState(
      status: status ?? this.status,
      achievements: achievements ?? this.achievements,
      unlockedCount: unlockedCount ?? this.unlockedCount,
      totalCount: totalCount ?? this.totalCount,
      currentStreak: currentStreak ?? this.currentStreak,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        achievements,
        unlockedCount,
        totalCount,
        currentStreak,
        failureMessage,
      ];
}
