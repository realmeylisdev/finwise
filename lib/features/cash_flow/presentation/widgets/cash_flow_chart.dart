import 'dart:math' as math;

import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/cash_flow/domain/entities/cash_flow_projection_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CashFlowChart extends StatelessWidget {
  const CashFlowChart({required this.projections, super.key});

  final List<DailyProjection> projections;

  @override
  Widget build(BuildContext context) {
    if (projections.isEmpty) {
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
              Icon(
                Icons.timeline,
                size: 40.w,
                color: AppColors.disabled,
              ),
              SizedBox(height: AppDimensions.paddingS),
              Text(
                'No forecast data',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.disabled,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final spots = projections
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.projectedBalance))
        .toList();

    final minY = spots.map((s) => s.y).reduce(math.min);
    final maxY = spots.map((s) => s.y).reduce(math.max);
    final yPadding = ((maxY - minY) * 0.1).clamp(100, double.infinity);
    final chartMinY =
        minY < 0 ? minY - yPadding : math.min(0.0, minY - yPadding);
    final chartMaxY = maxY + yPadding;

    final currencyFormat = NumberFormat.compactCurrency(symbol: '\$');
    final dateFormat = DateFormat('MMM d');

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
          minY: chartMinY,
          maxY: chartMaxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(chartMinY, chartMaxY),
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 0,
                color: AppColors.expense.withValues(alpha: 0.6),
                strokeWidth: 1.5,
                dashArray: [8, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 4.w, bottom: 2.h),
                  style: TextStyle(
                    color: AppColors.expense,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  labelResolver: (_) => '\$0',
                ),
              ),
            ],
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
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
                interval: _bottomInterval(projections.length),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= projections.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      dateFormat.format(projections[index].date),
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
                  final date = index >= 0 && index < projections.length
                      ? DateFormat('MMM d, yyyy')
                          .format(projections[index].date)
                      : '';
                  final balance = spot.y;
                  final balanceColor =
                      balance >= 0 ? AppColors.income : AppColors.expense;
                  return LineTooltipItem(
                    '$date\n',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      fontSize: 11.sp,
                    ),
                    children: [
                      TextSpan(
                        text: NumberFormat.currency(symbol: '\$')
                            .format(balance),
                        style: TextStyle(
                          color: balanceColor,
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
              color: AppColors.primary,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                applyCutOffY: true,
                cutOffY: 0,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
            // Red fill below $0
            if (spots.any((s) => s.y < 0))
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: Colors.transparent,
                barWidth: 0,
                dotData: const FlDotData(show: false),
                aboveBarData: BarAreaData(
                  show: true,
                  applyCutOffY: true,
                  cutOffY: 0,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.expense.withValues(alpha: 0.05),
                      AppColors.expense.withValues(alpha: 0.3),
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
