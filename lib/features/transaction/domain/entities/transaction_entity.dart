import 'package:equatable/equatable.dart';

enum TransactionType { income, expense, transfer }

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    this.categoryId,
    required this.accountId,
    this.toAccountId,
    this.note,
    required this.date,
    required this.currencyCode,
    this.exchangeRate = 1.0,
    this.isRecurring = false,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
    this.accountName,
    this.toAccountName,
  });

  final String id;
  final double amount;
  final TransactionType type;
  final String? categoryId;
  final String accountId;
  final String? toAccountId;
  final String? note;
  final DateTime date;
  final String currencyCode;
  final double exchangeRate;
  final bool isRecurring;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined fields
  final String? categoryName;
  final String? categoryIcon;
  final int? categoryColor;
  final String? accountName;
  final String? toAccountName;

  TransactionEntity copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    String? categoryId,
    String? accountId,
    String? toAccountId,
    String? note,
    DateTime? date,
    String? currencyCode,
    double? exchangeRate,
    bool? isRecurring,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      note: note ?? this.note,
      date: date ?? this.date,
      currencyCode: currencyCode ?? this.currencyCode,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isRecurring: isRecurring ?? this.isRecurring,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static TransactionType typeFromString(String value) {
    switch (value) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }

  @override
  List<Object?> get props => [
        id, amount, type, categoryId, accountId,
        toAccountId, note, date, currencyCode,
        exchangeRate, isRecurring, createdAt, updatedAt,
      ];
}
