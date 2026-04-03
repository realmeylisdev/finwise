import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/debt_payoff/domain/entities/payoff_plan_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class StrategyComparisonWidget extends StatelessWidget {
  const StrategyComparisonWidget({
    required this.snowball,
    required this.avalanche,
    super.key,
  });

  final PayoffPlanEntity snowball;
  final PayoffPlanEntity avalanche;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final interestDiff =
        (snowball.totalInterestPaid - avalanche.totalInterestPaid).abs();
    final avalancheSavesMore =
        avalanche.totalInterestPaid < snowball.totalInterestPaid;
    final monthDiff = (snowball.totalMonths - avalanche.totalMonths).abs();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strategy Comparison',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Headers
            Row(
              children: [
                SizedBox(width: 90.w),
                Expanded(
                  child: Center(
                    child: Text(
                      'Snowball',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.transfer,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Avalanche',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.income,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingS),

            _ComparisonRow(
              label: 'Months',
              snowballValue: '${snowball.totalMonths}',
              avalancheValue: '${avalanche.totalMonths}',
              snowballBetter: snowball.totalMonths < avalanche.totalMonths,
              avalancheBetter: avalanche.totalMonths < snowball.totalMonths,
            ),
            const Divider(height: 1),
            _ComparisonRow(
              label: 'Interest',
              snowballValue: currencyFormat.format(snowball.totalInterestPaid),
              avalancheValue:
                  currencyFormat.format(avalanche.totalInterestPaid),
              snowballBetter:
                  snowball.totalInterestPaid < avalanche.totalInterestPaid,
              avalancheBetter:
                  avalanche.totalInterestPaid < snowball.totalInterestPaid,
            ),
            const Divider(height: 1),
            _ComparisonRow(
              label: 'Total Paid',
              snowballValue: currencyFormat.format(snowball.totalPaid),
              avalancheValue: currencyFormat.format(avalanche.totalPaid),
              snowballBetter: snowball.totalPaid < avalanche.totalPaid,
              avalancheBetter: avalanche.totalPaid < snowball.totalPaid,
            ),

            SizedBox(height: AppDimensions.paddingM),

            // Insight card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: AppColors.income.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18.w,
                    color: AppColors.income,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      avalancheSavesMore
                          ? 'Avalanche saves ${currencyFormat.format(interestDiff)} in interest${monthDiff > 0 ? ' and $monthDiff months' : ''}.'
                          : interestDiff < 1
                              ? 'Both strategies are similar. Snowball gives quicker wins!'
                              : 'Snowball saves ${currencyFormat.format(interestDiff)} in interest.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.income,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.snowballValue,
    required this.avalancheValue,
    required this.snowballBetter,
    required this.avalancheBetter,
  });

  final String label;
  final String snowballValue;
  final String avalancheValue;
  final bool snowballBetter;
  final bool avalancheBetter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                snowballValue,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight:
                      snowballBetter ? FontWeight.w700 : FontWeight.w400,
                  color: snowballBetter
                      ? AppColors.income
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                avalancheValue,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight:
                      avalancheBetter ? FontWeight.w700 : FontWeight.w400,
                  color: avalancheBetter
                      ? AppColors.income
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
