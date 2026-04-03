import 'package:finwise/core/constants/app_constants.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/net_worth/domain/entities/liability_entity.dart';
import 'package:finwise/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class LiabilityFormPage extends StatefulWidget {
  const LiabilityFormPage({this.liability, super.key});

  final LiabilityEntity? liability;

  @override
  State<LiabilityFormPage> createState() => _LiabilityFormPageState();
}

class _LiabilityFormPageState extends State<LiabilityFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _minimumPaymentController = TextEditingController();
  final _notesController = TextEditingController();
  LiabilityType _selectedType = LiabilityType.other;

  bool get _isEditing => widget.liability != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final l = widget.liability!;
      _nameController.text = l.name;
      _balanceController.text = l.balance.toStringAsFixed(2);
      _interestRateController.text =
          l.interestRate > 0 ? l.interestRate.toString() : '';
      _minimumPaymentController.text =
          l.minimumPayment > 0 ? l.minimumPayment.toStringAsFixed(2) : '';
      _notesController.text = l.notes ?? '';
      _selectedType = l.type;
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
    final entity = LiabilityEntity(
      id: widget.liability?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      balance: double.parse(_balanceController.text.trim()),
      interestRate:
          double.tryParse(_interestRateController.text.trim()) ?? 0,
      minimumPayment:
          double.tryParse(_minimumPaymentController.text.trim()) ?? 0,
      currencyCode: AppConstants.defaultCurrencyCode,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.liability?.createdAt ?? now,
      updatedAt: now,
    );

    if (_isEditing) {
      context.read<NetWorthBloc>().add(LiabilityUpdated(entity));
    } else {
      context.read<NetWorthBloc>().add(LiabilityCreated(entity));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Liability' : 'New Liability'),
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
                labelText: 'Liability Name',
                hintText: 'e.g. Home Mortgage, Student Loan',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Type
            Text('Type', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: AppDimensions.paddingS),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.w,
              children: LiabilityType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(
                    LiabilityEntity.typeDisplayName(type),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  onSelected: (_) =>
                      setState(() => _selectedType = type),
                );
              }).toList(),
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Balance
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Balance',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter the balance';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Interest rate
            TextFormField(
              controller: _interestRateController,
              decoration: const InputDecoration(
                labelText: 'Interest Rate (optional)',
                suffixText: '%',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed < 0 || parsed > 100) {
                    return 'Enter a valid rate (0-100)';
                  }
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Minimum payment
            TextFormField(
              controller: _minimumPaymentController,
              decoration: const InputDecoration(
                labelText: 'Minimum Payment (optional)',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid amount';
                  }
                }
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
              maxLines: 3,
            ),
            SizedBox(height: AppDimensions.paddingXL),

            ElevatedButton(
              onPressed: _submit,
              child: Text(
                _isEditing ? 'Update Liability' : 'Add Liability',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
