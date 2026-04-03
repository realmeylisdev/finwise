part of 'ai_insights_bloc.dart';

abstract class AiInsightsEvent extends Equatable {
  const AiInsightsEvent();
  @override
  List<Object?> get props => [];
}

class AiInsightsLoaded extends AiInsightsEvent {
  const AiInsightsLoaded();
}
