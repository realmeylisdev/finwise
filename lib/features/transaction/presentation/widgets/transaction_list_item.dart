import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/core/utils/date_formatter.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/shared/widgets/privacy_amount.dart';
import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    required this.transaction,
    this.onTap,
    this.onDismissed,
    super.key,
  });

  final TransactionEntity transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final isTransfer = transaction.type == TransactionType.transfer;
    final amountColor = isExpense
        ? AppColors.expense
        : isTransfer
            ? AppColors.transfer
            : AppColors.income;
    final prefix = isExpense ? '-' : isTransfer ? '' : '+';

    Widget tile = ListTile(
      onTap: onTap,
      leading: transaction.categoryIcon != null
          ? CategoryIconWidget(
              iconName: transaction.categoryIcon!,
              color: transaction.categoryColor ?? Colors.grey.value,
            )
          : CircleAvatar(
              backgroundColor: amountColor.withValues(alpha: 0.15),
              child: Icon(
                isTransfer ? Icons.swap_horiz : Icons.attach_money,
                color: amountColor,
                size: 20,
              ),
            ),
      title: Text(
        transaction.categoryName ??
            (isTransfer ? 'Transfer' : 'Uncategorized'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        transaction.note?.isNotEmpty == true
            ? transaction.note!
            : transaction.accountName ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PrivacyAmount(
            child: Text(
              '$prefix\$${transaction.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            DateFormatter.relative(transaction.date),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );

    if (onDismissed != null) {
      tile = Dismissible(
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: AppDimensions.paddingM),
          color: AppColors.expense,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => onDismissed?.call(),
        child: tile,
      );
    }

    return tile;
  }
}
