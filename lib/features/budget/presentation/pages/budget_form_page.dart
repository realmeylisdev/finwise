import 'package:finwise/core/constants/app_constants.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class BudgetFormPage extends StatefulWidget {
  const BudgetFormPage({super.key});

  @override
  State<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends State<BudgetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _categoryId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final budgetState = context.read<BudgetBloc>().state;
    final now = DateTime.now();

    final budget = BudgetEntity(
      id: const Uuid().v4(),
      categoryId: _categoryId!,
      amount: double.parse(_amountController.text.trim()),
      currencyCode: AppConstants.defaultCurrencyCode,
      year: budgetState.selectedYear,
      month: budgetState.selectedMonth,
      createdAt: now,
      updatedAt: now,
    );

    context.read<BudgetBloc>().add(BudgetCreated(budget));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        context.watch<CategoryBloc>().state.expenseCategories;

    return Scaffold(
      appBar: AppBar(title: const Text('New Budget')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Category selection
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppDimensions.paddingS),
            DropdownButtonFormField<String>(
              value: _categoryId,
              decoration:
                  const InputDecoration(hintText: 'Select a category'),
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
                          SizedBox(width: AppDimensions.paddingS),
                          Text(c.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _categoryId = value),
              validator: (value) =>
                  value == null ? 'Select a category' : null,
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a budget amount';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingXL),

            ElevatedButton(
              onPressed: _submit,
              child: const Text('Create Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
