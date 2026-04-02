import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:finwise/features/budget/presentation/widgets/budget_progress_bar.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BudgetDetailPage extends StatelessWidget {
  const BudgetDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        final item = state.budgets.where((b) => b.budget.id == id).firstOrNull;

        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Budget')),
            body: const Center(child: Text('Budget not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(item.categoryName),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  context.read<BudgetBloc>().add(BudgetDeleted(id));
                  context.pop();
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              children: [
                // Header card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      children: [
                        CategoryIconWidget(
                          iconName: item.categoryIcon,
                          color: item.categoryColor,
                          size: 56,
                        ),
                        SizedBox(height: AppDimensions.paddingM),
                        Text(
                          '${(item.percentUsed * 100).toInt()}%',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: item.isOverBudget
                                    ? AppColors.budgetDanger
                                    : AppColors.primary,
                              ),
                        ),
                        SizedBox(height: AppDimensions.paddingS),
                        BudgetProgressBar(
                          percent: item.percentUsed,
                          height: 12,
                        ),
                        SizedBox(height: AppDimensions.paddingM),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            _StatItem(
                              label: 'Spent',
                              value:
                                  '\$${item.spent.toStringAsFixed(2)}',
                              color: AppColors.expense,
                            ),
                            _StatItem(
                              label: 'Budget',
                              value:
                                  '\$${item.budget.amount.toStringAsFixed(2)}',
                              color: AppColors.primary,
                            ),
                            _StatItem(
                              label: 'Remaining',
                              value:
                                  '\$${item.remaining.toStringAsFixed(2)}',
                              color: item.isOverBudget
                                  ? AppColors.budgetDanger
                                  : AppColors.income,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
