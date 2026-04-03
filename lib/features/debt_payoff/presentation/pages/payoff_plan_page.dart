import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/debt_payoff/domain/entities/payoff_plan_entity.dart';
import 'package:finwise/features/debt_payoff/presentation/bloc/debt_payoff_bloc.dart';
import 'package:finwise/features/debt_payoff/presentation/widgets/payoff_timeline_chart.dart';
import 'package:finwise/features/debt_payoff/presentation/widgets/strategy_comparison_widget.dart';
import 'package:finwise/shared/widgets/pill_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PayoffPlanPage extends StatefulWidget {
  const PayoffPlanPage({super.key});

  @override
  State<PayoffPlanPage> createState() => _PayoffPlanPageState();
}

class _PayoffPlanPageState extends State<PayoffPlanPage> {
  int _tabIndex = 0; // 0 = Snowball, 1 = Avalanche
  double _extraPayment = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<DebtPayoffBloc>()
        .add(PayoffPlanCalculated(extraPayment: _extraPayment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payoff Plan')),
      body: BlocBuilder<DebtPayoffBloc, DebtPayoffState>(
        builder: (context, state) {
          final snowball = state.snowballPlan;
          final avalanche = state.avalanchePlan;

          if (snowball == null || avalanche == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final activePlan = _tabIndex == 0 ? snowball : avalanche;
          final dateFormat = DateFormat.yMMM();
          final currencyFormat = NumberFormat.currency(symbol: '\$');

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Strategy toggle
              PillTabBar(
                tabs: const [
                  PillTab(label: 'Snowball'),
                  PillTab(label: 'Avalanche'),
                ],
                selectedIndex: _tabIndex,
                onChanged: (index) => setState(() => _tabIndex = index),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Summary card
              _SummaryCard(
                plan: activePlan,
                dateFormat: dateFormat,
                currencyFormat: currencyFormat,
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Strategy comparison
              StrategyComparisonWidget(
                snowball: snowball,
                avalanche: avalanche,
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Chart
              Text(
                'Debt Reduction Timeline',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: AppDimensions.paddingS),
              PayoffTimelineChart(plan: activePlan),
              SizedBox(height: AppDimensions.paddingM),

              // Extra payment slider
              _ExtraPaymentSlider(
                value: _extraPayment,
                onChanged: (value) {
                  setState(() => _extraPayment = value);
                  context
                      .read<DebtPayoffBloc>()
                      .add(PayoffPlanCalculated(extraPayment: value));
                },
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Monthly plan details
              Text(
                'Monthly Plan',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: AppDimensions.paddingS),
              _MonthlyPlanList(plan: activePlan),
              SizedBox(height: AppDimensions.paddingXL),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.plan,
    required this.dateFormat,
    required this.currencyFormat,
  });

  final PayoffPlanEntity plan;
  final DateFormat dateFormat;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final strategyName =
        plan.strategy == PayoffStrategy.snowball ? 'Snowball' : 'Avalanche';
    final years = plan.totalMonths ~/ 12;
    final months = plan.totalMonths % 12;
    final timeText = years > 0
        ? '$years yr${years > 1 ? 's' : ''} $months mo'
        : '$months month${months != 1 ? 's' : ''}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: plan.strategy == PayoffStrategy.snowball
              ? [AppColors.transfer, const Color(0xFF2563EB)]
              : [AppColors.income, const Color(0xFF16A34A)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          Text(
            '$strategyName Strategy',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Debt-Free: ${dateFormat.format(plan.debtFreeDate)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Time to Payoff',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      timeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 36.h,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Total Interest',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      currencyFormat.format(plan.totalInterestPaid),
                      style: TextStyle(
                        color: AppColors.budgetWarning,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExtraPaymentSlider extends StatelessWidget {
  const _ExtraPaymentSlider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extra Monthly Payment',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.income.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    currencyFormat.format(value),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.income,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingS),
            Slider(
              value: value,
              min: 0,
              max: 500,
              divisions: 50,
              label: currencyFormat.format(value),
              onChanged: onChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(
                  '\$500+',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyPlanList extends StatelessWidget {
  const _MonthlyPlanList({required this.plan});

  final PayoffPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    if (plan.monthlyPlan.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
        child: Text(
          'No plan items to display.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    // Group by month/year — show aggregated data
    final grouped = <String, List<MonthlyPlanItem>>{};
    for (final item in plan.monthlyPlan) {
      final key =
          '${DateFormat('MMM yyyy').format(DateTime(item.year, item.month))}';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    // Show first 24 months, then a summary
    final entries = grouped.entries.toList();
    final displayCount = entries.length > 24 ? 24 : entries.length;
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Column(
      children: [
        ...entries.take(displayCount).map((entry) {
          final totalPayment =
              entry.value.fold<double>(0, (s, i) => s + i.payment);
          final totalInterest =
              entry.value.fold<double>(0, (s, i) => s + i.interestPaid);
          final totalPrincipal =
              entry.value.fold<double>(0, (s, i) => s + i.principalPaid);
          final remaining =
              entry.value.fold<double>(0, (s, i) => s + i.remainingBalance);

          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Remaining: ${currencyFormat.format(remaining)}',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.expense,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      _MiniStat(
                          label: 'Payment',
                          value: currencyFormat.format(totalPayment)),
                      SizedBox(width: 12.w),
                      _MiniStat(
                          label: 'Principal',
                          value: currencyFormat.format(totalPrincipal),
                          color: AppColors.income),
                      SizedBox(width: 12.w),
                      _MiniStat(
                          label: 'Interest',
                          value: currencyFormat.format(totalInterest),
                          color: AppColors.budgetWarning),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        if (entries.length > displayCount)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
            child: Text(
              '+ ${entries.length - displayCount} more months...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
