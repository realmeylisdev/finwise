import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/subscription/domain/entities/subscription_entity.dart';
import 'package:finwise/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:finwise/features/subscription/presentation/widgets/subscription_cost_summary.dart';
import 'package:finwise/shared/widgets/pill_tab_bar.dart';
import 'package:finwise/shared/widgets/privacy_amount.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  int _tabIndex = 0; // 0 = Active, 1 = All

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(const SubscriptionsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscriptions')),
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          if (state.status == SubscriptionStatus.loading) {
            return const SkeletonListTileGroup(count: 5);
          }

          final filtered = _tabIndex == 0
              ? state.subscriptions.where((s) => s.isActive).toList()
              : state.subscriptions;
          final activeCount =
              state.subscriptions.where((s) => s.isActive).length;

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              SubscriptionCostSummary(
                monthlyCost: state.totalMonthlyCost,
                yearlyCost: state.totalYearlyCost,
                activeCount: activeCount,
              ),
              SizedBox(height: AppDimensions.paddingM),
              PillTabBar(
                tabs: const [
                  PillTab(label: 'Active'),
                  PillTab(label: 'All'),
                ],
                selectedIndex: _tabIndex,
                onChanged: (index) => setState(() => _tabIndex = index),
              ),
              SizedBox(height: AppDimensions.paddingM),
              if (filtered.isEmpty)
                _EmptyState(isActiveTab: _tabIndex == 0)
              else
                ...filtered.map(
                  (sub) => Padding(
                    padding:
                        EdgeInsets.only(bottom: AppDimensions.paddingS),
                    child: _SubscriptionCard(
                      subscription: sub,
                      onTap: () => context.push(
                        AppRoutes.subscriptionForm,
                        extra: sub,
                      ),
                      onDismissed: () => context
                          .read<SubscriptionBloc>()
                          .add(SubscriptionDeleted(sub.id)),
                    ),
                  ),
                ),
              SizedBox(height: AppDimensions.paddingXL),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_subscriptions',
        onPressed: () => context.push(AppRoutes.subscriptionForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.onTap,
    required this.onDismissed,
  });

  final SubscriptionEntity subscription;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat.MMMd();
    final days = subscription.daysUntilNextBilling;
    final cycleLabel =
        SubscriptionEntity.cycleDisplayName(subscription.billingCycle);

    final statusColor = days <= 0
        ? AppColors.budgetDanger
        : days <= 3
            ? AppColors.budgetWarning
            : AppColors.transfer;

    final statusText = days < 0
        ? 'Overdue'
        : days == 0
            ? 'Due today'
            : '$days days';

    return Dismissible(
      key: Key(subscription.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.expense,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                // Icon
                CircleAvatar(
                  backgroundColor: Color(subscription.color)
                      .withValues(alpha: 0.15),
                  child: Icon(
                    Icons.autorenew,
                    color: Color(subscription.color),
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subscription.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!subscription.isActive)
                            Container(
                              margin: EdgeInsets.only(left: 6.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.disabled
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusS),
                              ),
                              child: Text(
                                'Paused',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.disabled,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          // Cycle badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS),
                            ),
                            child: Text(
                              cycleLabel,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          // Days until next billing
                          if (subscription.isActive)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusS),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          SizedBox(width: 6.w),
                          Text(
                            dateFormat.format(subscription.nextBillingDate),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Amount
                PrivacyAmount(
                  child: Text(
                    currencyFormat.format(subscription.amount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isActiveTab});

  final bool isActiveTab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.autorenew,
              size: 64.w,
              color: AppColors.disabled,
            ),
            SizedBox(height: AppDimensions.paddingM),
            Text(
              isActiveTab
                  ? 'No active subscriptions'
                  : 'No subscriptions yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              'Add subscriptions to track your recurring costs',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
