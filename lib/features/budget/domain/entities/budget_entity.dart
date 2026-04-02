import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  const BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.currencyCode,
    required this.year,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String categoryId;
  final double amount;
  final String currencyCode;
  final int year;
  final int month;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetEntity copyWith({
    String? id,
    String? categoryId,
    double? amount,
    String? currencyCode,
    int? year,
    int? month,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, categoryId, amount, currencyCode,
        year, month, createdAt, updatedAt,
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

  double get remaining => budget.amount - spent;
  double get percentUsed =>
      budget.amount > 0 ? (spent / budget.amount).clamp(0, 2) : 0;
  bool get isOverBudget => spent > budget.amount;

  @override
  List<Object?> get props => [
        budget, categoryName, categoryIcon, categoryColor, spent,
      ];
}
