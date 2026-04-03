import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/ai_insights/domain/entities/ai_insight_entity.dart';
import 'package:finwise/features/ai_insights/domain/usecases/analyze_spending_patterns_usecase.dart';
import 'package:finwise/features/ai_insights/domain/usecases/detect_anomalies_usecase.dart';
import 'package:injectable/injectable.dart';

part 'ai_insights_event.dart';
part 'ai_insights_state.dart';

@injectable
class AiInsightsBloc extends Bloc<AiInsightsEvent, AiInsightsState> {
  AiInsightsBloc({
    required AnalyzeSpendingPatternsUseCase analyzeSpendingPatternsUseCase,
    required DetectAnomaliesUseCase detectAnomaliesUseCase,
  })  : _analyzeSpendingPatterns = analyzeSpendingPatternsUseCase,
        _detectAnomalies = detectAnomaliesUseCase,
        super(const AiInsightsState()) {
    on<AiInsightsLoaded>(_onLoaded, transformer: droppable());
  }

  final AnalyzeSpendingPatternsUseCase _analyzeSpendingPatterns;
  final DetectAnomaliesUseCase _detectAnomalies;

  Future<void> _onLoaded(
    AiInsightsLoaded event,
    Emitter<AiInsightsState> emit,
  ) async {
    emit(state.copyWith(status: AiInsightsStatus.loading));

    try {
      final results = await Future.wait([
        _analyzeSpendingPatterns(),
        _detectAnomalies(),
      ]);

      final patternInsights = results[0];
      final anomalyInsights = results[1];

      // Merge and deduplicate (anomalies from detect may overlap with patterns)
      final allInsights = <AiInsightEntity>[
        ...patternInsights,
        ...anomalyInsights,
      ];

      // Deduplicate by id
      final seen = <String>{};
      final uniqueInsights = <AiInsightEntity>[];
      for (final insight in allInsights) {
        if (seen.add(insight.id)) {
          uniqueInsights.add(insight);
        }
      }

      // Sort by severity: warning first, then positive, then info
      uniqueInsights.sort((a, b) {
        const order = {
          InsightSeverity.warning: 0,
          InsightSeverity.positive: 1,
          InsightSeverity.info: 2,
        };
        return order[a.severity]!.compareTo(order[b.severity]!);
      });

      final anomalyCount = uniqueInsights
          .where((i) => i.category == InsightCategory.anomaly)
          .length;
      final trendCount = uniqueInsights
          .where(
            (i) =>
                i.category == InsightCategory.trend ||
                i.category == InsightCategory.forecast,
          )
          .length;
      final recommendationCount = uniqueInsights
          .where((i) => i.category == InsightCategory.recommendation)
          .length;

      emit(state.copyWith(
        status: AiInsightsStatus.success,
        insights: uniqueInsights,
        anomalyCount: anomalyCount,
        trendCount: trendCount,
        recommendationCount: recommendationCount,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: AiInsightsStatus.failure,
        failureMessage: e.toString(),
      ));
    }
  }
}
