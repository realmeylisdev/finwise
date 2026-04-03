import 'package:finwise/core/di/injection.dart';
import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/services/feature_gate.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FeatureGateWrapper extends StatelessWidget {
  const FeatureGateWrapper({
    required this.feature,
    required this.child,
    super.key,
  });

  final Feature feature;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gate = getIt<FeatureGate>();
    if (gate.canAccess(feature)) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.paywall),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: AbsorbPointer(child: child),
          ),
          Positioned(
            right: AppDimensions.paddingM,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14.w,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'PRO',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
