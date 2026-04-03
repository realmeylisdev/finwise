import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/budget/presentation/widgets/budget_progress_bar.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/achievements/presentation/widgets/streak_widget.dart';
import 'package:finwise/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:finwise/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:finwise/features/notifications/presentation/widgets/notification_badge.dart';
import 'package:finwise/features/dashboard/presentation/widgets/insights_section.dart';
import 'package:finwise/features/dashboard/presentation/widgets/monthly_summary_card.dart';
import 'package:finwise/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:finwise/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:finwise/shared/widgets/skeleton_balance_card.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:finwise/shared/widgets/spending_sparkline.dart';
import 'package:finwise/features/onboarding_checklist/presentation/widgets/checklist_card.dart';
import 'package:finwise/features/wellness_score/presentation/bloc/wellness_score_bloc.dart';
import 'package:finwise/features/wellness_score/presentation/widgets/wellness_score_gauge.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.paddingM),
                    const SkeletonBalanceCard(),
                    SizedBox(height: AppDimensions.paddingL),
                    const SkeletonListTileGroup(count: 4),
                  ],
                ),
              ),
            );
          }

          final s = state.summary;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(const DashboardLoaded());
            },
            child: CustomScrollView(
              slivers: [
                // Custom header (no AppBar)
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppDimensions.paddingL,
                        AppDimensions.paddingM,
                        AppDimensions.paddingL,
                        0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _greeting,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        color: theme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'FinWise',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const StreakWidget(),
                          SizedBox(width: 8.w),
                          BlocSelector<NotificationsBloc, NotificationsState,
                              int>(
                            selector: (state) => state.unreadCount,
                            builder: (context, unreadCount) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  _HeaderButton(
                                    icon: HugeIcons
                                        .strokeRoundedNotification03,
                                    onTap: () => context
                                        .push(AppRoutes.notifications),
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(
                                      right: -4.w,
                                      top: -4.w,
                                      child: NotificationBadge(
                                          count: unreadCount),
                                    ),
                                ],
                              );
                            },
                          ),
                          SizedBox(width: 8.w),
                          BlocSelector<SettingsBloc, SettingsState, bool>(
                            selector: (state) => state.isPrivacyModeEnabled,
                            builder: (context, isPrivate) {
                              return _HeaderButton(
                                icon: isPrivate
                                    ? HugeIcons.strokeRoundedViewOff
                                    : HugeIcons.strokeRoundedView,
                                onTap: () => context
                                    .read<SettingsBloc>()
                                    .add(const SettingsPrivacyToggled()),
                              );
                            },
                          ),
                          SizedBox(width: 8.w),
                          _HeaderButton(
                            icon: HugeIcons.strokeRoundedSearch01,
                            onTap: () => context.push(AppRoutes.search),
                          ),
                          SizedBox(width: 8.w),
                          _HeaderButton(
                            icon: HugeIcons.strokeRoundedChartColumn,
                            onTap: () =>
                                context.push(AppRoutes.analytics),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Balance card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    child: _BalanceCard(
                      totalBalance: s.totalBalance,
                      income: s.totalIncome,
                      expense: s.totalExpense,
                      dailySpending: s.dailySpending,
                      isDark: isDark,
                    ),
                  ),
                ),

                // Onboarding checklist (shown if not complete and not dismissed)
                BlocBuilder<SettingsBloc, SettingsState>(
                  buildWhen: (prev, curr) =>
                      prev.isChecklistDismissed !=
                      curr.isChecklistDismissed,
                  builder: (context, settingsState) {
                    if (settingsState.isChecklistDismissed) {
                      return const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const ChecklistCard(),
                          SizedBox(height: AppDimensions.paddingL),
                        ],
                      ),
                    );
                  },
                ),

                // Compact wellness score widget
                BlocBuilder<WellnessScoreBloc, WellnessScoreState>(
                  builder: (context, wsState) {
                    if (wsState.status != WellnessScoreStatus.success ||
                        wsState.score == null) {
                      return const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: AppDimensions.paddingL,
                          right: AppDimensions.paddingL,
                          bottom: AppDimensions.paddingL,
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              context.push(AppRoutes.wellnessScore),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius:
                                  BorderRadius.circular(16.r),
                              border: Border.all(
                                color: theme
                                    .colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                WellnessScoreGauge(
                                  score: wsState.score!,
                                  compact: true,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Financial Wellness',
                                        style: theme
                                            .textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        wsState.score!.description,
                                        style: theme
                                            .textTheme.bodySmall
                                            ?.copyWith(
                                          color: theme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme
                                      .colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Quick actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _QuickAction(
                          icon: HugeIcons.strokeRoundedAdd01,
                          label: 'Add',
                          gradient: const [
                            Color(0xFF6366F1),
                            Color(0xFF818CF8),
                          ],
                          onTap: () => context.push(
                            '${AppRoutes.transactions}/new',
                          ),
                        ),
                        _QuickAction(
                          icon: HugeIcons.strokeRoundedArrowDataTransferHorizontal,
                          label: 'Transfer',
                          gradient: const [
                            Color(0xFF3B82F6),
                            Color(0xFF60A5FA),
                          ],
                          onTap: () => context.push(
                            '${AppRoutes.transactions}/new',
                          ),
                        ),
                        _QuickAction(
                          icon: HugeIcons.strokeRoundedTarget02,
                          label: 'Goals',
                          gradient: const [
                            Color(0xFF22C55E),
                            Color(0xFF4ADE80),
                          ],
                          onTap: () => context.go(AppRoutes.goals),
                        ),
                        _QuickAction(
                          icon: HugeIcons.strokeRoundedPieChart01,
                          label: 'Budgets',
                          gradient: const [
                            Color(0xFFF59E0B),
                            Color(0xFFFBBF24),
                          ],
                          onTap: () => context.go(AppRoutes.budgets),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.paddingL),
                ),

                // Monthly summary card
                SliverToBoxAdapter(
                  child: MonthlySummaryCard(
                    income: s.totalIncome,
                    expense: s.totalExpense,
                    transactionCount: s.recentTransactions.length,
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.paddingL),
                ),

                // Upcoming bills
                if (s.upcomingBills.isNotEmpty) ...[
                  _SliverSection(title: 'Upcoming Bills'),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 80.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingL,
                        ),
                        itemCount: s.upcomingBills.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          final bill = s.upcomingBills[index];
                          final today = DateTime.now().day;
                          final isDue = bill.isDueToday(today);
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDue
                                  ? AppColors.budgetWarning
                                      .withValues(alpha: 0.1)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isDue
                                    ? AppColors.budgetWarning
                                        .withValues(alpha: 0.3)
                                    : theme.colorScheme.outlineVariant
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  bill.name,
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '\$${bill.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isDue
                                        ? AppColors.budgetWarning
                                        : AppColors.expense,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  isDue ? 'Due today' : 'Day ${bill.dueDay}',
                                  style: theme.textTheme.labelSmall
                                      ?.copyWith(
                                        color: theme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.paddingL),
                  ),
                ],

                // Budget overview
                if (s.budgets.isNotEmpty) ...[
                  _SliverSection(title: 'Budget Status'),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius:
                              BorderRadius.circular(16.r),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < s.budgets.take(3).length;
                                i++) ...[
                              _BudgetRow(budget: s.budgets[i]),
                              if (i < s.budgets.take(3).length - 1)
                                Divider(
                                  height: 1,
                                  indent: 56.w,
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.paddingL),
                  ),
                ],

                // Savings goals
                if (s.activeGoals.isNotEmpty) ...[
                  _SliverSection(title: 'Savings Goals'),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 90.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingL,
                        ),
                        itemCount: s.activeGoals.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          final goal = s.activeGoals[index];
                          final color = Color(goal.color);
                          return Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color.withValues(alpha: 0.08),
                                  color.withValues(alpha: 0.02),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(14.r),
                              border: Border.all(
                                color:
                                    color.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 44.w,
                                  height: 44.w,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value:
                                            goal.percentComplete,
                                        backgroundColor: color
                                            .withValues(
                                              alpha: 0.15,
                                            ),
                                        color: color,
                                        strokeWidth: 3.5,
                                        strokeCap: StrokeCap.round,
                                      ),
                                      Text(
                                        '${(goal.percentComplete * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      goal.name,
                                      style: theme
                                          .textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      '\$${goal.savedAmount.toStringAsFixed(0)}'
                                      ' / \$${goal.targetAmount.toStringAsFixed(0)}',
                                      style: theme
                                          .textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.paddingL),
                  ),
                ],

                // Spending insights
                if (state.insights.isNotEmpty) ...[
                  _SliverSection(title: 'Insights'),
                  SliverToBoxAdapter(
                    child: InsightsSection(insights: state.insights),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.paddingL),
                  ),
                ],

                // Recent transactions
                _SliverSection(title: 'Recent Transactions'),
                if (s.recentTransactions.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 40.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius:
                              BorderRadius.circular(16.r),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            AppIcon(
                              icon: HugeIcons.strokeRoundedInvoice03,
                              size: 40.w,
                              color: theme
                                  .colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.4),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'No transactions yet',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: theme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Tap + to add your first one',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(
                                    color: theme.colorScheme
                                        .onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius:
                              BorderRadius.circular(16.r),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: s.recentTransactions
                              .map(
                                (txn) => TransactionListItem(
                                  transaction: txn,
                                  onTap: () => context.push(
                                    '${AppRoutes.transactions}/${txn.id}',
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),

                SliverToBoxAdapter(
                  child: SizedBox(height: 100.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Balance Card with gradient
// ---------------------------------------------------------------------------
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.totalBalance,
    required this.income,
    required this.expense,
    required this.dailySpending,
    required this.isDark,
  });

  final double totalBalance;
  final double income;
  final double expense;
  final List<double> dailySpending;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF312E81),
                  const Color(0xFF4338CA),
                  const Color(0xFF6366F1),
                ]
              : [
                  const Color(0xFF6366F1),
                  const Color(0xFF818CF8),
                  const Color(0xFFA5B4FC),
                ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          if (dailySpending.isNotEmpty) ...[
            SizedBox(height: 12.h),
            SpendingSparkline(data: dailySpending, height: 36.h),
          ],
          SizedBox(height: 16.h),

          // Income / Expense row
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppColors.income.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AppIcon(
                          icon: HugeIcons.strokeRoundedArrowDown01,
                          color: AppColors.income,
                          size: 14.w,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Income',
                            style: TextStyle(
                              color:
                                  Colors.white.withValues(alpha: 0.6),
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            '\$${income.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 32.h,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppColors.expense.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AppIcon(
                          icon: HugeIcons.strokeRoundedArrowUp01,
                          color: AppColors.expense,
                          size: 14.w,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expense',
                            style: TextStyle(
                              color:
                                  Colors.white.withValues(alpha: 0.6),
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            '\$${expense.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
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

// ---------------------------------------------------------------------------
// Quick Action — circular gradient button
// ---------------------------------------------------------------------------
class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  final List<List<dynamic>> icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AppIcon(icon: icon, color: Colors.white, size: 22.w),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Budget row inside container
// ---------------------------------------------------------------------------
class _BudgetRow extends StatelessWidget {
  const _BudgetRow({required this.budget});

  final dynamic budget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      child: Row(
        children: [
          CategoryIconWidget(
            iconName: budget.categoryIcon as String,
            color: budget.categoryColor as int,
            size: 36,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.categoryName as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 6.h),
                BudgetProgressBar(
                  percent: budget.percentUsed as double,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '${((budget.percentUsed as double) * 100).toInt()}%',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: (budget.isOverBudget as bool)
                      ? AppColors.budgetDanger
                      : AppColors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header as sliver
// ---------------------------------------------------------------------------
class _SliverSection extends StatelessWidget {
  const _SliverSection({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.paddingL,
          0,
          AppDimensions.paddingL,
          AppDimensions.paddingS,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header icon button
// ---------------------------------------------------------------------------
class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final List<List<dynamic>> icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.3),
          ),
        ),
        child: AppIcon(icon: icon, size: 20.w),
      ),
    );
  }
}
