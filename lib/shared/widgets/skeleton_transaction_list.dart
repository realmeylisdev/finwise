import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Skeleton mimicking a date-grouped transaction list with a header and items.
class SkeletonTransactionList extends StatelessWidget {
  const SkeletonTransactionList({this.itemCount = 5, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: 8.h,
            ),
            child: ShimmerBox(width: 100.w, height: 12.h, borderRadius: 4),
          ),
          // Transaction items
          ...List.generate(itemCount, (_) => _SkeletonTxnItem()),
        ],
      ),
    );
  }
}

class _SkeletonTxnItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: 10.h,
      ),
      child: Row(
        children: [
          // Category icon placeholder
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 12.w),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 110.w, height: 14.h, borderRadius: 4),
                SizedBox(height: 6.h),
                ShimmerBox(width: 70.w, height: 10.h, borderRadius: 3),
              ],
            ),
          ),
          // Amount + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerBox(width: 56.w, height: 14.h, borderRadius: 4),
              SizedBox(height: 6.h),
              ShimmerBox(width: 40.w, height: 10.h, borderRadius: 3),
            ],
          ),
        ],
      ),
    );
  }
}
