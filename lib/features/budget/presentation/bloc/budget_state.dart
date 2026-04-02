part of 'budget_bloc.dart';

enum BudgetStatus { initial, loading, success, failure }

class BudgetState extends Equatable {
  BudgetState({
    this.status = BudgetStatus.initial,
    this.budgets = const [],
    int? selectedYear,
    int? selectedMonth,
    this.failureMessage,
  })  : selectedYear = selectedYear ?? DateTime.now().year,
        selectedMonth = selectedMonth ?? DateTime.now().month;

  final BudgetStatus status;
  final List<BudgetWithSpendingEntity> budgets;
  final int selectedYear;
  final int selectedMonth;
  final String? failureMessage;

  double get totalBudgeted =>
      budgets.fold<double>(0, (sum, b) => sum + b.budget.amount);

  double get totalSpent =>
      budgets.fold<double>(0, (sum, b) => sum + b.spent);

  double get totalRemaining => totalBudgeted - totalSpent;

  double get overallPercent =>
      totalBudgeted > 0 ? (totalSpent / totalBudgeted).clamp(0, 2) : 0;

  BudgetState copyWith({
    BudgetStatus? status,
    List<BudgetWithSpendingEntity>? budgets,
    int? selectedYear,
    int? selectedMonth,
    String? failureMessage,
  }) {
    return BudgetState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, budgets, selectedYear, selectedMonth, failureMessage,
      ];
}
