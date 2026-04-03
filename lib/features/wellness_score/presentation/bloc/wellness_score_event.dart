part of 'wellness_score_bloc.dart';

abstract class WellnessScoreEvent extends Equatable {
  const WellnessScoreEvent();
  @override
  List<Object?> get props => [];
}

class WellnessScoreLoaded extends WellnessScoreEvent {
  const WellnessScoreLoaded();
}
