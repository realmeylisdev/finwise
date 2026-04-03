part of 'wellness_score_bloc.dart';

enum WellnessScoreStatus { initial, loading, success, failure }

class WellnessScoreState extends Equatable {
  const WellnessScoreState({
    this.status = WellnessScoreStatus.initial,
    this.score,
    this.failureMessage,
  });

  final WellnessScoreStatus status;
  final WellnessScoreEntity? score;
  final String? failureMessage;

  WellnessScoreState copyWith({
    WellnessScoreStatus? status,
    WellnessScoreEntity? score,
    String? failureMessage,
  }) {
    return WellnessScoreState(
      status: status ?? this.status,
      score: score ?? this.score,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, score, failureMessage];
}
