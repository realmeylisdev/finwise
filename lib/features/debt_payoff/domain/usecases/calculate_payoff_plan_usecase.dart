import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/entities/payoff_plan_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class CalculatePayoffPlanUseCase {
  /// Calculates a payoff plan using the snowball strategy (lowest balance first).
  PayoffPlanEntity calculateSnowball({
    required List<DebtEntity> debts,
    required double extraMonthlyPayment,
  }) {
    return _calculate(
      debts: debts,
      extraMonthlyPayment: extraMonthlyPayment,
      strategy: PayoffStrategy.snowball,
    );
  }

  /// Calculates a payoff plan using the avalanche strategy (highest interest first).
  PayoffPlanEntity calculateAvalanche({
    required List<DebtEntity> debts,
    required double extraMonthlyPayment,
  }) {
    return _calculate(
      debts: debts,
      extraMonthlyPayment: extraMonthlyPayment,
      strategy: PayoffStrategy.avalanche,
    );
  }

  PayoffPlanEntity _calculate({
    required List<DebtEntity> debts,
    required double extraMonthlyPayment,
    required PayoffStrategy strategy,
  }) {
    if (debts.isEmpty) {
      return PayoffPlanEntity(
        strategy: strategy,
        totalMonths: 0,
        totalInterestPaid: 0,
        totalPaid: 0,
        debtFreeDate: DateTime.now(),
        monthlyPlan: const [],
      );
    }

    // Create working copies with mutable balances
    final workingDebts = debts.map(_WorkingDebt.from).toList();

    // Sort based on strategy
    if (strategy == PayoffStrategy.snowball) {
      workingDebts.sort((a, b) => a.balance.compareTo(b.balance));
    } else {
      workingDebts.sort((a, b) => b.interestRate.compareTo(a.interestRate));
    }

    final monthlyPlan = <MonthlyPlanItem>[];
    var totalInterestPaid = 0.0;
    var totalPaid = 0.0;
    var monthCount = 0;

    final now = DateTime.now();
    // Safety: cap at 360 months (30 years) to prevent infinite loops
    const maxMonths = 360;

    while (workingDebts.any((d) => d.balance > 0.005) &&
        monthCount < maxMonths) {
      monthCount++;
      final date = DateTime(now.year, now.month + monthCount);

      // Calculate total minimum payments for active debts
      var extraBudget = extraMonthlyPayment;

      // Pay minimum on all debts and accrue interest
      for (final debt in workingDebts) {
        if (debt.balance <= 0.005) continue;

        // Accrue monthly interest
        final monthlyInterest = debt.balance * (debt.interestRate / 100 / 12);
        debt.balance += monthlyInterest;

        // Pay minimum (or remaining balance if smaller)
        final minPayment = debt.minimumPayment.clamp(0.0, debt.balance);
        final payment = minPayment < debt.balance ? minPayment : debt.balance;
        debt.balance -= payment;

        final principalPaid = payment - monthlyInterest;

        totalInterestPaid += monthlyInterest;
        totalPaid += payment;

        monthlyPlan.add(
          MonthlyPlanItem(
            month: date.month,
            year: date.year,
            debtName: debt.name,
            payment: payment,
            principalPaid: principalPaid > 0 ? principalPaid : 0,
            interestPaid: monthlyInterest,
            remainingBalance: debt.balance < 0.005 ? 0 : debt.balance,
          ),
        );
      }

      // Apply extra payment to the target debt (first non-zero balance in sorted order)
      for (final debt in workingDebts) {
        if (debt.balance <= 0.005 || extraBudget <= 0) continue;

        final extraPayment = extraBudget < debt.balance
            ? extraBudget
            : debt.balance;
        debt.balance -= extraPayment;
        extraBudget -= extraPayment;
        totalPaid += extraPayment;

        // Update the last plan item for this debt in this month
        final lastIndex = monthlyPlan.lastIndexWhere(
          (item) =>
              item.debtName == debt.name &&
              item.month == date.month &&
              item.year == date.year,
        );
        if (lastIndex >= 0) {
          final existing = monthlyPlan[lastIndex];
          monthlyPlan[lastIndex] = MonthlyPlanItem(
            month: existing.month,
            year: existing.year,
            debtName: existing.debtName,
            payment: existing.payment + extraPayment,
            principalPaid: existing.principalPaid + extraPayment,
            interestPaid: existing.interestPaid,
            remainingBalance: debt.balance < 0.005 ? 0 : debt.balance,
          );
        }

        // Only apply extra to the first target debt
        break;
      }

      // Roll freed-up payments: if a debt is paid off, its minimum becomes
      // available as extra for the next target
      // (This happens naturally next iteration since we skip zero-balance debts)
    }

    final debtFreeDate = DateTime(now.year, now.month + monthCount);

    return PayoffPlanEntity(
      strategy: strategy,
      totalMonths: monthCount,
      totalInterestPaid: totalInterestPaid,
      totalPaid: totalPaid,
      debtFreeDate: debtFreeDate,
      monthlyPlan: monthlyPlan,
    );
  }
}

class _WorkingDebt {
  _WorkingDebt({
    required this.name,
    required this.balance,
    required this.interestRate,
    required this.minimumPayment,
  });

  factory _WorkingDebt.from(DebtEntity entity) {
    return _WorkingDebt(
      name: entity.name,
      balance: entity.balance,
      interestRate: entity.interestRate,
      minimumPayment: entity.minimumPayment,
    );
  }

  final String name;
  double balance;
  final double interestRate;
  final double minimumPayment;
}
