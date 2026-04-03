import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Semantic — Finance
  static const Color income = Color(0xFF22C55E);
  static const Color incomeBg = Color(0xFFDCFCE7);
  static const Color expense = Color(0xFFEF4444);
  static const Color expenseBg = Color(0xFFFEE2E2);
  static const Color transfer = Color(0xFF3B82F6);
  static const Color transferBg = Color(0xFFDBEAFE);

  // Surfaces — Light
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Surfaces — Dark
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);

  // Text — Light
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Text — Dark
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Neutrals
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFCBD5E1);
  static const Color disabled = Color(0xFF94A3B8);

  // Budget
  static const Color budgetSafe = Color(0xFF22C55E);
  static const Color budgetWarning = Color(0xFFF59E0B);
  static const Color budgetDanger = Color(0xFFEF4444);

  // Shimmer — Light
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF1F5F9);

  // Shimmer — Dark
  static const Color shimmerBaseDark = Color(0xFF334155);
  static const Color shimmerHighlightDark = Color(0xFF475569);
}
