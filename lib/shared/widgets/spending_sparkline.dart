import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Compact sparkline showing daily spending over time.
/// No axes, no labels — just a gradient-filled line.
class SpendingSparkline extends StatelessWidget {
  const SpendingSparkline({
    required this.data,
    this.height,
    this.lineColor,
    this.fillColor,
    super.key,
  });

  final List<double> data;
  final double? height;
  final Color? lineColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final color = lineColor ?? Colors.white.withValues(alpha: 0.8);
    final fill = fillColor ?? Colors.white.withValues(alpha: 0.1);

    return SizedBox(
      height: height ?? 40.h,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          clipData: const FlClipData.all(),
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: color,
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: fill,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
