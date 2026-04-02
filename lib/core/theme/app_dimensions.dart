import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppDimensions {
  // Padding
  static double get paddingXS => 4.w;
  static double get paddingS => 8.w;
  static double get paddingM => 16.w;
  static double get paddingL => 24.w;
  static double get paddingXL => 32.w;

  // Border Radius
  static double get radiusS => 8.r;
  static double get radiusM => 12.r;
  static double get radiusL => 16.r;
  static double get radiusXL => 24.r;
  static double get radiusFull => 999.r;

  // Icon sizes
  static double get iconS => 16.w;
  static double get iconM => 24.w;
  static double get iconL => 32.w;
  static double get iconXL => 48.w;

  // Card
  static double get cardElevation => 0;
  static double get cardRadius => 16.r;
}
