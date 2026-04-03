import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/recurring_detection/domain/entities/recurring_pattern_entity.dart';
import 'package:finwise/features/recurring_detection/presentation/bloc/recurring_detection_bloc.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RecurringPatternsPage extends StatelessWidget {
  const RecurringPatternsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recurring Transactions')),
      body: BlocBuilder<RecurringDetectionBloc, RecurringDetectionState>(
        builder: (context, state) {
          if (state.status == RecurringDetectionStatus.loading) {
            return const SkeletonListTileGroup(count: 4);
          }

          if (state.status == RecurringDetectionStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.w,
                    color: AppColors.expense,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    state.failureMessage ?? 'Something went wrong',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (state.patterns.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.repeat_rounded,
                    size: 64.w,
                    color: AppColors.disabled,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'No recurring patterns detected',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  Text(
                    'Patterns appear after 3+ similar transactions',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.disabled,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            itemCount: state.patterns.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppDimensions.paddingS),
            itemBuilder: (context, index) {
              final pattern = state.patterns[index];
              return _PatternCard(pattern: pattern);
            },
          );
        },
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({required this.pattern});

  final RecurringPatternEntity pattern;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            // Category icon
            if (pattern.categoryIcon != null && pattern.categoryColor != null)
              CategoryIconWidget(
                iconName: pattern.categoryIcon!,
                color: pattern.categoryColor!,
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.disabled.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(Icons.category, color: AppColors.disabled),
              ),

            SizedBox(width: AppDimensions.paddingM),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pattern.categoryName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      _FrequencyBadge(frequency: pattern.frequency),
                      SizedBox(width: AppDimensions.paddingS),
                      Text(
                        '${pattern.occurrences}x',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (pattern.nextExpectedDate != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Next: ${DateFormat.MMMd().format(pattern.nextExpectedDate!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Amount
            Text(
              '\$${pattern.amount.toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.expense,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyBadge extends StatelessWidget {
  const _FrequencyBadge({required this.frequency});

  final RecurringFrequency frequency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String get _label {
    switch (frequency) {
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.biweekly:
        return 'Biweekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.quarterly:
        return 'Quarterly';
      case RecurringFrequency.yearly:
        return 'Yearly';
      case RecurringFrequency.unknown:
        return 'Unknown';
    }
  }
}
