import 'package:finwise/core/di/injection.dart';
import 'package:finwise/core/services/subscription_service.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/paywall/presentation/bloc/paywall_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PaywallBloc>()..add(const PaywallLoaded()),
      child: const _PaywallView(),
    );
  }
}

class _PaywallView extends StatelessWidget {
  const _PaywallView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<PaywallBloc, PaywallState>(
      listener: (context, state) {
        if (state.status == PaywallStatus.purchased) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Welcome to FinWise ${state.currentTier == SubscriptionTier.pro ? "Pro" : "Premium"}!',
              ),
              backgroundColor: AppColors.income,
            ),
          );
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Gradient header
              SliverToBoxAdapter(
                child: _GradientHeader(state: state),
              ),

              // Billing cycle toggle
              SliverToBoxAdapter(
                child: _BillingToggle(state: state),
              ),

              // Tier cards
              SliverToBoxAdapter(
                child: _TierCards(state: state, isDark: isDark),
              ),

              // Feature comparison
              SliverToBoxAdapter(
                child: _FeatureComparison(isDark: isDark),
              ),

              // Restore purchases
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingL,
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () => context
                          .read<PaywallBloc>()
                          .add(const PaywallRestoreRequested()),
                      child: Text(
                        'Restore Purchases',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------------------
// Gradient Header
// --------------------------------------------------------------------------
class _GradientHeader extends StatelessWidget {
  const _GradientHeader({required this.state});
  final PaywallState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppDimensions.paddingM,
        bottom: AppDimensions.paddingL,
        left: AppDimensions.paddingM,
        right: AppDimensions.paddingM,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFFA855F7),
          ],
        ),
      ),
      child: Column(
        children: [
          // Back button row
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.paddingM),
          // Crown icon
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 40.w,
            ),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            'Unlock FinWise Premium',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            'Get full access to all features and take\ncontrol of your finances',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Billing Cycle Toggle
// --------------------------------------------------------------------------
class _BillingToggle extends StatelessWidget {
  const _BillingToggle({required this.state});
  final PaywallState state;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingL,
        AppDimensions.paddingM,
        AppDimensions.paddingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CycleChip(
            label: 'Monthly',
            isSelected: !state.isAnnual,
            isDark: isDark,
            onTap: () {
              if (state.isAnnual) {
                context
                    .read<PaywallBloc>()
                    .add(const PaywallBillingCycleToggled());
              }
            },
          ),
          SizedBox(width: AppDimensions.paddingS),
          _CycleChip(
            label: 'Annual',
            isSelected: state.isAnnual,
            isDark: isDark,
            badge: 'Save 37%',
            onTap: () {
              if (!state.isAnnual) {
                context
                    .read<PaywallBloc>()
                    .add(const PaywallBillingCycleToggled());
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CycleChip extends StatelessWidget {
  const _CycleChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    this.badge,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isDark
                  ? AppColors.surfaceDark
                  : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
            if (badge != null) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : AppColors.income.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.income,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Tier Cards
// --------------------------------------------------------------------------
class _TierCards extends StatelessWidget {
  const _TierCards({required this.state, required this.isDark});
  final PaywallState state;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Column(
        children: [
          SizedBox(height: AppDimensions.paddingS),
          // Premium card
          _PricingCard(
            tier: SubscriptionTier.premium,
            title: 'Premium',
            monthlyPrice: SubscriptionService.premiumMonthlyPrice,
            yearlyPrice: SubscriptionService.premiumYearlyPrice,
            isAnnual: state.isAnnual,
            isCurrentPlan: state.currentTier == SubscriptionTier.premium,
            isSelected: state.selectedTier == SubscriptionTier.premium,
            isDark: isDark,
            isLoading: state.status == PaywallStatus.loading,
            features: const [
              'Unlimited budgets & goals',
              'AI-powered insights',
              'Net worth tracking',
              'Cash flow forecast',
              'Monthly & annual reports',
              'Privacy mode',
              'Subscription tracking',
            ],
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            onTap: () => context
                .read<PaywallBloc>()
                .add(const PaywallTierSelected(SubscriptionTier.premium)),
            onUpgrade: () => context
                .read<PaywallBloc>()
                .add(const PaywallPurchaseRequested()),
          ),
          SizedBox(height: AppDimensions.paddingM),
          // Pro card
          _PricingCard(
            tier: SubscriptionTier.pro,
            title: 'Pro',
            monthlyPrice: SubscriptionService.proMonthlyPrice,
            yearlyPrice: SubscriptionService.proYearlyPrice,
            isAnnual: state.isAnnual,
            isCurrentPlan: state.currentTier == SubscriptionTier.pro,
            isSelected: state.selectedTier == SubscriptionTier.pro,
            isDark: isDark,
            isLoading: state.status == PaywallStatus.loading,
            features: const [
              'Everything in Premium',
              'Debt payoff planner',
              'Investment portfolio',
              'Shared family budgets',
              'Multi-currency support',
            ],
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            ),
            onTap: () => context
                .read<PaywallBloc>()
                .add(const PaywallTierSelected(SubscriptionTier.pro)),
            onUpgrade: () => context
                .read<PaywallBloc>()
                .add(const PaywallPurchaseRequested()),
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.tier,
    required this.title,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.isAnnual,
    required this.isCurrentPlan,
    required this.isSelected,
    required this.isDark,
    required this.isLoading,
    required this.features,
    required this.gradient,
    required this.onTap,
    required this.onUpgrade,
  });

  final SubscriptionTier tier;
  final String title;
  final double monthlyPrice;
  final double yearlyPrice;
  final bool isAnnual;
  final bool isCurrentPlan;
  final bool isSelected;
  final bool isDark;
  final bool isLoading;
  final List<String> features;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final price = isAnnual ? yearlyPrice / 12 : monthlyPrice;
    final borderColor = isSelected ? gradient.colors.first : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: gradient.colors.first.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isCurrentPlan) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.income.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      'Current Plan',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.income,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text(
                    '/month',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
            if (isAnnual) ...[
              SizedBox(height: 2.h),
              Text(
                'Billed \$${yearlyPrice.toStringAsFixed(2)}/year',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
            SizedBox(height: AppDimensions.paddingM),

            // Features
            ...features.map(
              (f) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18.w,
                      color: gradient.colors.first,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),

            // CTA button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: isCurrentPlan || (isLoading && isSelected)
                    ? null
                    : () {
                        if (!isSelected) {
                          onTap();
                        }
                        onUpgrade();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gradient.colors.first,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      gradient.colors.first.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                child: isLoading && isSelected
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        isCurrentPlan ? 'Current Plan' : 'Upgrade to $title',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Feature Comparison Table
// --------------------------------------------------------------------------
class _FeatureComparison extends StatelessWidget {
  const _FeatureComparison({required this.isDark});
  final bool isDark;

  static const _features = [
    _ComparisonRow('Budgets', '3', 'Unlimited', 'Unlimited'),
    _ComparisonRow('Savings goals', '2', 'Unlimited', 'Unlimited'),
    _ComparisonRow('Transaction history', '90 days', 'All', 'All'),
    _ComparisonRow('AI insights', null, true, true),
    _ComparisonRow('Net worth tracking', null, true, true),
    _ComparisonRow('Cash flow forecast', null, true, true),
    _ComparisonRow('PDF reports', null, true, true),
    _ComparisonRow('Privacy mode', null, true, true),
    _ComparisonRow('Subscription tracking', null, true, true),
    _ComparisonRow('Debt payoff planner', null, null, true),
    _ComparisonRow('Investment tracking', null, null, true),
    _ComparisonRow('Shared budgets', null, null, true),
    _ComparisonRow('Multi-currency', null, null, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.paddingS),
          Text(
            'Compare Plans',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: AppDimensions.paddingM),
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingS,
              horizontal: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusM),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Feature',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                _columnHeader('Free'),
                _columnHeader('Premium'),
                _columnHeader('Pro'),
              ],
            ),
          ),
          // Rows
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppDimensions.radiusM),
              ),
              border: Border.all(
                color: isDark ? Colors.transparent : AppColors.divider,
              ),
            ),
            child: Column(
              children: _features.asMap().entries.map((entry) {
                final idx = entry.key;
                final row = entry.value;
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: AppDimensions.paddingS,
                  ),
                  decoration: BoxDecoration(
                    border: idx < _features.length - 1
                        ? Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? AppColors.cardDark
                                  : AppColors.divider,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.label,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      _cellWidget(row.free, isDark),
                      _cellWidget(row.premium, isDark),
                      _cellWidget(row.pro, isDark),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _columnHeader(String text) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _cellWidget(Object? value, bool isDark) {
    return Expanded(
      flex: 2,
      child: Center(
        child: value == null
            ? Icon(Icons.remove_rounded,
                size: 16.w, color: AppColors.disabled)
            : value is bool && value
                ? Icon(Icons.check_circle_rounded,
                    size: 16.w, color: AppColors.income)
                : Text(
                    value.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
      ),
    );
  }
}

class _ComparisonRow {
  const _ComparisonRow(this.label, this.free, this.premium, this.pro);
  final String label;
  final Object? free;
  final Object? premium;
  final Object? pro;
}
