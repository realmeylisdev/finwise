import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:finwise/features/budget/presentation/widgets/budget_progress_bar.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          return Column(
            children: [
              // Month selector
              _MonthSelector(
                year: state.selectedYear,
                month: state.selectedMonth,
                onChanged: (year, month) => context.read<BudgetBloc>().add(
                      BudgetMonthChanged(year: year, month: month),
                    ),
              ),

              // Summary card
              if (state.budgets.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                  ),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Spent',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                              Text(
                                '\$${state.totalSpent.toStringAsFixed(2)}'
                                ' / \$${state.totalBudgeted.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.paddingS),
                          BudgetProgressBar(percent: state.overallPercent),
                        ],
                      ),
                    ),
                  ),
                ),

              // Budget list
              Expanded(
                child: state.status == BudgetStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : state.budgets.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pie_chart_outline,
                                  size: 64.w,
                                  color: AppColors.disabled,
                                ),
                                SizedBox(height: AppDimensions.paddingM),
                                Text(
                                  'No budgets for this month',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                SizedBox(height: AppDimensions.paddingS),
                                const Text('Tap + to create a budget'),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding:
                                EdgeInsets.all(AppDimensions.paddingM),
                            itemCount: state.budgets.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: AppDimensions.paddingS),
                            itemBuilder: (context, index) {
                              final b = state.budgets[index];
                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    AppDimensions.paddingM,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CategoryIconWidget(
                                            iconName: b.categoryIcon,
                                            color: b.categoryColor,
                                          ),
                                          SizedBox(
                                            width: AppDimensions.paddingM,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  b.categoryName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                Text(
                                                  '\$${b.spent.toStringAsFixed(2)}'
                                                  ' / \$${b.budget.amount.toStringAsFixed(2)}',
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
                                          Text(
                                            '${(b.percentUsed * 100).toInt()}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: b.isOverBudget
                                                      ? AppColors
                                                          .budgetDanger
                                                      : null,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: AppDimensions.paddingS,
                                      ),
                                      BudgetProgressBar(
                                        percent: b.percentUsed,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_budgets',
        onPressed: () => context.push('${AppRoutes.budgets}/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.year,
    required this.month,
    required this.onChanged,
  });

  final int year;
  final int month;
  final void Function(int year, int month) onChanged;

  @override
  Widget build(BuildContext context) {
    final date = DateTime(year, month);
    return Padding(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final prev = DateTime(year, month - 1);
              onChanged(prev.year, prev.month);
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(date),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final next = DateTime(year, month + 1);
              onChanged(next.year, next.month);
            },
          ),
        ],
      ),
    );
  }
}
