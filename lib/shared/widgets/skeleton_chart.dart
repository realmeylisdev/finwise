import 'package:finwise/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Skeleton that mimics a chart area (used in Analytics).
class SkeletonChart extends StatelessWidget {
  const SkeletonChart({this.height, super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: double.infinity,
        height: height ?? 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}
