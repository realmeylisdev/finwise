import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/shared/widgets/privacy_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SubscriptionCostSummary extends StatelessWidget {
  const SubscriptionCostSummary({
    required this.monthlyCost,
    required this.yearlyCost,
    required this.activeCount,
    super.key,
  });

  final double monthlyCost;
  final double yearlyCost;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          Text(
            'Monthly Subscriptions',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          PrivacyAmount(
            child: Text(
              currencyFormat.format(monthlyCost),
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Yearly Cost',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    PrivacyAmount(
                      child: Text(
                        currencyFormat.format(yearlyCost),
                        style: TextStyle(
                          color: AppColors.budgetWarning,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 36.h,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '$activeCount subscriptions',
                      style: TextStyle(
                        color: AppColors.income,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
