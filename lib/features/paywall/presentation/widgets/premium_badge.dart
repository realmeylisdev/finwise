import 'package:finwise/core/services/subscription_service.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({
    required this.tier,
    this.small = false,
    super.key,
  });

  final SubscriptionTier tier;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final isPro = tier == SubscriptionTier.pro;
    final label = isPro ? 'PRO' : 'PREMIUM';

    final gradient = isPro
        ? const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          )
        : const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6.w : 8.w,
        vertical: small ? 2.h : 3.h,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(small ? 4.r : 6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 9.sp : 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
