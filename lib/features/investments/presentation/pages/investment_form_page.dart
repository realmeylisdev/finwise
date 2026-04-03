import 'package:finwise/core/constants/app_constants.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';
import 'package:finwise/features/investments/presentation/bloc/investments_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class InvestmentFormPage extends StatefulWidget {
  const InvestmentFormPage({this.investment, super.key});

  final InvestmentEntity? investment;

  @override
  State<InvestmentFormPage> createState() => _InvestmentFormPageState();
}

class _InvestmentFormPageState extends State<InvestmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tickerController = TextEditingController();
  final _unitsController = TextEditingController();
  final _costBasisController = TextEditingController();
  final _currentPriceController = TextEditingController();
  final _notesController = TextEditingController();
  InvestmentType _selectedType = InvestmentType.stock;

  bool get _isEditing => widget.investment != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final inv = widget.investment!;
      _nameController.text = inv.name;
      _tickerController.text = inv.ticker ?? '';
      _unitsController.text = inv.units.toStringAsFixed(4);
      _costBasisController.text = inv.costBasis.toStringAsFixed(2);
      _currentPriceController.text = inv.currentPrice.toStringAsFixed(2);
      _notesController.text = inv.notes ?? '';
      _selectedType = inv.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tickerController.dispose();
    _unitsController.dispose();
    _costBasisController.dispose();
    _currentPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final entity = InvestmentEntity(
      id: widget.investment?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      ticker: _tickerController.text.trim().isEmpty
          ? null
          : _tickerController.text.trim().toUpperCase(),
      units: double.parse(_unitsController.text.trim()),
      costBasis: double.parse(_costBasisController.text.trim()),
      currentPrice: double.parse(_currentPriceController.text.trim()),
      currencyCode: AppConstants.defaultCurrencyCode,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.investment?.createdAt ?? now,
      updatedAt: now,
    );

    if (_isEditing) {
      context.read<InvestmentsBloc>().add(InvestmentUpdated(entity));
    } else {
      context.read<InvestmentsBloc>().add(InvestmentCreated(entity));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Investment' : 'New Investment'),
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
                labelText: 'Investment Name',
                hintText: 'e.g. Apple Inc., Bitcoin, Vanguard S&P 500',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Ticker (optional)
            TextFormField(
              controller: _tickerController,
              decoration: const InputDecoration(
                labelText: 'Ticker (optional)',
                hintText: 'e.g. AAPL, BTC, VOO',
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Type
            Text('Type', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: AppDimensions.paddingS),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<InvestmentType>(
                segments: InvestmentType.values.map((type) {
                  return ButtonSegment<InvestmentType>(
                    value: type,
                    label: Text(
                      InvestmentEntity.typeDisplayName(type),
                      style: TextStyle(fontSize: 11.sp),
                    ),
                  );
                }).toList(),
                selected: {_selectedType},
                onSelectionChanged: (selected) {
                  setState(() => _selectedType = selected.first);
                },
                showSelectedIcon: false,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Units
            TextFormField(
              controller: _unitsController,
              decoration: const InputDecoration(
                labelText: 'Units / Shares',
                hintText: 'e.g. 10, 0.5',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter the number of units';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Cost Basis
            TextFormField(
              controller: _costBasisController,
              decoration: const InputDecoration(
                labelText: 'Total Cost Basis',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter the cost basis';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Current Price
            TextFormField(
              controller: _currentPriceController,
              decoration: const InputDecoration(
                labelText: 'Current Price per Unit',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter the current price';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid price';
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
                _isEditing ? 'Update Investment' : 'Add Investment',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
