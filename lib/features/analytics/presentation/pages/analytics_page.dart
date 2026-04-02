import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(const AnalyticsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
            if (state.status == AnalyticsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              children: [
                // Period selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AnalyticsPeriod.values.map((period) {
                      final isSelected = state.period == period;
                      return Padding(
                        padding: EdgeInsets.only(
                          right: AppDimensions.paddingS,
                        ),
                        child: ChoiceChip(
                          label: Text(
                            _periodLabel(period),
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : null,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          checkmarkColor: Colors.white,
                          onSelected: (_) => context
                              .read<AnalyticsBloc>()
                              .add(AnalyticsPeriodChanged(period)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingM),

                // Summary cards
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: 'Income',
                        amount: state.totalIncome,
                        color: AppColors.income,
                        icon: Icons.arrow_downward,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Expense',
                        amount: state.totalExpense,
                        color: AppColors.expense,
                        icon: Icons.arrow_upward,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.paddingS),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: 'Savings',
                        amount: state.savings,
                        color: state.savings >= 0
                            ? AppColors.income
                            : AppColors.expense,
                        icon: Icons.savings,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Avg/Day',
                        amount: state.averageDailySpending,
                        color: AppColors.transfer,
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.paddingL),

                // Income vs Expense bar chart
                if (state.monthlyTotals.isNotEmpty) ...[
                  Text(
                    'Income vs Expense',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  SizedBox(
                    height: 200.h,
                    child: _IncomeExpenseChart(
                      totals: state.monthlyTotals,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingL),
                ],

                // Spending by category
                if (state.categorySpending.isNotEmpty) ...[
                  Text(
                    'Spending by Category',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  SizedBox(
                    height: 200.h,
                    child: _CategoryPieChart(
                      spending: state.categorySpending,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  ...state.categorySpending.map(
                    (cs) => Padding(
                      padding: EdgeInsets.only(
                        bottom: AppDimensions.paddingS,
                      ),
                      child: Row(
                        children: [
                          CategoryIconWidget(
                            iconName: cs.categoryIcon,
                            color: cs.categoryColor,
                            size: 32,
                          ),
                          SizedBox(width: AppDimensions.paddingS),
                          Expanded(
                            child: Text(cs.categoryName),
                          ),
                          Text(
                            '\$${cs.amount.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: AppDimensions.paddingS),
                          Text(
                            '${(cs.percent * 100).toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Insights
                if (state.topCategory != null) ...[
                  SizedBox(height: AppDimensions.paddingL),
                  Text(
                    'Insights',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InsightRow(
                            icon: Icons.trending_up,
                            text:
                                'Top spending: ${state.topCategory!.categoryName}'
                                ' (\$${state.topCategory!.amount.toStringAsFixed(2)})',
                          ),
                          SizedBox(height: AppDimensions.paddingS),
                          _InsightRow(
                            icon: Icons.calendar_today,
                            text:
                                'Average daily spending:'
                                ' \$${state.averageDailySpending.toStringAsFixed(2)}',
                          ),
                          SizedBox(height: AppDimensions.paddingS),
                          _InsightRow(
                            icon: state.savings >= 0
                                ? Icons.thumb_up
                                : Icons.warning,
                            text: state.savings >= 0
                                ? 'You saved \$${state.savings.toStringAsFixed(2)} this period!'
                                : 'You overspent by \$${state.savings.abs().toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 40.h),
              ],
            );
          },
        ),
    );
  }

  String _periodLabel(AnalyticsPeriod period) {

    switch (period) {
      case AnalyticsPeriod.thisMonth:
        return 'This Month';
      case AnalyticsPeriod.lastMonth:
        return 'Last Month';
      case AnalyticsPeriod.last3Months:
        return '3 Months';
      case AnalyticsPeriod.last6Months:
        return '6 Months';
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 18),
            ),
            SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    '\$${amount.abs().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeExpenseChart extends StatelessWidget {
  const _IncomeExpenseChart({required this.totals});

  final List<MonthlyTotal> totals;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= totals.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  DateFormat('MMM').format(
                    DateTime(totals[index].year, totals[index].month),
                  ),
                  style: TextStyle(fontSize: 10.sp),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: totals.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.income,
                color: AppColors.income,
                width: 12.w,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(4.r),
                ),
              ),
              BarChartRodData(
                toY: entry.value.expense,
                color: AppColors.expense,
                width: 12.w,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(4.r),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryPieChart extends StatelessWidget {
  const _CategoryPieChart({required this.spending});

  final List<CategorySpending> spending;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40.r,
        sections: spending.take(6).map((cs) {
          return PieChartSectionData(
            value: cs.amount,
            color: Color(cs.categoryColor),
            radius: 50.r,
            title: '${(cs.percent * 100).toInt()}%',
            titleStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
