import 'package:finwise/core/constants/app_constants.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/savings_goal/presentation/bloc/savings_goal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SavingsGoalFormPage extends StatefulWidget {
  const SavingsGoalFormPage({super.key});

  @override
  State<SavingsGoalFormPage> createState() => _SavingsGoalFormPageState();
}

class _SavingsGoalFormPageState extends State<SavingsGoalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedIcon = 'savings';
  int _selectedColor = Colors.blue.value;
  DateTime? _deadline;

  static const _icons = [
    'savings', 'flight', 'home', 'directions_car', 'laptop',
    'school', 'fitness_center', 'camera_alt', 'phone_android',
    'card_giftcard', 'local_cafe', 'music_note',
  ];

  static const _colors = [
    Colors.blue, Colors.green, Colors.purple, Colors.orange,
    Colors.red, Colors.teal, Colors.indigo, Colors.pink,
    Colors.amber, Colors.cyan, Colors.deepOrange, Colors.lime,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final goal = SavingsGoalEntity(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      targetAmount: double.parse(_amountController.text.trim()),
      currencyCode: AppConstants.defaultCurrencyCode,
      deadline: _deadline,
      icon: _selectedIcon,
      color: _selectedColor,
      createdAt: now,
      updatedAt: now,
    );

    context.read<SavingsGoalBloc>().add(GoalCreated(goal));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Goal')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Preview
            Center(
              child: CategoryIconWidget(
                iconName: _selectedIcon,
                color: _selectedColor,
                size: 64,
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Goal Name',
                hintText: 'e.g. New Car, Vacation, Emergency Fund',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Target amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a target amount';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Deadline
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(
                _deadline != null
                    ? DateFormat('MMM dd, yyyy').format(_deadline!)
                    : 'No deadline set',
              ),
              subtitle: const Text('Optional'),
              trailing: _deadline != null
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _deadline = null),
                    )
                  : null,
              onTap: _pickDeadline,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Icon picker
            Text('Icon', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppDimensions.paddingS),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: _icons.map((iconName) {
                final isSelected = _selectedIcon == iconName;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = iconName),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : null,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusS),
                      border: isSelected
                          ? Border.all(color: AppColors.primary)
                          : null,
                    ),
                    child: Icon(
                      CategoryIconWidget.categoryIcons[iconName] ??
                          Icons.flag,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.disabled,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Color picker
            Text('Color', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppDimensions.paddingS),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color.value;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedColor = color.value),
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppDimensions.paddingXL),

            ElevatedButton(
              onPressed: _submit,
              child: const Text('Create Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
