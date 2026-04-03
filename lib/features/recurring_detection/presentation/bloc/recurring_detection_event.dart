part of 'recurring_detection_bloc.dart';

abstract class RecurringDetectionEvent extends Equatable {
  const RecurringDetectionEvent();
  @override
  List<Object?> get props => [];
}

class RecurringPatternsLoaded extends RecurringDetectionEvent {
  const RecurringPatternsLoaded();
}
