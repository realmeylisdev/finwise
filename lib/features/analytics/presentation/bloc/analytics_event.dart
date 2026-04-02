part of 'analytics_bloc.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
  @override
  List<Object?> get props => [];
}

class AnalyticsLoaded extends AnalyticsEvent {
  const AnalyticsLoaded();
}

class AnalyticsPeriodChanged extends AnalyticsEvent {
  const AnalyticsPeriodChanged(this.period);
  final AnalyticsPeriod period;
  @override
  List<Object?> get props => [period];
}
