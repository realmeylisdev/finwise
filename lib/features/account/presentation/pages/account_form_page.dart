import 'package:finwise/core/constants/app_constants.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AccountFormPage extends StatefulWidget {
  const AccountFormPage({this.account, super.key});

  final AccountEntity? account;

  bool get isEditing => account != null;

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late AccountType _type;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account?.balance.toStringAsFixed(2) ?? '',
    );
    _type = widget.account?.type ?? AccountType.bank;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final balance =
        double.tryParse(_balanceController.text.trim()) ?? 0;

    final account = AccountEntity(
      id: widget.account?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _type,
      balance: widget.isEditing ? widget.account!.balance : balance,
      currencyCode: AppConstants.defaultCurrencyCode,
      sortOrder: widget.account?.sortOrder ?? 0,
      createdAt: widget.account?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.isEditing) {
      context.read<AccountBloc>().add(AccountUpdated(account));
    } else {
      context.read<AccountBloc>().add(AccountCreated(account));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Account' : 'New Account'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Account type
            SegmentedButton<AccountType>(
              segments: const [
                ButtonSegment(
                  value: AccountType.bank,
                  label: Text('Bank'),
                  icon: Icon(Icons.account_balance),
                ),
                ButtonSegment(
                  value: AccountType.cash,
                  label: Text('Cash'),
                  icon: Icon(Icons.payments),
                ),
                ButtonSegment(
                  value: AccountType.creditCard,
                  label: Text('Card'),
                  icon: Icon(Icons.credit_card),
                ),
                ButtonSegment(
                  value: AccountType.savings,
                  label: Text('Save'),
                  icon: Icon(Icons.savings),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selected) {
                setState(() => _type = selected.first);
              },
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account Name',
                hintText: 'e.g. Main Bank Account',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.trim().length < 2) return 'Name is too short';
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Initial balance (only for new accounts)
            if (!widget.isEditing) ...[
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(
                  labelText: 'Initial Balance',
                  hintText: '0.00',
                  prefixText: '\$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Invalid amount';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: AppDimensions.paddingL),
            ],

            // Submit
            ElevatedButton(
              onPressed: _submit,
              child: Text(widget.isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
