import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/bill_reminder/domain/entities/bill_reminder_entity.dart';
import 'package:finwise/features/bill_reminder/presentation/bloc/bill_reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class BillRemindersPage extends StatelessWidget {
  const BillRemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day;

    return Scaffold(
      appBar: AppBar(title: const Text('Bill Reminders')),
      body: BlocBuilder<BillReminderBloc, BillReminderState>(
        builder: (context, state) {
          if (state.status == BillReminderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.bills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 64.w,
                    color: AppColors.disabled,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'No bill reminders',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  const Text('Add bills to never miss a payment'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            itemCount: state.bills.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppDimensions.paddingS),
            itemBuilder: (context, index) {
              final bill = state.bills[index];
              return _BillCard(bill: bill, today: today);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_bills',
        onPressed: () => context.push(AppRoutes.settingsBillForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  const _BillCard({required this.bill, required this.today});

  final BillReminderEntity bill;
  final int today;

  @override
  Widget build(BuildContext context) {
    final isDue = bill.isDueToday(today);
    final isOverdue = bill.isOverdue(today);
    final statusColor = isDue
        ? AppColors.budgetWarning
        : isOverdue
            ? AppColors.budgetDanger
            : AppColors.transfer;
    final statusText = isDue
        ? 'Due today'
        : isOverdue
            ? 'Overdue'
            : '${bill.daysUntilDue(today)} days left';

    return Dismissible(
      key: Key(bill.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppDimensions.paddingM),
        color: AppColors.expense,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) =>
          context.read<BillReminderBloc>().add(BillDeleted(bill.id)),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: statusColor.withValues(alpha: 0.15),
            child: Icon(Icons.receipt_outlined, color: statusColor),
          ),
          title: Text(bill.name),
          subtitle: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'Day ${bill.dueDay}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          trailing: Text(
            '\$${bill.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

// Inline form page for bills (simple enough to keep here)
class BillReminderFormPage extends StatefulWidget {
  const BillReminderFormPage({super.key});

  @override
  State<BillReminderFormPage> createState() => _BillReminderFormPageState();
}

class _BillReminderFormPageState extends State<BillReminderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  int _dueDay = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final bill = BillReminderEntity(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      currencyCode: 'USD',
      dueDay: _dueDay,
      createdAt: now,
      updatedAt: now,
    );

    context.read<BillReminderBloc>().add(BillCreated(bill));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Bill')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Bill Name',
                hintText: 'e.g. Rent, Netflix, Internet',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a name' : null,
            ),
            SizedBox(height: AppDimensions.paddingM),
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
            DropdownButtonFormField<int>(
              value: _dueDay,
              decoration:
                  const InputDecoration(labelText: 'Due Day of Month'),
              items: List.generate(
                31,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('Day ${i + 1}'),
                ),
              ),
              onChanged: (v) => setState(() => _dueDay = v ?? 1),
            ),
            SizedBox(height: AppDimensions.paddingXL),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Create Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
