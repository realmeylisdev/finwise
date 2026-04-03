import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  const BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.currencyCode,
    required this.year,
    required this.month,
    this.rolloverAmount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String categoryId;
  final double amount;
  final String currencyCode;
  final int year;
  final int month;
  final double rolloverAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetEntity copyWith({
    String? id,
    String? categoryId,
    double? amount,
    String? currencyCode,
    int? year,
    int? month,
    double? rolloverAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      year: year ?? this.year,
      month: month ?? this.month,
      rolloverAmount: rolloverAmount ?? this.rolloverAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, categoryId, amount, currencyCode,
        year, month, rolloverAmount, createdAt, updatedAt,
      ];
}

class BudgetWithSpendingEntity extends Equatable {
  const BudgetWithSpendingEntity({
    required this.budget,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.spent,
  });

  final BudgetEntity budget;
  final String categoryName;
  final String categoryIcon;
  final int categoryColor;
  final double spent;

  double get _effectiveBudget => budget.amount + budget.rolloverAmount;
  double get remaining => _effectiveBudget - spent;
  double get percentUsed =>
      _effectiveBudget > 0 ? (spent / _effectiveBudget).clamp(0, 2) : 0;
  bool get isOverBudget => spent > _effectiveBudget;

  @override
  List<Object?> get props => [
        budget, categoryName, categoryIcon, categoryColor, spent,
      ];
}
