import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    required this.percent,
    this.height = 8,
    super.key,
  });

  final double percent;
  final double height;

  Color get _color {
    if (percent > 1.0) return AppColors.budgetDanger;
    if (percent > 0.7) return AppColors.budgetWarning;
    return AppColors.budgetSafe;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percent.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        ),
      ),
    );
  }
}
