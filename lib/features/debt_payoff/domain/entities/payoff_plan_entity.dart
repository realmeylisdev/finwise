import 'package:equatable/equatable.dart';

enum PayoffStrategy { snowball, avalanche }

class MonthlyPlanItem extends Equatable {
  const MonthlyPlanItem({
    required this.month,
    required this.year,
    required this.debtName,
    required this.payment,
    required this.principalPaid,
    required this.interestPaid,
    required this.remainingBalance,
  });

  final int month;
  final int year;
  final String debtName;
  final double payment;
  final double principalPaid;
  final double interestPaid;
  final double remainingBalance;

  @override
  List<Object?> get props => [
        month, year, debtName, payment,
        principalPaid, interestPaid, remainingBalance,
      ];
}

class PayoffPlanEntity extends Equatable {
  const PayoffPlanEntity({
    required this.strategy,
    required this.totalMonths,
    required this.totalInterestPaid,
    required this.totalPaid,
    required this.debtFreeDate,
    required this.monthlyPlan,
  });

  final PayoffStrategy strategy;
  final int totalMonths;
  final double totalInterestPaid;
  final double totalPaid;
  final DateTime debtFreeDate;
  final List<MonthlyPlanItem> monthlyPlan;

  @override
  List<Object?> get props => [
        strategy, totalMonths, totalInterestPaid,
        totalPaid, debtFreeDate, monthlyPlan,
      ];
}
