import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state.status == AccountStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64.w,
                    color: AppColors.disabled,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'No accounts yet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  const Text('Add your first account to get started'),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            itemCount: state.accounts.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppDimensions.paddingS),
            itemBuilder: (context, index) {
              return _AccountCard(account: state.accounts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_accounts',
        onPressed: () =>
            context.push(AppRoutes.settingsAccountForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.account});

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(_getAccountIcon(), color: AppColors.primary),
        ),
        title: Text(account.name),
        subtitle: Text(account.typeLabel),
        trailing: Text(
          '\$${account.balance.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: account.balance >= 0
                    ? AppColors.income
                    : AppColors.expense,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  IconData _getAccountIcon() {
    switch (account.type) {
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.cash:
        return Icons.payments;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.savings:
        return Icons.savings;
    }
  }
}
