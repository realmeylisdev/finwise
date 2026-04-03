import 'dart:ui' as ui;

import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class MonthlySummaryCard extends StatefulWidget {
  const MonthlySummaryCard({
    required this.income,
    required this.expense,
    required this.transactionCount,
    super.key,
  });

  final double income;
  final double expense;
  final int transactionCount;

  @override
  State<MonthlySummaryCard> createState() => _MonthlySummaryCardState();
}

class _MonthlySummaryCardState extends State<MonthlySummaryCard> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _sharing = false;

  double get _netSavings => widget.income - widget.expense;

  String get _monthLabel {
    final now = DateTime.now();
    return DateFormat.yMMMM().format(now);
  }

  Future<void> _shareCard() async {
    setState(() => _sharing = true);

    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, mimeType: 'image/png', name: 'finwise_summary.png')],
          text: 'My $_monthLabel FinWise Summary',
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: RepaintBoundary(
        key: _repaintKey,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E293B),
                      const Color(0xFF334155),
                    ]
                  : [
                      const Color(0xFFF8FAFC),
                      const Color(0xFFEFF6FF),
                    ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Summary',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _monthLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ShareButton(
                    onTap: _sharing ? null : _shareCard,
                    isLoading: _sharing,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Stats grid
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Income',
                      value: '\$${widget.income.toStringAsFixed(2)}',
                      color: AppColors.income,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatItem(
                      label: 'Expense',
                      value: '\$${widget.expense.toStringAsFixed(2)}',
                      color: AppColors.expense,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Net Savings',
                      value:
                          '${_netSavings >= 0 ? '+' : ''}\$${_netSavings.toStringAsFixed(2)}',
                      color: _netSavings >= 0
                          ? AppColors.income
                          : AppColors.expense,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatItem(
                      label: 'Transactions',
                      value: '${widget.transactionCount}',
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Share button
// ---------------------------------------------------------------------------
class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.onTap, required this.isLoading});

  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: isLoading
            ? SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.share_rounded,
                    size: 16.w,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Share',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat item
// ---------------------------------------------------------------------------
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
