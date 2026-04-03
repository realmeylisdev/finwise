import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/ai_insights/domain/entities/ai_insight_entity.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({required this.insight, super.key});

  final AiInsightEntity insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = _severityColor(insight.severity);
    final iconData = _categoryIcon(insight.category);
    final iconColor = _categoryColor(insight.category);

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored left border
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusM),
                  bottomLeft: Radius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: AppIcon(
                        icon: iconData,
                        size: 18.w,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            insight.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (insight.amount != null ||
                              insight.percentChange != null ||
                              insight.categoryName != null) ...[
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 6.w,
                              runSpacing: 4.h,
                              children: [
                                if (insight.amount != null)
                                  _MetricChip(
                                    label:
                                        '\$${insight.amount!.toStringAsFixed(0)}',
                                    color: borderColor,
                                  ),
                                if (insight.percentChange != null)
                                  _MetricChip(
                                    label:
                                        '${insight.percentChange! >= 0 ? '+' : ''}${insight.percentChange!.toStringAsFixed(0)}%',
                                    color: insight.percentChange! >= 0
                                        ? AppColors.expense
                                        : AppColors.income,
                                  ),
                                if (insight.categoryName != null)
                                  _MetricChip(
                                    label: insight.categoryName!,
                                    color: AppColors.primary,
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _severityColor(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.positive:
        return AppColors.income;
      case InsightSeverity.warning:
        return AppColors.budgetWarning;
      case InsightSeverity.info:
        return AppColors.transfer;
    }
  }

  List<List<dynamic>> _categoryIcon(InsightCategory category) {
    switch (category) {
      case InsightCategory.anomaly:
        return HugeIcons.strokeRoundedAlert02;
      case InsightCategory.trend:
        return HugeIcons.strokeRoundedChartLineData01;
      case InsightCategory.recommendation:
        return HugeIcons.strokeRoundedIdea01;
      case InsightCategory.forecast:
        return HugeIcons.strokeRoundedCalendar03;
    }
  }

  Color _categoryColor(InsightCategory category) {
    switch (category) {
      case InsightCategory.anomaly:
        return AppColors.budgetWarning;
      case InsightCategory.trend:
        return AppColors.transfer;
      case InsightCategory.recommendation:
        return AppColors.primary;
      case InsightCategory.forecast:
        return Colors.purple;
    }
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 3.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
