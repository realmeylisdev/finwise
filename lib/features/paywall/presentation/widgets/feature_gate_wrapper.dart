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
          Positioned.fill(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark.withValues(alpha: 0.9)
                      : AppColors.surfaceLight.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: AppDimensions.iconL,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Upgrade to unlock',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
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
