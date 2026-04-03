part of 'ai_insights_bloc.dart';

enum AiInsightsStatus { initial, loading, success, failure }

class AiInsightsState extends Equatable {
  const AiInsightsState({
    this.status = AiInsightsStatus.initial,
    this.insights = const [],
    this.anomalyCount = 0,
    this.trendCount = 0,
    this.recommendationCount = 0,
    this.failureMessage,
  });

  final AiInsightsStatus status;
  final List<AiInsightEntity> insights;
  final int anomalyCount;
  final int trendCount;
  final int recommendationCount;
  final String? failureMessage;

  AiInsightsState copyWith({
    AiInsightsStatus? status,
    List<AiInsightEntity>? insights,
    int? anomalyCount,
    int? trendCount,
    int? recommendationCount,
    String? failureMessage,
  }) {
    return AiInsightsState(
      status: status ?? this.status,
      insights: insights ?? this.insights,
      anomalyCount: anomalyCount ?? this.anomalyCount,
      trendCount: trendCount ?? this.trendCount,
      recommendationCount: recommendationCount ?? this.recommendationCount,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        insights,
        anomalyCount,
        trendCount,
        recommendationCount,
        failureMessage,
      ];
}
