import 'package:equatable/equatable.dart';

enum LiabilityType {
  mortgage,
  carLoan,
  studentLoan,
  creditCard,
  personalLoan,
  other,
}

class LiabilityEntity extends Equatable {
  const LiabilityEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.interestRate = 0,
    this.minimumPayment = 0,
    required this.currencyCode,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final LiabilityType type;
  final double balance;
  final double interestRate;
  final double minimumPayment;
  final String currencyCode;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  LiabilityEntity copyWith({
    String? id,
    String? name,
    LiabilityType? type,
    double? balance,
    double? interestRate,
    double? minimumPayment,
    String? currencyCode,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LiabilityEntity(
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

  static LiabilityType typeFromString(String value) {
    switch (value) {
      case 'mortgage':
        return LiabilityType.mortgage;
      case 'car_loan':
        return LiabilityType.carLoan;
      case 'student_loan':
        return LiabilityType.studentLoan;
      case 'credit_card':
        return LiabilityType.creditCard;
      case 'personal_loan':
        return LiabilityType.personalLoan;
      default:
        return LiabilityType.other;
    }
  }

  static String typeToString(LiabilityType type) {
    switch (type) {
      case LiabilityType.mortgage:
        return 'mortgage';
      case LiabilityType.carLoan:
        return 'car_loan';
      case LiabilityType.studentLoan:
        return 'student_loan';
      case LiabilityType.creditCard:
        return 'credit_card';
      case LiabilityType.personalLoan:
        return 'personal_loan';
      case LiabilityType.other:
        return 'other';
    }
  }

  static String typeDisplayName(LiabilityType type) {
    switch (type) {
      case LiabilityType.mortgage:
        return 'Mortgage';
      case LiabilityType.carLoan:
        return 'Car Loan';
      case LiabilityType.studentLoan:
        return 'Student Loan';
      case LiabilityType.creditCard:
        return 'Credit Card';
      case LiabilityType.personalLoan:
        return 'Personal';
      case LiabilityType.other:
        return 'Other';
    }
  }

  @override
  List<Object?> get props => [
        id, name, type, balance, interestRate, minimumPayment,
        currencyCode, notes, createdAt, updatedAt,
      ];
}
