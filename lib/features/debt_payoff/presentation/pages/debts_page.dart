import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/presentation/bloc/debt_payoff_bloc.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DebtPayoffBloc>().add(const DebtsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debt Payoff')),
      body: BlocBuilder<DebtPayoffBloc, DebtPayoffState>(
        builder: (context, state) {
          if (state.status == DebtPayoffStatus.loading) {
            return const SkeletonListTileGroup(count: 5);
          }

          if (state.debts.isEmpty) {
            return _EmptyState();
          }

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              _TotalDebtCard(
                totalDebt: state.totalDebt,
                debtCount: state.debts.length,
              ),
              SizedBox(height: AppDimensions.paddingM),

              // View Payoff Plan button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.payoffPlan),
                  icon: const Icon(Icons.timeline),
                  label: const Text('View Payoff Plan'),
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Debt list
              ...state.debts.map(
                (debt) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.paddingS),
                  child: _DebtCard(
                    debt: debt,
                    onTap: () => context.push(
                      AppRoutes.debtForm,
                      extra: debt,
                    ),
                    onDismissed: () => context
                        .read<DebtPayoffBloc>()
                        .add(DebtDeleted(debt.id)),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.paddingXL),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_debts',
        onPressed: () => context.push(AppRoutes.debtForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TotalDebtCard extends StatelessWidget {
  const _TotalDebtCard({
    required this.totalDebt,
    required this.debtCount,
  });

  final double totalDebt;
  final int debtCount;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.expense,
            Color(0xFFDC2626),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          Text(
            'Total Debt',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            currencyFormat.format(totalDebt),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            '$debtCount ${debtCount == 1 ? 'debt' : 'debts'}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtCard extends StatelessWidget {
  const _DebtCard({
    required this.debt,
    required this.onTap,
    required this.onDismissed,
  });

  final DebtEntity debt;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final typeLabel = DebtEntity.typeDisplayName(debt.type);

    return Dismissible(
      key: Key(debt.id),
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
                  backgroundColor:
                      AppColors.expense.withValues(alpha: 0.15),
                  child: Icon(
                    _iconForType(debt.type),
                    color: AppColors.expense,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          // Type badge
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
                              typeLabel,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          // Interest rate
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.budgetWarning
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS),
                            ),
                            child: Text(
                              '${debt.interestRate.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.budgetWarning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          // Minimum payment
                          Text(
                            'Min: ${currencyFormat.format(debt.minimumPayment)}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                // Balance
                Text(
                  currencyFormat.format(debt.balance),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.expense,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(DebtType type) {
    switch (type) {
      case DebtType.creditCard:
        return Icons.credit_card;
      case DebtType.autoLoan:
        return Icons.directions_car;
      case DebtType.studentLoan:
        return Icons.school;
      case DebtType.mortgage:
        return Icons.home;
      case DebtType.personalLoan:
        return Icons.person;
      case DebtType.other:
        return Icons.account_balance;
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance,
              size: 64.w,
              color: AppColors.disabled,
            ),
            SizedBox(height: AppDimensions.paddingM),
            Text(
              'No debts yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              'Add your debts to create a payoff plan',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
