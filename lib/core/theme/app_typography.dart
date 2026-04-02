import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  static TextTheme get textTheme =>
      GoogleFonts.plusJakartaSansTextTheme(
        TextTheme(
          displayLarge: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineLarge: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
