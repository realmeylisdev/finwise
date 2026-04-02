import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/core/utils/date_formatter.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:finwise/shared/widgets/app_icon.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final transaction = state.transactions.cast<TransactionEntity?>().firstWhere(
              (t) => t?.id == id,
              orElse: () => null,
            );

        if (transaction == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Transaction Detail')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    icon: HugeIcons.strokeRoundedFileNotFound,
                    size: AppDimensions.iconXL,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'Transaction not found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        final typeColor = _typeColor(transaction.type);
        final prefix = _amountPrefix(transaction.type);
        final typeLabel = _typeLabel(transaction.type);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Transaction Detail'),
            actions: [
              IconButton(
                icon: const AppIcon(icon: HugeIcons.strokeRoundedDelete02),
                tooltip: 'Delete transaction',
                onPressed: () => _confirmDelete(context, transaction),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              children: [
                // --- Amount card ---
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingXL,
                    horizontal: AppDimensions.paddingM,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.08),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.cardRadius),
                  ),
                  child: Column(
                    children: [
                      _TypeBadge(type: transaction.type),
                      SizedBox(height: AppDimensions.paddingM),
                      Text(
                        '$prefix\$${transaction.amount.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: typeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        typeLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: typeColor,
                            ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.paddingL),

                // --- Detail rows ---
                _DetailCard(
                  children: [
                    // Category
                    if (transaction.type != TransactionType.transfer)
                      _DetailRow(
                        icon: HugeIcons.strokeRoundedFolder02,
                        label: 'Category',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (transaction.categoryIcon != null) ...[
                              CategoryIconWidget(
                                iconName: transaction.categoryIcon!,
                                color: transaction.categoryColor ??
                                    Colors.grey.toARGB32(),
                                size: 28,
                              ),
                              SizedBox(width: AppDimensions.paddingS),
                            ],
                            Flexible(
                              child: Text(
                                transaction.categoryName ?? 'Uncategorized',
                                style: Theme.of(context).textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Account
                    _DetailRow(
                      icon: HugeIcons.strokeRoundedCreditCard,
                      label: transaction.type == TransactionType.transfer
                          ? 'From account'
                          : 'Account',
                      child: Text(
                        transaction.accountName ?? 'Unknown',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    // To Account (transfer only)
                    if (transaction.type == TransactionType.transfer &&
                        transaction.toAccountName != null)
                      _DetailRow(
                        icon: HugeIcons.strokeRoundedCreditCardChange,
                        label: 'To account',
                        child: Text(
                          transaction.toAccountName!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),

                    // Date
                    _DetailRow(
                      icon: HugeIcons.strokeRoundedCalendar03,
                      label: 'Date',
                      child: Text(
                        '${DateFormatter.fullDate(transaction.date)}'
                        '  ${DateFormatter.time(transaction.date)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    // Currency
                    _DetailRow(
                      icon: HugeIcons.strokeRoundedCoins01,
                      label: 'Currency',
                      child: Text(
                        transaction.currencyCode,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    // Note
                    if (transaction.note != null &&
                        transaction.note!.isNotEmpty)
                      _DetailRow(
                        icon: HugeIcons.strokeRoundedNote,
                        label: 'Note',
                        child: Text(
                          transaction.note!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static Color _typeColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return AppColors.income;
      case TransactionType.expense:
        return AppColors.expense;
      case TransactionType.transfer:
        return AppColors.transfer;
    }
  }

  static String _amountPrefix(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return '+';
      case TransactionType.expense:
        return '-';
      case TransactionType.transfer:
        return '';
    }
  }

  static String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TransactionEntity transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete transaction'),
        content:
            const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.expense),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<TransactionBloc>().add(TransactionDeleted(transaction.id));
      context.pop();
    }
  }
}

// -----------------------------------------------------------------------------
// Type badge shown above the amount
// -----------------------------------------------------------------------------
class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final Color bgColor;
    final List<List<dynamic>> icon;

    switch (type) {
      case TransactionType.income:
        color = AppColors.income;
        bgColor = AppColors.incomeBg;
        icon = HugeIcons.strokeRoundedArrowDown01;
      case TransactionType.expense:
        color = AppColors.expense;
        bgColor = AppColors.expenseBg;
        icon = HugeIcons.strokeRoundedArrowUp01;
      case TransactionType.transfer:
        color = AppColors.transfer;
        bgColor = AppColors.transferBg;
        icon = HugeIcons.strokeRoundedArrowDataTransferHorizontal;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: AppIcon(icon: icon, color: color, size: AppDimensions.iconM),
    );
  }
}

// -----------------------------------------------------------------------------
// Card that wraps the detail rows with consistent styling
// -----------------------------------------------------------------------------
class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Single detail row: icon + label on the left, value on the right
// -----------------------------------------------------------------------------
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.child,
  });

  final List<List<dynamic>> icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      child: Row(
        children: [
          AppIcon(
            icon: icon,
            size: AppDimensions.iconM,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                SizedBox(height: AppDimensions.paddingXS),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
