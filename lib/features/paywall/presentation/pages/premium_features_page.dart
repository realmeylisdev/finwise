import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/services/subscription_service.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/paywall/presentation/widgets/premium_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PremiumFeaturesPage extends StatelessWidget {
  const PremiumFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient app bar
          SliverAppBar(
            expandedHeight: 180.h,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.paddingM,
                      60.h,
                      AppDimensions.paddingM,
                      AppDimensions.paddingM,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Features',
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Powerful tools to master your finances',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text(
                'Premium Features',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Premium features
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingL,
                AppDimensions.paddingM,
                AppDimensions.paddingS,
              ),
              child: Text(
                'Premium',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _premiumFeatures
                    .map((f) => _FeatureShowcaseCard(
                          feature: f,
                          isDark: isDark,
                        ))
                    .toList(),
              ),
            ),
          ),

          // Pro features
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingL,
                AppDimensions.paddingM,
                AppDimensions.paddingS,
              ),
              child: Text(
                'Pro',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _proFeatures
                    .map((f) => _FeatureShowcaseCard(
                          feature: f,
                          isDark: isDark,
                        ))
                    .toList(),
              ),
            ),
          ),

          // CTA button
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.paywall),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                  ),
                  child: Text(
                    'Upgrade Now',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Feature data
// --------------------------------------------------------------------------
class _FeatureInfo {
  const _FeatureInfo({
    required this.icon,
    required this.title,
    required this.description,
    required this.tier,
    required this.gradientColors,
  });

  final IconData icon;
  final String title;
  final String description;
  final SubscriptionTier tier;
  final List<Color> gradientColors;
}

const _premiumFeatures = [
  _FeatureInfo(
    icon: Icons.auto_awesome_rounded,
    title: 'AI-Powered Insights',
    description:
        'Get personalized spending analysis and smart recommendations '
        'powered by artificial intelligence.',
    tier: SubscriptionTier.premium,
    gradientColors: [Color(0xFF6366F1), Color(0xFF818CF8)],
  ),
  _FeatureInfo(
    icon: Icons.all_inclusive_rounded,
    title: 'Unlimited Budgets & Goals',
    description:
        'Create as many budgets and savings goals as you need. '
        'No limits, no compromises.',
    tier: SubscriptionTier.premium,
    gradientColors: [Color(0xFF22C55E), Color(0xFF4ADE80)],
  ),
  _FeatureInfo(
    icon: Icons.account_balance_rounded,
    title: 'Net Worth Tracking',
    description:
        'Track all your assets and liabilities in one place. '
        'Watch your net worth grow over time.',
    tier: SubscriptionTier.premium,
    gradientColors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
  ),
  _FeatureInfo(
    icon: Icons.trending_up_rounded,
    title: 'Cash Flow Forecast',
    description:
        '30-day balance projection based on your spending patterns '
        'and upcoming bills.',
    tier: SubscriptionTier.premium,
    gradientColors: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
  ),
  _FeatureInfo(
    icon: Icons.picture_as_pdf_rounded,
    title: 'Monthly & Annual Reports',
    description:
        'Generate detailed PDF reports of your finances. '
        'Perfect for tax season or personal review.',
    tier: SubscriptionTier.premium,
    gradientColors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
  ),
  _FeatureInfo(
    icon: Icons.visibility_off_rounded,
    title: 'Privacy Mode',
    description:
        'Instantly hide all balances and amounts with a single tap. '
        'Great for using the app in public.',
    tier: SubscriptionTier.premium,
    gradientColors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
  ),
  _FeatureInfo(
    icon: Icons.repeat_rounded,
    title: 'Subscription Tracking',
    description:
        'Keep track of all your recurring subscriptions and see '
        'how much you spend each month.',
    tier: SubscriptionTier.premium,
    gradientColors: [Color(0xFFEC4899), Color(0xFFF472B6)],
  ),
];

const _proFeatures = [
  _FeatureInfo(
    icon: Icons.credit_card_off_rounded,
    title: 'Debt Payoff Planner',
    description:
        'Snowball and avalanche strategies to pay off your debts faster '
        'and save on interest.',
    tier: SubscriptionTier.pro,
    gradientColors: [Color(0xFFEF4444), Color(0xFFF87171)],
  ),
  _FeatureInfo(
    icon: Icons.show_chart_rounded,
    title: 'Investment Portfolio',
    description:
        'Track your investments, monitor performance, and see your '
        'complete financial picture.',
    tier: SubscriptionTier.pro,
    gradientColors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
  ),
  _FeatureInfo(
    icon: Icons.people_alt_rounded,
    title: 'Shared Family Budgets',
    description:
        'Create shared budgets with family members and track spending '
        'together as a household.',
    tier: SubscriptionTier.pro,
    gradientColors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
  ),
  _FeatureInfo(
    icon: Icons.currency_exchange_rounded,
    title: 'Multi-Currency Support',
    description:
        'Manage finances across multiple currencies with automatic '
        'exchange rate conversions.',
    tier: SubscriptionTier.pro,
    gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
  ),
];

// --------------------------------------------------------------------------
// Feature Card Widget
// --------------------------------------------------------------------------
class _FeatureShowcaseCard extends StatelessWidget {
  const _FeatureShowcaseCard({
    required this.feature,
    required this.isDark,
  });

  final _FeatureInfo feature;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingS),
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: isDark ? Colors.transparent : AppColors.divider,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: feature.gradientColors,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              feature.icon,
              color: Colors.white,
              size: 24.w,
            ),
          ),
          SizedBox(width: AppDimensions.paddingM),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        feature.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    PremiumBadge(tier: feature.tier, small: true),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  feature.description,
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
          ),
        ],
      ),
    );
  }
}
