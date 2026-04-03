import 'package:equatable/equatable.dart';

enum BillingCycle { weekly, monthly, quarterly, yearly }

class SubscriptionEntity extends Equatable {
  const SubscriptionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.currencyCode,
    required this.billingCycle,
    required this.nextBillingDate,
    this.categoryId,
    this.icon = 'subscription',
    this.color = 0xFF6366F1,
    this.isActive = true,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final double amount;
  final String currencyCode;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final String? categoryId;
  final String icon;
  final int color;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Converts the subscription amount to its monthly equivalent.
  double get monthlyAmount {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return amount * 52 / 12;
      case BillingCycle.monthly:
        return amount;
      case BillingCycle.quarterly:
        return amount / 3;
      case BillingCycle.yearly:
        return amount / 12;
    }
  }

  /// Converts the subscription amount to its yearly equivalent.
  double get yearlyAmount {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return amount * 52;
      case BillingCycle.monthly:
        return amount * 12;
      case BillingCycle.quarterly:
        return amount * 4;
      case BillingCycle.yearly:
        return amount;
    }
  }

  /// Number of days until the next billing date.
  int get daysUntilNextBilling {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final billing = DateTime(
      nextBillingDate.year,
      nextBillingDate.month,
      nextBillingDate.day,
    );
    return billing.difference(today).inDays;
  }

  SubscriptionEntity copyWith({
    String? id,
    String? name,
    double? amount,
    String? currencyCode,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    String? categoryId,
    String? icon,
    int? color,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      categoryId: categoryId ?? this.categoryId,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts a [BillingCycle] enum value to its string representation.
  static String cycleToString(BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.weekly:
        return 'weekly';
      case BillingCycle.monthly:
        return 'monthly';
      case BillingCycle.quarterly:
        return 'quarterly';
      case BillingCycle.yearly:
        return 'yearly';
    }
  }

  /// Converts a string to a [BillingCycle] enum value.
  static BillingCycle cycleFromString(String value) {
    switch (value) {
      case 'weekly':
        return BillingCycle.weekly;
      case 'quarterly':
        return BillingCycle.quarterly;
      case 'yearly':
        return BillingCycle.yearly;
      case 'monthly':
      default:
        return BillingCycle.monthly;
    }
  }

  /// Display-friendly name for a billing cycle.
  static String cycleDisplayName(BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.weekly:
        return 'Weekly';
      case BillingCycle.monthly:
        return 'Monthly';
      case BillingCycle.quarterly:
        return 'Quarterly';
      case BillingCycle.yearly:
        return 'Yearly';
    }
  }

  @override
  List<Object?> get props => [
        id, name, amount, currencyCode, billingCycle,
        nextBillingDate, categoryId, icon, color,
        isActive, notes, createdAt, updatedAt,
      ];
}
