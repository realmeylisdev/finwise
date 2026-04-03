part of 'achievements_bloc.dart';

abstract class AchievementsEvent extends Equatable {
  const AchievementsEvent();
  @override
  List<Object?> get props => [];
}

class AchievementsLoaded extends AchievementsEvent {
  const AchievementsLoaded();
}

class AchievementCheckRequested extends AchievementsEvent {
  const AchievementCheckRequested();
}

class StatUpdated extends AchievementsEvent {
  const StatUpdated(this.key, this.value);
  final String key;
  final double value;
  @override
  List<Object?> get props => [key, value];
}
