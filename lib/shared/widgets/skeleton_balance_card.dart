import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Skeleton that mimics the gradient `_BalanceCard` on the dashboard.
class SkeletonBalanceCard extends StatelessWidget {
  const SkeletonBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF312E81).withValues(alpha: 0.6),
                  const Color(0xFF4338CA).withValues(alpha: 0.6),
                ]
              : [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primaryLight.withValues(alpha: 0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ShimmerLoading(
        child: Column(
          children: [
            // "Total Balance" label
            ShimmerBox(width: 90.w, height: 12.h, borderRadius: 4),
            SizedBox(height: 10.h),
            // Balance amount
            ShimmerBox(width: 180.w, height: 36.h, borderRadius: 8),
            SizedBox(height: 20.h),
            // Income / Expense row
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShimmerCircle(size: 28.w),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(
                              width: 40.w,
                              height: 10.h,
                              borderRadius: 3,
                            ),
                            SizedBox(height: 4.h),
                            ShimmerBox(
                              width: 60.w,
                              height: 14.h,
                              borderRadius: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32.h,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShimmerCircle(size: 28.w),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(
                              width: 40.w,
                              height: 10.h,
                              borderRadius: 3,
                            ),
                            SizedBox(height: 4.h),
                            ShimmerBox(
                              width: 60.w,
                              height: 14.h,
                              borderRadius: 4,
                            ),
                          ],
                        ),
                      ],
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
