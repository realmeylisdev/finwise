import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/core/utils/date_formatter.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/savings_goal/presentation/bloc/savings_goal_bloc.dart';
import 'package:finwise/shared/widgets/celebration_dialog.dart';
import 'package:finwise/shared/widgets/privacy_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SavingsGoalDetailPage extends StatelessWidget {
  const SavingsGoalDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingsGoalBloc, SavingsGoalState>(
      listenWhen: (previous, current) =>
          !previous.goalJustCompleted && current.goalJustCompleted,
      listener: (context, state) {
        showCelebrationDialog(
          context,
          title: 'Goal Achieved!',
          subtitle: 'Congratulations on reaching your savings goal!',
        );
        context
            .read<SavingsGoalBloc>()
            .add(const GoalCelebrationAcknowledged());
      },
      child: BlocBuilder<SavingsGoalBloc, SavingsGoalState>(
        builder: (context, state) {
        final goal = state.goals.where((g) => g.id == id).firstOrNull;

        if (goal == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Goal')),
            body: const Center(child: Text('Goal not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(goal.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  context.read<SavingsGoalBloc>().add(GoalDeleted(id));
                  context.pop();
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              children: [
                // Progress card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      children: [
                        CategoryIconWidget(
                          iconName: goal.icon,
                          color: goal.color,
                          size: 56,
                        ),
                        SizedBox(height: AppDimensions.paddingM),
                        SizedBox(
                          width: 120.w,
                          height: 120.w,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 120.w,
                                height: 120.w,
                                child: CircularProgressIndicator(
                                  value: goal.percentComplete,
                                  backgroundColor: AppColors.primary
                                      .withValues(alpha: 0.15),
                                  color: goal.isCompleted
                                      ? AppColors.income
                                      : Color(goal.color),
                                  strokeWidth: 8,
                                ),
                              ),
                              Text(
                                '${(goal.percentComplete * 100).toInt()}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppDimensions.paddingL),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            _InfoColumn(
                              label: 'Saved',
                              value:
                                  '\$${goal.savedAmount.toStringAsFixed(2)}',
                              color: AppColors.income,
                            ),
                            _InfoColumn(
                              label: 'Target',
                              value:
                                  '\$${goal.targetAmount.toStringAsFixed(2)}',
                              color: AppColors.primary,
                            ),
                            _InfoColumn(
                              label: 'Remaining',
                              value:
                                  '\$${goal.remaining.toStringAsFixed(2)}',
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                        if (goal.deadline != null) ...[
                          SizedBox(height: AppDimensions.paddingM),
                          Text(
                            'Deadline: ${DateFormatter.fullDate(goal.deadline!)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingL),

                // Action buttons
                if (!goal.isCompleted)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showAmountDialog(context, goal, true),
                          icon: const Icon(Icons.add),
                          label: const Text('Contribute'),
                        ),
                      ),
                      SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: goal.savedAmount > 0
                              ? () => _showAmountDialog(
                                    context,
                                    goal,
                                    false,
                                  )
                              : null,
                          icon: const Icon(Icons.remove),
                          label: const Text('Withdraw'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }

  void _showAmountDialog(
    BuildContext context,
    SavingsGoalEntity goal,
    bool isContribute,
  ) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isContribute ? 'Contribute' : 'Withdraw'),
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
                if (isContribute) {
                  context.read<SavingsGoalBloc>().add(
                        GoalContributed(id: goal.id, amount: amount),
                      );
                } else {
                  context.read<SavingsGoalBloc>().add(
                        GoalWithdrawn(id: goal.id, amount: amount),
                      );
                }
                Navigator.of(ctx).pop();
              }
            },
            child: Text(isContribute ? 'Save' : 'Withdraw'),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
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
        PrivacyAmount(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
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
