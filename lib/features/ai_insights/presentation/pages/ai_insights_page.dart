import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/ai_insights/domain/entities/ai_insight_entity.dart';
import 'package:finwise/features/ai_insights/presentation/bloc/ai_insights_bloc.dart';
import 'package:finwise/features/ai_insights/presentation/widgets/insight_card.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:finwise/shared/widgets/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiInsightsPage extends StatefulWidget {
  const AiInsightsPage({super.key});

  @override
  State<AiInsightsPage> createState() => _AiInsightsPageState();
}

class _AiInsightsPageState extends State<AiInsightsPage> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AiInsightsBloc>().add(const AiInsightsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Insights'),
      ),
      body: BlocBuilder<AiInsightsBloc, AiInsightsState>(
        builder: (context, state) {
          if (state.status == AiInsightsStatus.loading ||
              state.status == AiInsightsStatus.initial) {
            return Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                children: List.generate(
                  4,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.paddingS),
                    child: const SkeletonCard(),
                  ),
                ),
              ),
            );
          }

          if (state.status == AiInsightsStatus.failure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(
                      icon: HugeIcons.strokeRoundedAlert02,
                      size: 48.w,
                      color: AppColors.expense,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Could not analyze data',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () => context
                          .read<AiInsightsBloc>()
                          .add(const AiInsightsLoaded()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final filteredInsights = _filterInsights(state.insights);

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<AiInsightsBloc>()
                  .add(const AiInsightsLoaded());
            },
            child: ListView(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              children: [
                // Summary header
                _SummaryHeader(
                  anomalyCount: state.anomalyCount,
                  trendCount: state.trendCount,
                  recommendationCount: state.recommendationCount,
                ),
                SizedBox(height: AppDimensions.paddingM),

                // Tab bar
                _PillTabBar(
                  selectedIndex: _selectedTabIndex,
                  onSelected: (index) =>
                      setState(() => _selectedTabIndex = index),
                ),
                SizedBox(height: AppDimensions.paddingM),

                // Insight cards or empty state
                if (filteredInsights.isEmpty)
                  _EmptyState(tabIndex: _selectedTabIndex)
                else
                  ...filteredInsights.map(
                    (insight) => InsightCard(insight: insight),
                  ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }

  List<AiInsightEntity> _filterInsights(List<AiInsightEntity> insights) {
    switch (_selectedTabIndex) {
      case 1:
        return insights
            .where((i) => i.category == InsightCategory.anomaly)
            .toList();
      case 2:
        return insights
            .where(
              (i) =>
                  i.category == InsightCategory.trend ||
                  i.category == InsightCategory.forecast,
            )
            .toList();
      case 3:
        return insights
            .where((i) => i.category == InsightCategory.recommendation)
            .toList();
      default:
        return insights;
    }
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.anomalyCount,
    required this.trendCount,
    required this.recommendationCount,
  });

  final int anomalyCount;
  final int trendCount;
  final int recommendationCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CountChip(
          label: 'Anomalies',
          count: anomalyCount,
          color: AppColors.budgetWarning,
        ),
        SizedBox(width: AppDimensions.paddingS),
        _CountChip(
          label: 'Trends',
          count: trendCount,
          color: AppColors.transfer,
        ),
        SizedBox(width: AppDimensions.paddingS),
        _CountChip(
          label: 'Tips',
          count: recommendationCount,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _PillTabBar extends StatelessWidget {
  const _PillTabBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _tabs = ['All', 'Anomalies', 'Trends', 'Tips'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: AppDimensions.paddingS),
            child: ChoiceChip(
              label: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : null,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              onSelected: (_) => onSelected(index),
            ),
          );
        }),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.tabIndex});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final messages = [
      'No insights yet. Keep tracking your expenses to generate analysis.',
      'No anomalies detected. Your spending looks consistent.',
      'No trend data available yet. Add more transactions for trend analysis.',
      'No recommendations right now. Great job managing your finances!',
    ];

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              icon: HugeIcons.strokeRoundedIdea01,
              size: 48.w,
              color: AppColors.disabled,
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
              ),
              child: Text(
                messages[tabIndex],
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
