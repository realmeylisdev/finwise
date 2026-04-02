import 'package:equatable/equatable.dart';

class BillReminderEntity extends Equatable {
  const BillReminderEntity({
    required this.id,
    required this.name,
    required this.amount,
    this.categoryId,
    this.accountId,
    required this.currencyCode,
    required this.dueDay,
    this.note,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final double amount;
  final String? categoryId;
  final String? accountId;
  final String currencyCode;
  final int dueDay;
  final String? note;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool isDueToday(int currentDay) => dueDay == currentDay;

  bool isOverdue(int currentDay) => dueDay < currentDay;

  int daysUntilDue(int currentDay) {
    if (dueDay >= currentDay) return dueDay - currentDay;
    // Next month
    return (30 - currentDay) + dueDay;
  }

  BillReminderEntity copyWith({
    String? id,
    String? name,
    double? amount,
    String? categoryId,
    String? accountId,
    String? currencyCode,
    int? dueDay,
    String? note,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillReminderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      currencyCode: currencyCode ?? this.currencyCode,
      dueDay: dueDay ?? this.dueDay,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, name, amount, categoryId, accountId,
        currencyCode, dueDay, note, isActive,
        createdAt, updatedAt,
      ];
}
