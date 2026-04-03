import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Skeleton that mimics a [ListTile] with leading circle, two text lines,
/// and an optional trailing element.
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({this.showTrailing = true, super.key});

  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: 12.h,
        ),
        child: Row(
          children: [
            ShimmerCircle(size: 40.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLine(width: 120.w, height: 14.h),
                  SizedBox(height: 6.h),
                  ShimmerLine(width: 80.w, height: 10.h),
                ],
              ),
            ),
            if (showTrailing)
              ShimmerBox(width: 60.w, height: 14.h, borderRadius: 4),
          ],
        ),
      ),
    );
  }
}

/// A column of [count] skeleton list tiles.
class SkeletonListTileGroup extends StatelessWidget {
  const SkeletonListTileGroup({this.count = 5, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (_) => const SkeletonListTile()),
    );
  }
}
