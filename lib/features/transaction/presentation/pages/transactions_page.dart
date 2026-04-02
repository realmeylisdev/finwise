import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/core/utils/date_formatter.dart';
import 'package:finwise/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:finwise/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(AppRoutes.search),
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state.status == TransactionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64.w,
                    color: AppColors.disabled,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  const Text('Tap + to add your first transaction'),
                ],
              ),
            );
          }

          final grouped = state.groupedByDate;
          final dates = grouped.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 80.h),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final txns = grouped[date]!;
              final dayTotal = txns.fold<double>(0, (sum, t) {
                if (t.type.name == 'expense') return sum - t.amount;
                if (t.type.name == 'income') return sum + t.amount;
                return sum;
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormatter.relative(date),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${dayTotal >= 0 ? '+' : ''}'
                          '\$${dayTotal.abs().toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: dayTotal >= 0
                                        ? AppColors.income
                                        : AppColors.expense,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // Transactions for this date
                  ...txns.map(
                    (txn) => TransactionListItem(
                      transaction: txn,
                      onTap: () => context.push(
                        '${AppRoutes.transactions}/${txn.id}',
                      ),
                      onDismissed: () => context
                          .read<TransactionBloc>()
                          .add(TransactionDeleted(txn.id)),
                    ),
                  ),
                  if (index < dates.length - 1)
                    Divider(height: 1, indent: AppDimensions.paddingM),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_transactions',
        onPressed: () => context.push('${AppRoutes.transactions}/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
