import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Skeleton that mimics a generic Card with a title line and 2-3 body lines.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({this.height, super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: height,
        padding: EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLine(width: 140.w, height: 16.h),
            SizedBox(height: 12.h),
            const ShimmerLine(height: 12),
            SizedBox(height: 8.h),
            ShimmerLine(width: 200.w, height: 12),
          ],
        ),
      ),
    );
  }
}
