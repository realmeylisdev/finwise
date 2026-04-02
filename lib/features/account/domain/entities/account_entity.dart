import 'package:equatable/equatable.dart';

enum AccountType { bank, cash, creditCard, savings }

class AccountEntity extends Equatable {
  const AccountEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currencyCode,
    this.icon,
    this.color,
    this.includeInTotal = true,
    this.isArchived = false,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String currencyCode;
  final String? icon;
  final int? color;
  final bool includeInTotal;
  final bool isArchived;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountEntity copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    String? currencyCode,
    String? icon,
    int? color,
    bool? includeInTotal,
    bool? isArchived,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currencyCode: currencyCode ?? this.currencyCode,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      includeInTotal: includeInTotal ?? this.includeInTotal,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get typeLabel {
    switch (type) {
      case AccountType.bank:
        return 'Bank';
      case AccountType.cash:
        return 'Cash';
      case AccountType.creditCard:
        return 'Credit Card';
      case AccountType.savings:
        return 'Savings';
    }
  }

  static AccountType typeFromString(String value) {
    switch (value) {
      case 'bank':
        return AccountType.bank;
      case 'cash':
        return AccountType.cash;
      case 'credit_card':
        return AccountType.creditCard;
      case 'savings':
        return AccountType.savings;
      default:
        return AccountType.bank;
    }
  }

  static String typeToString(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return 'bank';
      case AccountType.cash:
        return 'cash';
      case AccountType.creditCard:
        return 'credit_card';
      case AccountType.savings:
        return 'savings';
    }
  }

  @override
  List<Object?> get props => [
        id, name, type, balance, currencyCode,
        icon, color, includeInTotal, isArchived,
        sortOrder, createdAt, updatedAt,
      ];
}
