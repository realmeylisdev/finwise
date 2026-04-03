import 'package:finwise/core/constants/app_constants.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/net_worth/domain/entities/asset_entity.dart';
import 'package:finwise/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AssetFormPage extends StatefulWidget {
  const AssetFormPage({this.asset, super.key});

  final AssetEntity? asset;

  @override
  State<AssetFormPage> createState() => _AssetFormPageState();
}

class _AssetFormPageState extends State<AssetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  AssetType _selectedType = AssetType.other;

  bool get _isEditing => widget.asset != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final a = widget.asset!;
      _nameController.text = a.name;
      _valueController.text = a.value.toStringAsFixed(2);
      _notesController.text = a.notes ?? '';
      _selectedType = a.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final entity = AssetEntity(
      id: widget.asset?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      value: double.parse(_valueController.text.trim()),
      currencyCode: AppConstants.defaultCurrencyCode,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.asset?.createdAt ?? now,
      updatedAt: now,
    );

    if (_isEditing) {
      context.read<NetWorthBloc>().add(AssetUpdated(entity));
    } else {
      context.read<NetWorthBloc>().add(AssetCreated(entity));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Asset' : 'New Asset'),
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
                labelText: 'Asset Name',
                hintText: 'e.g. House, Tesla Model 3, Bitcoin',
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
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AssetType>(
                segments: AssetType.values.map((type) {
                  return ButtonSegment<AssetType>(
                    value: type,
                    label: Text(
                      AssetEntity.typeDisplayName(type),
                      style: TextStyle(fontSize: 12.sp),
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

            // Value
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a value';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid amount';
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
              child: Text(_isEditing ? 'Update Asset' : 'Add Asset'),
            ),
          ],
        ),
      ),
    );
  }
}
