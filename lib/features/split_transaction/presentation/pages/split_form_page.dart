import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/split_transaction/domain/entities/transaction_split_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class SplitFormPage extends StatefulWidget {
  const SplitFormPage({
    required this.transactionId,
    required this.totalAmount,
    this.existingSplits = const [],
    super.key,
  });

  final String transactionId;
  final double totalAmount;
  final List<TransactionSplitEntity> existingSplits;

  @override
  State<SplitFormPage> createState() => _SplitFormPageState();
}

class _SplitFormPageState extends State<SplitFormPage> {
  final _rows = <_SplitRow>[];

  @override
  void initState() {
    super.initState();
    if (widget.existingSplits.isNotEmpty) {
      for (final split in widget.existingSplits) {
        _rows.add(_SplitRow(
          categoryId: split.categoryId,
          controller: TextEditingController(
            text: split.amount.toStringAsFixed(2),
          ),
        ));
      }
    } else {
      _addRow();
    }
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.controller.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      _rows.add(_SplitRow(
        categoryId: null,
        controller: TextEditingController(),
      ));
    });
  }

  void _removeRow(int index) {
    if (_rows.length <= 1) return;
    setState(() {
      _rows[index].controller.dispose();
      _rows.removeAt(index);
    });
  }

  double get _allocatedAmount {
    var total = 0.0;
    for (final row in _rows) {
      final parsed = double.tryParse(row.controller.text);
      if (parsed != null) total += parsed;
    }
    return total;
  }

  double get _remainingAmount => widget.totalAmount - _allocatedAmount;

  bool get _canSave =>
      _remainingAmount.abs() < 0.01 &&
      _rows.every((r) =>
          r.categoryId != null &&
          (double.tryParse(r.controller.text) ?? 0) > 0);

  void _save() {
    if (!_canSave) return;

    const uuid = Uuid();
    final splits = _rows.map((row) {
      return TransactionSplitEntity(
        id: uuid.v4(),
        transactionId: widget.transactionId,
        categoryId: row.categoryId!,
        amount: double.parse(row.controller.text),
      );
    }).toList();

    Navigator.of(context).pop(splits);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryState = context.watch<CategoryBloc>().state;
    final categories = categoryState.expenseCategories;

    return Scaffold(
      appBar: AppBar(title: const Text('Split Transaction')),
      body: Column(
        children: [
          // Summary bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.paddingM),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '\$${widget.totalAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Remaining',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '\$${_remainingAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _remainingAmount.abs() < 0.01
                            ? AppColors.income
                            : AppColors.expense,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Split rows
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              itemCount: _rows.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: AppDimensions.paddingS),
              itemBuilder: (context, index) {
                final row = _rows[index];
                return _SplitRowWidget(
                  row: row,
                  categories: categories,
                  canRemove: _rows.length > 1,
                  onCategoryChanged: (value) {
                    setState(() => _rows[index] = row.copyWith(
                          categoryId: value,
                        ));
                  },
                  onAmountChanged: (_) => setState(() {}),
                  onRemove: () => _removeRow(index),
                );
              },
            ),
          ),

          // Bottom actions
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _addRow,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Split'),
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _canSave ? _save : null,
                      child: const Text('Save Splits'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplitRow {
  _SplitRow({required this.categoryId, required this.controller});

  final String? categoryId;
  final TextEditingController controller;

  _SplitRow copyWith({String? categoryId}) {
    return _SplitRow(
      categoryId: categoryId ?? this.categoryId,
      controller: controller,
    );
  }
}

class _SplitRowWidget extends StatelessWidget {
  const _SplitRowWidget({
    required this.row,
    required this.categories,
    required this.canRemove,
    required this.onCategoryChanged,
    required this.onAmountChanged,
    required this.onRemove,
  });

  final _SplitRow row;
  final List<CategoryEntity> categories;
  final bool canRemove;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                value: row.categoryId,
                decoration: InputDecoration(
                  labelText: 'Category',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: AppDimensions.paddingS,
                  ),
                ),
                isExpanded: true,
                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Row(
                          children: [
                            CategoryIconWidget(
                              iconName: c.icon,
                              color: c.color,
                              size: 24,
                            ),
                            SizedBox(width: AppDimensions.paddingXS),
                            Flexible(
                              child: Text(
                                c.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onCategoryChanged,
              ),
            ),
            SizedBox(width: AppDimensions.paddingS),
            Expanded(
              flex: 2,
              child: TextField(
                controller: row.controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: AppDimensions.paddingS,
                  ),
                ),
                onChanged: onAmountChanged,
              ),
            ),
            if (canRemove)
              IconButton(
                onPressed: onRemove,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.expense,
                  size: 20.w,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
