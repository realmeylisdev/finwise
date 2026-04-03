import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/savings_goal/presentation/bloc/savings_goal_bloc.dart';
import 'package:finwise/shared/widgets/privacy_amount.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SavingsGoalsPage extends StatelessWidget {
  const SavingsGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Savings Goals')),
      body: BlocBuilder<SavingsGoalBloc, SavingsGoalState>(
        builder: (context, state) {
          if (state.status == SavingsGoalStatus.loading) {
            return const SkeletonListTileGroup(count: 3);
          }
          if (state.goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 64.w,
                    color: AppColors.disabled,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'No savings goals yet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  const Text('Set a goal and start saving!'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            itemCount: state.goals.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppDimensions.paddingS),
            itemBuilder: (context, index) {
              final goal = state.goals[index];
              return _GoalCard(
                goal: goal,
                onTap: () =>
                    context.push('${AppRoutes.goals}/${goal.id}'),
                onContribute: () =>
                    _showContributeDialog(context, goal),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_goals',
        onPressed: () => context.push('${AppRoutes.goals}/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showContributeDialog(
    BuildContext context,
    SavingsGoalEntity goal,
  ) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Contribute to ${goal.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '\$ ',
          ),
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text.trim());
              if (amount != null && amount > 0) {
                context.read<SavingsGoalBloc>().add(
                      GoalContributed(id: goal.id, amount: amount),
                    );
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.onTap,
    required this.onContribute,
  });

  final SavingsGoalEntity goal;
  final VoidCallback onTap;
  final VoidCallback onContribute;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            children: [
              Row(
                children: [
                  CategoryIconWidget(
                    iconName: goal.icon,
                    color: goal.color,
                    size: 44,
                  ),
                  SizedBox(width: AppDimensions.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 2.h),
                        PrivacyAmount(
                          child: Text(
                            '\$${goal.savedAmount.toStringAsFixed(2)}'
                            ' / \$${goal.targetAmount.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: goal.percentComplete,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          color: goal.isCompleted
                              ? AppColors.income
                              : AppColors.primary,
                          strokeWidth: 4,
                        ),
                        Text(
                          '${(goal.percentComplete * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!goal.isCompleted) ...[
                SizedBox(height: AppDimensions.paddingS),
                Row(
                  children: [
                    if (goal.daysUntilDeadline != null)
                      Text(
                        '${goal.daysUntilDeadline} days left',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: onContribute,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Contribute'),
                    ),
                  ],
                ),
              ] else
                Padding(
                  padding: EdgeInsets.only(top: AppDimensions.paddingS),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.income,
                        size: 16.w,
                      ),
                      SizedBox(width: AppDimensions.paddingXS),
                      Text(
                        'Goal completed!',
                        style: TextStyle(
                          color: AppColors.income,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
