import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllocationChart extends StatelessWidget {
  const AllocationChart({required this.allocationByType, super.key});

  final Map<InvestmentType, double> allocationByType;

  static const _typeColors = <InvestmentType, Color>{
    InvestmentType.stock: AppColors.primary,
    InvestmentType.etf: AppColors.income,
    InvestmentType.mutualFund: AppColors.transfer,
    InvestmentType.crypto: Color(0xFFF59E0B),
    InvestmentType.bond: Color(0xFF8B5CF6),
    InvestmentType.other: AppColors.disabled,
  };

  @override
  Widget build(BuildContext context) {
    if (allocationByType.isEmpty) {
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
                Icons.pie_chart_outline,
                size: 40.w,
                color: AppColors.disabled,
              ),
              SizedBox(height: AppDimensions.paddingS),
              Text(
                'No investments yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.disabled,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final total =
        allocationByType.values.fold<double>(0, (sum, v) => sum + v);

    final sections = allocationByType.entries.map((entry) {
      final percent = total > 0 ? (entry.value / total * 100) : 0.0;
      final color = _typeColors[entry.key] ?? AppColors.disabled;
      return PieChartSectionData(
        value: entry.value,
        color: color,
        radius: 28.w,
        title: '${percent.toStringAsFixed(0)}%',
        titleStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.55,
      );
    }).toList();

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180.h,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40.w,
                sectionsSpace: 2,
                startDegreeOffset: -90,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Wrap(
            spacing: AppDimensions.paddingM,
            runSpacing: AppDimensions.paddingS,
            children: allocationByType.entries.map((entry) {
              final color = _typeColors[entry.key] ?? AppColors.disabled;
              return _LegendItem(
                color: color,
                label: InvestmentEntity.typeDisplayName(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
