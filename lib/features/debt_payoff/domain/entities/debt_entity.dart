import 'package:equatable/equatable.dart';

enum DebtType { creditCard, autoLoan, studentLoan, mortgage, personalLoan, other }

class DebtEntity extends Equatable {
  const DebtEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.interestRate,
    required this.minimumPayment,
    required this.currencyCode,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final DebtType type;
  final double balance;
  final double interestRate;
  final double minimumPayment;
  final String currencyCode;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Monthly interest accrued on the current balance.
  double get monthlyInterest => balance * (interestRate / 100 / 12);

  DebtEntity copyWith({
    String? id,
    String? name,
    DebtType? type,
    double? balance,
    double? interestRate,
    double? minimumPayment,
    String? currencyCode,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DebtEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      interestRate: interestRate ?? this.interestRate,
      minimumPayment: minimumPayment ?? this.minimumPayment,
      currencyCode: currencyCode ?? this.currencyCode,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts a [DebtType] enum value to its database string representation.
  static String typeToString(DebtType type) {
    switch (type) {
      case DebtType.creditCard:
        return 'credit_card';
      case DebtType.autoLoan:
        return 'auto_loan';
      case DebtType.studentLoan:
        return 'student_loan';
      case DebtType.mortgage:
        return 'mortgage';
      case DebtType.personalLoan:
        return 'personal_loan';
      case DebtType.other:
        return 'other';
    }
  }

  /// Converts a database string to a [DebtType] enum value.
  static DebtType typeFromString(String value) {
    switch (value) {
      case 'credit_card':
        return DebtType.creditCard;
      case 'auto_loan':
        return DebtType.autoLoan;
      case 'student_loan':
        return DebtType.studentLoan;
      case 'mortgage':
        return DebtType.mortgage;
      case 'personal_loan':
        return DebtType.personalLoan;
      case 'other':
      default:
        return DebtType.other;
    }
  }

  /// Display-friendly name for a debt type.
  static String typeDisplayName(DebtType type) {
    switch (type) {
      case DebtType.creditCard:
        return 'Credit Card';
      case DebtType.autoLoan:
        return 'Auto Loan';
      case DebtType.studentLoan:
        return 'Student Loan';
      case DebtType.mortgage:
        return 'Mortgage';
      case DebtType.personalLoan:
        return 'Personal Loan';
      case DebtType.other:
        return 'Other';
    }
  }

  @override
  List<Object?> get props => [
        id, name, type, balance, interestRate, minimumPayment,
        currencyCode, notes, createdAt, updatedAt,
      ];
}
