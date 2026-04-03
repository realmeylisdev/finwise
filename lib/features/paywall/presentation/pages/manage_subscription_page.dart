import 'package:finwise/core/di/injection.dart';
import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/services/subscription_service.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/paywall/presentation/widgets/premium_badge.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ManageSubscriptionPage extends StatelessWidget {
  const ManageSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final service = getIt<SubscriptionService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Subscription')),
      body: ListenableBuilder(
        listenable: service,
        builder: (context, _) {
          final tier = service.currentTier;

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Current plan card
              _CurrentPlanCard(tier: tier, isDark: isDark),
              SizedBox(height: AppDimensions.paddingL),

              // Plan details
              if (tier != SubscriptionTier.free) ...[
                _PlanDetailsCard(tier: tier, isDark: isDark),
                SizedBox(height: AppDimensions.paddingL),
              ],

              // Actions
              _ActionsSection(tier: tier, isDark: isDark),
              SizedBox(height: AppDimensions.paddingL),

              // Info
              if (tier != SubscriptionTier.free) ...[
                _CancelInfoSection(isDark: isDark),
              ],
            ],
          );
        },
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Current Plan Card
// --------------------------------------------------------------------------
class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({required this.tier, required this.isDark});
  final SubscriptionTier tier;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final gradient = _gradientForTier(tier);
    final tierName = _tierName(tier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            tier == SubscriptionTier.free
                ? Icons.person_outline_rounded
                : Icons.workspace_premium_rounded,
            color: Colors.white,
            size: 48.w,
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            tierName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            tier == SubscriptionTier.free
                ? 'Basic features included'
                : 'Full access to ${tierName.toLowerCase()} features',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _gradientForTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return const LinearGradient(
          colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
        );
      case SubscriptionTier.premium:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        );
      case SubscriptionTier.pro:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        );
    }
  }

  String _tierName(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return 'Free Plan';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.pro:
        return 'Pro';
    }
  }
}

// --------------------------------------------------------------------------
// Plan Details
// --------------------------------------------------------------------------
class _PlanDetailsCard extends StatelessWidget {
  const _PlanDetailsCard({required this.tier, required this.isDark});
  final SubscriptionTier tier;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isPro = tier == SubscriptionTier.pro;
    final monthlyPrice =
        isPro ? SubscriptionService.proMonthlyPrice : SubscriptionService.premiumMonthlyPrice;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            _DetailRow(
              label: 'Plan',
              value: isPro ? 'Pro' : 'Premium',
              isDark: isDark,
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Price',
              value: '\$${monthlyPrice.toStringAsFixed(2)}/month',
              isDark: isDark,
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Renewal Date',
              value: 'N/A (Development mode)',
              isDark: isDark,
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Status',
              value: 'Active',
              isDark: isDark,
              valueColor: AppColors.income,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ??
                (isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// Actions
// --------------------------------------------------------------------------
class _ActionsSection extends StatelessWidget {
  const _ActionsSection({required this.tier, required this.isDark});
  final SubscriptionTier tier;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (tier == SubscriptionTier.free) ...[
            ListTile(
              leading: const AppIcon(
                icon: HugeIcons.strokeRoundedStars,
                color: AppColors.primary,
              ),
              title: const Text('View Premium Features'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.premiumFeatures),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              title: const Text('Upgrade'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PremiumBadge(tier: SubscriptionTier.premium, small: true),
                  SizedBox(width: 8.w),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => context.push(AppRoutes.paywall),
            ),
          ] else ...[
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              title: const Text('Change Plan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.paywall),
            ),
          ],
          const Divider(height: 1),
          ListTile(
            leading: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Icon(
                Icons.restore_rounded,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                size: 24,
              ),
            ),
            title: const Text('Restore Purchases'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              getIt<SubscriptionService>().restorePurchases();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No purchases to restore (development mode)'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Cancel Info
// --------------------------------------------------------------------------
class _CancelInfoSection extends StatelessWidget {
  const _CancelInfoSection({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.5)
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 24.w,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            'To cancel your subscription, go to your device\'s '
            'App Store or Play Store subscription settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
