import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/net_worth/domain/entities/net_worth_snapshot_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NetWorthChart extends StatelessWidget {
  const NetWorthChart({required this.snapshots, super.key});

  final List<NetWorthSnapshotEntity> snapshots;

  @override
  Widget build(BuildContext context) {
    if (snapshots.isEmpty) {
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
                'No snapshots yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.disabled,
                    ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Take a snapshot to start tracking',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.disabled,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final spots = snapshots
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.netWorth))
        .toList();

    final currencyFormat = NumberFormat.compactCurrency(symbol: '\$');
    final dateFormat = DateFormat('MMM d');

    return Container(
      height: 220.h,
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
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(spots),
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
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
                reservedSize: 50.w,
                getTitlesWidget: (value, meta) {
                  if (value == meta.min || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    currencyFormat.format(value),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.h,
                interval: _bottomInterval(snapshots.length),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= snapshots.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      dateFormat.format(snapshots[index].date),
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
                  final date = index >= 0 && index < snapshots.length
                      ? DateFormat('MMM d, yyyy')
                          .format(snapshots[index].date)
                      : '';
                  return LineTooltipItem(
                    '$date\n',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      fontSize: 11.sp,
                    ),
                    children: [
                      TextSpan(
                        text: currencyFormat.format(spot.y),
                        style: TextStyle(
                          color: AppColors.primary,
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
              dotData: FlDotData(
                show: snapshots.length <= 12,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: AppColors.primary,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.0),
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

  double _calculateInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    final values = spots.map((s) => s.y);
    final range = values.reduce((a, b) => a > b ? a : b) -
        values.reduce((a, b) => a < b ? a : b);
    if (range == 0) return 1;
    return range / 4;
  }

  double _bottomInterval(int count) {
    if (count <= 6) return 1;
    return (count / 5).ceilToDouble();
  }
}
