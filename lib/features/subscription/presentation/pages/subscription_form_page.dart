import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/subscription/domain/entities/subscription_entity.dart';
import 'package:finwise/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SubscriptionFormPage extends StatefulWidget {
  const SubscriptionFormPage({this.subscription, super.key});

  final SubscriptionEntity? subscription;

  @override
  State<SubscriptionFormPage> createState() => _SubscriptionFormPageState();
}

class _SubscriptionFormPageState extends State<SubscriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  BillingCycle _billingCycle = BillingCycle.monthly;
  DateTime _nextBillingDate = DateTime.now();
  String? _categoryId;
  bool _isActive = true;

  bool get _isEditing => widget.subscription != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final sub = widget.subscription!;
      _nameController.text = sub.name;
      _amountController.text = sub.amount.toStringAsFixed(2);
      _notesController.text = sub.notes ?? '';
      _billingCycle = sub.billingCycle;
      _nextBillingDate = sub.nextBillingDate;
      _categoryId = sub.categoryId;
      _isActive = sub.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final subscription = SubscriptionEntity(
      id: widget.subscription?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      currencyCode: 'USD',
      billingCycle: _billingCycle,
      nextBillingDate: _nextBillingDate,
      categoryId: _categoryId,
      isActive: _isActive,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.subscription?.createdAt ?? now,
      updatedAt: now,
    );

    final bloc = context.read<SubscriptionBloc>();
    if (_isEditing) {
      bloc.add(SubscriptionUpdated(subscription));
    } else {
      bloc.add(SubscriptionCreated(subscription));
    }
    context.pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _nextBillingDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Subscription' : 'New Subscription'),
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
                labelText: 'Subscription Name',
                hintText: 'e.g. Netflix, Spotify, iCloud',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a name' : null,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter amount';
                final p = double.tryParse(v.trim());
                if (p == null || p <= 0) return 'Invalid amount';
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Billing Cycle
            Text(
              'Billing Cycle',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            SegmentedButton<BillingCycle>(
              segments: BillingCycle.values
                  .map(
                    (cycle) => ButtonSegment<BillingCycle>(
                      value: cycle,
                      label: Text(
                        SubscriptionEntity.cycleDisplayName(cycle),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  )
                  .toList(),
              selected: {_billingCycle},
              onSelectionChanged: (selection) {
                setState(() => _billingCycle = selection.first);
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Next billing date
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Next Billing Date'),
              subtitle: Text(dateFormat.format(_nextBillingDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            SizedBox(height: AppDimensions.paddingS),

            // Category dropdown (optional)
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, catState) {
                final categories = catState.expenseCategories;
                return DropdownButtonFormField<String?>(
                  value: _categoryId,
                  decoration:
                      const InputDecoration(labelText: 'Category (optional)'),
                  items: [
                    const DropdownMenuItem<String?>(
                      child: Text('None'),
                    ),
                    ...categories.map(
                      (cat) => DropdownMenuItem<String?>(
                        value: cat.id,
                        child: Row(
                          children: [
                            CategoryIconWidget(
                              iconName: cat.icon,
                              color: cat.color,
                              size: 24.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(cat.name),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                );
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
            SizedBox(height: AppDimensions.paddingM),

            // Active toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active'),
              subtitle: const Text('Pause to stop tracking this subscription'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            SizedBox(height: AppDimensions.paddingXL),

            // Submit
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Save Changes' : 'Create Subscription'),
            ),
          ],
        ),
      ),
    );
  }
}
