import 'package:finwise/core/constants/app_constants.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/account/presentation/bloc/account_bloc.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({this.transaction, super.key});

  final TransactionEntity? transaction;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late TransactionType _type;
  String? _categoryId;
  String? _accountId;
  String? _toAccountId;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _type = txn?.type ?? TransactionType.expense;
    _categoryId = txn?.categoryId;
    _accountId = txn?.accountId;
    _toAccountId = txn?.toAccountId;
    _date = txn?.date ?? DateTime.now();
    if (txn != null) {
      _amountController.text = txn.amount.toStringAsFixed(2);
      _noteController.text = txn.note ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an account')),
      );
      return;
    }

    final now = DateTime.now();
    final txn = TransactionEntity(
      id: widget.transaction?.id ?? const Uuid().v4(),
      amount: double.parse(_amountController.text.trim()),
      type: _type,
      categoryId: _type != TransactionType.transfer ? _categoryId : null,
      accountId: _accountId!,
      toAccountId:
          _type == TransactionType.transfer ? _toAccountId : null,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      date: _date,
      currencyCode: AppConstants.defaultCurrencyCode,
      createdAt: widget.transaction?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.transaction != null) {
      context.read<TransactionBloc>().add(TransactionUpdated(txn));
    } else {
      context.read<TransactionBloc>().add(TransactionCreated(txn));
    }
    HapticFeedback.mediumImpact();
    context.pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _date = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _date.hour,
          _date.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = context.watch<CategoryBloc>().state;
    final accountState = context.watch<AccountBloc>().state;
    final categories = _type == TransactionType.income
        ? categoryState.incomeCategories
        : categoryState.expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction != null ? 'Edit Transaction' : 'New Transaction',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Type selector
            SegmentedButton<TransactionType>(
              segments: [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: const Text('Expense'),
                  icon: Icon(
                    Icons.arrow_downward,
                    color: _type == TransactionType.expense
                        ? AppColors.expense
                        : null,
                  ),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: const Text('Income'),
                  icon: Icon(
                    Icons.arrow_upward,
                    color: _type == TransactionType.income
                        ? AppColors.income
                        : null,
                  ),
                ),
                ButtonSegment(
                  value: TransactionType.transfer,
                  label: const Text('Transfer'),
                  icon: Icon(
                    Icons.swap_horiz,
                    color: _type == TransactionType.transfer
                        ? AppColors.transfer
                        : null,
                  ),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selected) {
                setState(() {
                  _type = selected.first;
                  _categoryId = null;
                });
              },
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                suffixIcon: Icon(
                  Icons.attach_money,
                  color: _type == TransactionType.expense
                      ? AppColors.expense
                      : _type == TransactionType.income
                          ? AppColors.income
                          : AppColors.transfer,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter an amount';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Account
            DropdownButtonFormField<String>(
              value: _accountId,
              decoration: const InputDecoration(labelText: 'Account'),
              items: accountState.accounts
                  .map(
                    (a) => DropdownMenuItem(
                      value: a.id,
                      child: Text(a.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _accountId = value),
              validator: (value) =>
                  value == null ? 'Select an account' : null,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // To Account (for transfers)
            if (_type == TransactionType.transfer) ...[
              DropdownButtonFormField<String>(
                value: _toAccountId,
                decoration:
                    const InputDecoration(labelText: 'To Account'),
                items: accountState.accounts
                    .where((a) => a.id != _accountId)
                    .map(
                      (a) => DropdownMenuItem(
                        value: a.id,
                        child: Text(a.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _toAccountId = value),
                validator: (value) =>
                    value == null ? 'Select destination account' : null,
              ),
              SizedBox(height: AppDimensions.paddingM),
            ],

            // Category (not for transfers)
            if (_type != TransactionType.transfer) ...[
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppDimensions.paddingS),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.w,
                children: categories.map((cat) {
                  final isSelected = _categoryId == cat.id;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _categoryId = cat.id),
                    child: Chip(
                      avatar: CategoryIconWidget(
                        iconName: cat.icon,
                        color: cat.color,
                        size: 24,
                      ),
                      label: Text(cat.name),
                      backgroundColor: isSelected
                          ? Color(cat.color).withValues(alpha: 0.15)
                          : null,
                      side: isSelected
                          ? BorderSide(color: Color(cat.color))
                          : null,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: AppDimensions.paddingM),
            ],

            // Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(DateFormat('EEEE, MMM dd, yyyy').format(_date)),
              onTap: _pickDate,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Note
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'Add a note...',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 2,
              maxLength: 500,
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Submit
            ElevatedButton(
              onPressed: _submit,
              child: Text(
                widget.transaction != null
                    ? 'Update Transaction'
                    : 'Add Transaction',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
