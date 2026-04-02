import 'package:equatable/equatable.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/bill_reminder/domain/entities/bill_reminder_entity.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';

class DashboardSummaryEntity extends Equatable {
  const DashboardSummaryEntity({
    this.totalBalance = 0,
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.accounts = const [],
    this.recentTransactions = const [],
    this.budgets = const [],
    this.activeGoals = const [],
    this.upcomingBills = const [],
    this.spendingByCategory = const {},
  });

  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<AccountEntity> accounts;
  final List<TransactionEntity> recentTransactions;
  final List<BudgetWithSpendingEntity> budgets;
  final List<SavingsGoalEntity> activeGoals;
  final List<BillReminderEntity> upcomingBills;
  final Map<String, double> spendingByCategory;

  double get netFlow => totalIncome - totalExpense;

  @override
  List<Object?> get props => [
        totalBalance, totalIncome, totalExpense, accounts,
        recentTransactions, budgets, activeGoals, upcomingBills,
        spendingByCategory,
      ];
}
