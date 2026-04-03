part of 'recurring_detection_bloc.dart';

enum RecurringDetectionStatus { initial, loading, success, failure }

class RecurringDetectionState extends Equatable {
  const RecurringDetectionState({
    this.status = RecurringDetectionStatus.initial,
    this.patterns = const [],
    this.failureMessage,
  });

  final RecurringDetectionStatus status;
  final List<RecurringPatternEntity> patterns;
  final String? failureMessage;

  RecurringDetectionState copyWith({
    RecurringDetectionStatus? status,
    List<RecurringPatternEntity>? patterns,
    String? failureMessage,
  }) {
    return RecurringDetectionState(
      status: status ?? this.status,
      patterns: patterns ?? this.patterns,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, patterns, failureMessage];
}
