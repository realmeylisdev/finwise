import 'dart:math' as math;

import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/repositories/debt_payoff_repository.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:finwise/features/wellness_score/domain/entities/wellness_score_entity.dart';
import 'package:finwise/shared/extensions/date_extensions.dart';
import 'package:injectable/injectable.dart';

@injectable
class CalculateWellnessScoreUseCase {
  CalculateWellnessScoreUseCase({
    required TransactionRepository transactionRepository,
    required BudgetRepository budgetRepository,
    required DebtPayoffRepository debtPayoffRepository,
  })  : _transactionRepo = transactionRepository,
        _budgetRepo = budgetRepository,
        _debtPayoffRepo = debtPayoffRepository;

  final TransactionRepository _transactionRepo;
  final BudgetRepository _budgetRepo;
  final DebtPayoffRepository _debtPayoffRepo;

  Future<WellnessScoreEntity> call() async {
    final now = DateTime.now();
    final monthStart = now.startOfMonth;
    final monthEnd = now.endOfMonth;

    // Fetch all needed data
    final incomeResult = await _transactionRepo.getTotalByType(
      'income',
      monthStart,
      monthEnd,
    );
    final expenseResult = await _transactionRepo.getTotalByType(
      'expense',
      monthStart,
      monthEnd,
    );
    final budgetsResult = await _budgetRepo.getBudgetsForMonth(
      now.year,
      now.month,
    );
    final debtsResult = await _debtPayoffRepo.getDebts();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final last30Result = await _transactionRepo.getTransactionsByDateRange(
      thirtyDaysAgo,
      now,
    );

    final totalIncome = incomeResult.getOrElse((_) => 0.0);
    final totalExpense = expenseResult.getOrElse((_) => 0.0);
    final budgets = budgetsResult.getOrElse((_) => []);
    final debts = debtsResult.getOrElse((_) => []);
    final last30Txns = last30Result.getOrElse((_) => []);

    // Calculate individual scores
    final budgetScore = _calculateBudgetScore(budgets);
    final savingsScore = _calculateSavingsScore(totalIncome, totalExpense);
    final debtScore = _calculateDebtScore(debts, totalIncome);
    final consistencyScore = _calculateConsistencyScore(last30Txns, thirtyDaysAgo);

    // Weighted average (equal 25% each)
    final overallScore = ((budgetScore + savingsScore + debtScore + consistencyScore) / 4).round();

    return WellnessScoreEntity(
      overallScore: overallScore.clamp(0, 100),
      budgetScore: budgetScore,
      savingsScore: savingsScore,
      debtScore: debtScore,
      consistencyScore: consistencyScore,
    );
  }

  int _calculateBudgetScore(List<BudgetWithSpendingEntity> budgets) {
    if (budgets.isEmpty) return 0;

    // Coverage score: how many budgets are set up (max at 5)
    final coverageScore = math.min(budgets.length / 5.0, 1.0) * 50;

    // Compliance score: what % of budgets are under limit
    final underBudgetCount =
        budgets.where((b) => !b.isOverBudget).length;
    final complianceScore =
        budgets.isNotEmpty ? (underBudgetCount / budgets.length) * 50 : 0.0;

    return (coverageScore + complianceScore).round().clamp(0, 100);
  }

  int _calculateSavingsScore(double income, double expense) {
    if (income <= 0) return 0;

    final savingsRate = (income - expense) / income;

    // Map savings rate to score: 0% = 0, 10% = 50, 20%+ = 100
    if (savingsRate <= 0) return 0;
    if (savingsRate >= 0.20) return 100;
    if (savingsRate >= 0.10) {
      // Linear interpolation: 10% -> 50, 20% -> 100
      return (50 + (savingsRate - 0.10) / 0.10 * 50).round();
    }
    // Linear interpolation: 0% -> 0, 10% -> 50
    return (savingsRate / 0.10 * 50).round();
  }

  int _calculateDebtScore(List<DebtEntity> debts, double monthlyIncome) {
    if (debts.isEmpty) return 100;

    final totalDebtPayments = debts.fold<double>(
      0,
      (sum, debt) => sum + debt.minimumPayment,
    );

    if (monthlyIncome <= 0) return 30;

    final dti = totalDebtPayments / monthlyIncome;

    if (dti < 0.20) return 90;
    if (dti < 0.35) return 70;
    if (dti < 0.50) return 50;
    return 30;
  }

  int _calculateConsistencyScore(
    List<TransactionEntity> transactions,
    DateTime startDate,
  ) {
    if (transactions.isEmpty) return 0;

    // Count unique days with at least one transaction in the last 30 days
    final uniqueDays = <int>{};
    for (final txn in transactions) {
      final dayIndex = txn.date.difference(startDate).inDays;
      if (dayIndex >= 0 && dayIndex < 30) {
        uniqueDays.add(dayIndex);
      }
    }

    // Score based on days with transactions out of 30
    return ((uniqueDays.length / 30.0) * 100).round().clamp(0, 100);
  }
}
