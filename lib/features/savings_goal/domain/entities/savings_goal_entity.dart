import 'package:equatable/equatable.dart';

class SavingsGoalEntity extends Equatable {
  const SavingsGoalEntity({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.savedAmount = 0,
    required this.currencyCode,
    this.deadline,
    required this.icon,
    required this.color,
    this.isCompleted = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final String currencyCode;
  final DateTime? deadline;
  final String icon;
  final int color;
  final bool isCompleted;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get percentComplete =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0, 1) : 0;

  double get remaining => (targetAmount - savedAmount).clamp(0, double.infinity);

  int? get daysUntilDeadline {
    if (deadline == null) return null;
    return deadline!.difference(DateTime.now()).inDays;
  }

  SavingsGoalEntity copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? savedAmount,
    String? currencyCode,
    DateTime? deadline,
    String? icon,
    int? color,
    bool? isCompleted,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingsGoalEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      deadline: deadline ?? this.deadline,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, name, targetAmount, savedAmount, currencyCode,
        deadline, icon, color, isCompleted, isArchived,
        createdAt, updatedAt,
      ];
}
