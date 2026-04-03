import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/presentation/bloc/debt_payoff_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class DebtFormPage extends StatefulWidget {
  const DebtFormPage({this.debt, super.key});

  final DebtEntity? debt;

  @override
  State<DebtFormPage> createState() => _DebtFormPageState();
}

class _DebtFormPageState extends State<DebtFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _minimumPaymentController = TextEditingController();
  final _notesController = TextEditingController();

  DebtType _debtType = DebtType.creditCard;

  bool get _isEditing => widget.debt != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final debt = widget.debt!;
      _nameController.text = debt.name;
      _balanceController.text = debt.balance.toStringAsFixed(2);
      _interestRateController.text = debt.interestRate.toStringAsFixed(2);
      _minimumPaymentController.text = debt.minimumPayment.toStringAsFixed(2);
      _notesController.text = debt.notes ?? '';
      _debtType = debt.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _interestRateController.dispose();
    _minimumPaymentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final debt = DebtEntity(
      id: widget.debt?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _debtType,
      balance: double.parse(_balanceController.text.trim()),
      interestRate: double.parse(_interestRateController.text.trim()),
      minimumPayment: double.parse(_minimumPaymentController.text.trim()),
      currencyCode: 'USD',
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.debt?.createdAt ?? now,
      updatedAt: now,
    );

    final bloc = context.read<DebtPayoffBloc>();
    if (_isEditing) {
      bloc.add(DebtUpdated(debt));
    } else {
      bloc.add(DebtCreated(debt));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Debt' : 'New Debt'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Debt Name',
                hintText: 'e.g. Chase Visa, Car Loan',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a name' : null,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Type
            Text(
              'Debt Type',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            SegmentedButton<DebtType>(
              segments: DebtType.values
                  .map(
                    (type) => ButtonSegment<DebtType>(
                      value: type,
                      label: Text(
                        DebtEntity.typeDisplayName(type),
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ),
                  )
                  .toList(),
              selected: {_debtType},
              onSelectionChanged: (selection) {
                setState(() => _debtType = selection.first);
              },
              showSelectedIcon: false,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Balance
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Current Balance',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter balance';
                final p = double.tryParse(v.trim());
                if (p == null || p < 0) return 'Invalid balance';
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Interest Rate
            TextFormField(
              controller: _interestRateController,
              decoration: const InputDecoration(
                labelText: 'Annual Interest Rate',
                suffixText: '%',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter rate';
                final p = double.tryParse(v.trim());
                if (p == null || p < 0) return 'Invalid rate';
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Minimum Payment
            TextFormField(
              controller: _minimumPaymentController,
              decoration: const InputDecoration(
                labelText: 'Minimum Monthly Payment',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter payment';
                final p = double.tryParse(v.trim());
                if (p == null || p < 0) return 'Invalid amount';
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Any additional details',
              ),
              maxLines: 2,
            ),
            SizedBox(height: AppDimensions.paddingXL),

            // Submit
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Save Changes' : 'Add Debt'),
            ),
          ],
        ),
      ),
    );
  }
}
