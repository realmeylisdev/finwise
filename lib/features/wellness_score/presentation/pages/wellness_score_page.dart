import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/wellness_score/domain/entities/wellness_score_entity.dart';
import 'package:finwise/features/wellness_score/presentation/bloc/wellness_score_bloc.dart';
import 'package:finwise/features/wellness_score/presentation/widgets/wellness_score_gauge.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WellnessScorePage extends StatelessWidget {
  const WellnessScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Wellness'),
      ),
      body: BlocBuilder<WellnessScoreBloc, WellnessScoreState>(
        builder: (context, state) {
          if (state.status == WellnessScoreStatus.loading ||
              state.status == WellnessScoreStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WellnessScoreStatus.failure) {
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
                      'Could not calculate score',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () => context
                          .read<WellnessScoreBloc>()
                          .add(const WellnessScoreLoaded()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final score = state.score!;

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<WellnessScoreBloc>()
                  .add(const WellnessScoreLoaded());
            },
            child: ListView(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              children: [
                // Large gauge
                Center(
                  child: WellnessScoreGauge(score: score),
                ),

                SizedBox(height: 32.h),

                // Score breakdown
                Text(
                  'Score Breakdown',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),

                _ScoreBreakdownRow(
                  label: 'Budget',
                  score: score.budgetScore,
                  icon: HugeIcons.strokeRoundedPieChart01,
                  color: const Color(0xFF6366F1),
                ),
                SizedBox(height: 12.h),
                _ScoreBreakdownRow(
                  label: 'Savings',
                  score: score.savingsScore,
                  icon: HugeIcons.strokeRoundedSafe,
                  color: const Color(0xFF22C55E),
                ),
                SizedBox(height: 12.h),
                _ScoreBreakdownRow(
                  label: 'Debt',
                  score: score.debtScore,
                  icon: HugeIcons.strokeRoundedCreditCard,
                  color: const Color(0xFFEF4444),
                ),
                SizedBox(height: 12.h),
                _ScoreBreakdownRow(
                  label: 'Consistency',
                  score: score.consistencyScore,
                  icon: HugeIcons.strokeRoundedCalendar03,
                  color: const Color(0xFFF59E0B),
                ),

                SizedBox(height: 32.h),

                // Tips section
                Text(
                  'Tips to Improve',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),

                ..._buildTips(score, theme),

                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTips(WellnessScoreEntity score, ThemeData theme) {
    final tips = <_TipData>[];

    // Add tips based on lowest scores
    final scores = {
      'budget': score.budgetScore,
      'savings': score.savingsScore,
      'debt': score.debtScore,
      'consistency': score.consistencyScore,
    };

    final sorted = scores.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    for (final entry in sorted.take(2)) {
      switch (entry.key) {
        case 'budget':
          if (entry.value < 70) {
            tips.add(_TipData(
              title: 'Set up more budgets',
              description:
                  'Create budgets for your top spending categories to better control expenses.',
              icon: HugeIcons.strokeRoundedPieChart01,
              color: const Color(0xFF6366F1),
            ));
          }
        case 'savings':
          if (entry.value < 70) {
            tips.add(_TipData(
              title: 'Boost your savings rate',
              description:
                  'Aim to save at least 20% of your income. Start small and increase gradually.',
              icon: HugeIcons.strokeRoundedSafe,
              color: const Color(0xFF22C55E),
            ));
          }
        case 'debt':
          if (entry.value < 70) {
            tips.add(_TipData(
              title: 'Reduce debt obligations',
              description:
                  'Focus on paying down high-interest debt first to lower your debt-to-income ratio.',
              icon: HugeIcons.strokeRoundedCreditCard,
              color: const Color(0xFFEF4444),
            ));
          }
        case 'consistency':
          if (entry.value < 70) {
            tips.add(_TipData(
              title: 'Track expenses daily',
              description:
                  'Log transactions regularly for a complete picture of your finances.',
              icon: HugeIcons.strokeRoundedCalendar03,
              color: const Color(0xFFF59E0B),
            ));
          }
      }
    }

    if (tips.isEmpty) {
      tips.add(_TipData(
        title: 'Keep up the great work!',
        description:
            'Your financial health is looking strong. Continue maintaining your good habits.',
        icon: HugeIcons.strokeRoundedCheckmarkCircle02,
        color: AppColors.income,
      ));
    }

    return tips.map((tip) {
      return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: tip.color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: tip.color.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: tip.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: AppIcon(
                icon: tip.icon,
                size: 18.w,
                color: tip.color,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tip.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _TipData {
  const _TipData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final List<List<dynamic>> icon;
  final Color color;
}

class _ScoreBreakdownRow extends StatelessWidget {
  const _ScoreBreakdownRow({
    required this.label,
    required this.score,
    required this.icon,
    required this.color,
  });

  final String label;
  final int score;
  final List<List<dynamic>> icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AppIcon(icon: icon, size: 18.w, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$score/100',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _scoreColor(score),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: score / 100.0,
                    minHeight: 6.h,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _scoreColor(score),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 70) return AppColors.income;
    if (score >= 40) return AppColors.budgetWarning;
    return AppColors.expense;
  }
}
