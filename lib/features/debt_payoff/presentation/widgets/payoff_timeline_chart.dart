import 'dart:math' as math;

import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/debt_payoff/domain/entities/payoff_plan_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PayoffTimelineChart extends StatelessWidget {
  const PayoffTimelineChart({required this.plan, super.key});

  final PayoffPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    if (plan.monthlyPlan.isEmpty) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timeline, size: 40.w, color: AppColors.disabled),
              SizedBox(height: AppDimensions.paddingS),
              Text(
                'No plan data',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.disabled,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Build monthly total remaining balance spots
    final spots = <FlSpot>[];
    final monthLabels = <int, String>{};
    var currentMonth = -1;
    var monthIndex = 0;

    for (final item in plan.monthlyPlan) {
      final monthKey = item.year * 12 + item.month;
      if (monthKey != currentMonth) {
        // Sum remaining balances across all debts for this month
        final monthItems = plan.monthlyPlan.where(
          (i) => i.year * 12 + i.month == monthKey,
        );
        final totalRemaining =
            monthItems.fold<double>(0, (s, i) => s + i.remainingBalance);
        spots.add(FlSpot(monthIndex.toDouble(), totalRemaining));

        final date = DateTime(item.year, item.month);
        monthLabels[monthIndex] = DateFormat('MMM').format(date);
        if (item.month == 1) {
          monthLabels[monthIndex] =
              "${DateFormat('MMM').format(date)} '${DateFormat('yy').format(date)}";
        }

        currentMonth = monthKey;
        monthIndex++;
      }
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    final maxY = spots.map((s) => s.y).reduce(math.max);
    final yPadding = (maxY * 0.1).clamp(100, double.infinity);
    final chartMaxY = maxY + yPadding;

    final currencyFormat = NumberFormat.compactCurrency(symbol: '\$');

    return Container(
      height: 240.h,
      padding: EdgeInsets.only(
        left: AppDimensions.paddingS,
        right: AppDimensions.paddingM,
        top: AppDimensions.paddingM,
        bottom: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: chartMaxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(0, chartMaxY),
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 55.w,
                getTitlesWidget: (value, meta) {
                  if (value == meta.min || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Text(
                      currencyFormat.format(value),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.h,
                interval: _bottomInterval(spots.length),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (!monthLabels.containsKey(index)) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      monthLabels[index]!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  Theme.of(context).colorScheme.inverseSurface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  final label = monthLabels[index] ?? '';
                  return LineTooltipItem(
                    '$label\n',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      fontSize: 11.sp,
                    ),
                    children: [
                      TextSpan(
                        text: NumberFormat.currency(symbol: '\$')
                            .format(spot.y),
                        style: TextStyle(
                          color: AppColors.expense,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppColors.expense,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.expense.withValues(alpha: 0.3),
                    AppColors.expense.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  double _calculateInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range == 0) return 1;
    return range / 4;
  }

  double _bottomInterval(int count) {
    if (count <= 7) return 1;
    return (count / 5).ceilToDouble();
  }
}
