import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/entities/payoff_plan_entity.dart';
import 'package:finwise/features/debt_payoff/domain/usecases/calculate_payoff_plan_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculatePayoffPlanUseCase useCase;

  setUp(() {
    useCase = CalculatePayoffPlanUseCase();
  });

  DebtEntity makeDebt({
    required String name,
    required double balance,
    required double interestRate,
    required double minimumPayment,
  }) {
    final now = DateTime.now();
    return DebtEntity(
      id: 'debt_$name',
      name: name,
      type: DebtType.creditCard,
      balance: balance,
      interestRate: interestRate,
      minimumPayment: minimumPayment,
      currencyCode: 'USD',
      createdAt: now,
      updatedAt: now,
    );
  }

  group('CalculatePayoffPlanUseCase', () {
    group('snowball strategy', () {
      test('orders debts by lowest balance first', () {
        final debts = [
          makeDebt(
            name: 'Big Loan',
            balance: 10000,
            interestRate: 5,
            minimumPayment: 200,
          ),
          makeDebt(
            name: 'Small Card',
            balance: 500,
            interestRate: 20,
            minimumPayment: 25,
          ),
          makeDebt(
            name: 'Medium Loan',
            balance: 3000,
            interestRate: 10,
            minimumPayment: 100,
          ),
        ];

        final plan = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 100,
        );

        expect(plan.strategy, PayoffStrategy.snowball);
        expect(plan.totalMonths, greaterThan(0));

        // The first debt to appear in the monthly plan should be the
        // smallest balance ("Small Card") since snowball sorts by balance.
        // Extra payments target the first non-zero balance in sorted order.
        // Check that the first plan items include Small Card first in the
        // sorted order.
        final firstMonthItems = plan.monthlyPlan
            .where((item) => item.month == plan.monthlyPlan.first.month &&
                item.year == plan.monthlyPlan.first.year)
            .toList();
        final debtNames = firstMonthItems.map((i) => i.debtName).toList();
        // Snowball order: Small Card (500), Medium Loan (3000), Big Loan (10000)
        expect(debtNames.first, 'Small Card');
      });

      test('eventually pays off all debts', () {
        final debts = [
          makeDebt(
            name: 'Card A',
            balance: 2000,
            interestRate: 18,
            minimumPayment: 50,
          ),
          makeDebt(
            name: 'Card B',
            balance: 5000,
            interestRate: 12,
            minimumPayment: 100,
          ),
        ];

        final plan = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 0,
        );

        expect(plan.totalMonths, greaterThan(0));
        expect(plan.totalPaid, greaterThan(0));
        expect(plan.totalInterestPaid, greaterThan(0));

        // All debts should reach zero at the end
        final lastCardA = plan.monthlyPlan
            .lastWhere((item) => item.debtName == 'Card A');
        final lastCardB = plan.monthlyPlan
            .lastWhere((item) => item.debtName == 'Card B');
        expect(lastCardA.remainingBalance, 0);
        expect(lastCardB.remainingBalance, 0);
      });
    });

    group('avalanche strategy', () {
      test('orders debts by highest interest rate first', () {
        final debts = [
          makeDebt(
            name: 'Low Rate',
            balance: 5000,
            interestRate: 5,
            minimumPayment: 100,
          ),
          makeDebt(
            name: 'High Rate',
            balance: 3000,
            interestRate: 24,
            minimumPayment: 75,
          ),
          makeDebt(
            name: 'Med Rate',
            balance: 4000,
            interestRate: 12,
            minimumPayment: 80,
          ),
        ];

        final plan = useCase.calculateAvalanche(
          debts: debts,
          extraMonthlyPayment: 100,
        );

        expect(plan.strategy, PayoffStrategy.avalanche);
        expect(plan.totalMonths, greaterThan(0));

        // First items in sorted order: High Rate (24%), Med Rate (12%),
        // Low Rate (5%)
        final firstMonthItems = plan.monthlyPlan
            .where((item) => item.month == plan.monthlyPlan.first.month &&
                item.year == plan.monthlyPlan.first.year)
            .toList();
        final debtNames = firstMonthItems.map((i) => i.debtName).toList();
        expect(debtNames.first, 'High Rate');
      });

      test('eventually pays off all debts', () {
        final debts = [
          makeDebt(
            name: 'Card A',
            balance: 2000,
            interestRate: 18,
            minimumPayment: 50,
          ),
          makeDebt(
            name: 'Card B',
            balance: 5000,
            interestRate: 24,
            minimumPayment: 100,
          ),
        ];

        final plan = useCase.calculateAvalanche(
          debts: debts,
          extraMonthlyPayment: 0,
        );

        expect(plan.totalMonths, greaterThan(0));

        final lastCardA = plan.monthlyPlan
            .lastWhere((item) => item.debtName == 'Card A');
        final lastCardB = plan.monthlyPlan
            .lastWhere((item) => item.debtName == 'Card B');
        expect(lastCardA.remainingBalance, 0);
        expect(lastCardB.remainingBalance, 0);
      });
    });

    group('extra payments', () {
      test('extra payments reduce total months', () {
        final debts = [
          makeDebt(
            name: 'Card',
            balance: 5000,
            interestRate: 18,
            minimumPayment: 100,
          ),
        ];

        final planNoExtra = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 0,
        );
        final planWithExtra = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 200,
        );

        expect(planWithExtra.totalMonths, lessThan(planNoExtra.totalMonths));
      });

      test('extra payments reduce total interest paid', () {
        final debts = [
          makeDebt(
            name: 'Card',
            balance: 10000,
            interestRate: 20,
            minimumPayment: 200,
          ),
        ];

        final planNoExtra = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 0,
        );
        final planWithExtra = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 300,
        );

        expect(
          planWithExtra.totalInterestPaid,
          lessThan(planNoExtra.totalInterestPaid),
        );
      });
    });

    group('edge cases', () {
      test('zero debts returns empty plan', () {
        final plan = useCase.calculateSnowball(
          debts: [],
          extraMonthlyPayment: 100,
        );

        expect(plan.totalMonths, 0);
        expect(plan.totalInterestPaid, 0);
        expect(plan.totalPaid, 0);
        expect(plan.monthlyPlan, isEmpty);
      });

      test('zero debts returns empty plan for avalanche too', () {
        final plan = useCase.calculateAvalanche(
          debts: [],
          extraMonthlyPayment: 0,
        );

        expect(plan.totalMonths, 0);
        expect(plan.monthlyPlan, isEmpty);
      });

      test('single debt calculates correctly', () {
        final debts = [
          makeDebt(
            name: 'Only Debt',
            balance: 1000,
            interestRate: 12,
            minimumPayment: 100,
          ),
        ];

        final plan = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 0,
        );

        expect(plan.totalMonths, greaterThan(0));
        // With 12% APR and $100/month on $1000, should take ~11 months
        expect(plan.totalMonths, lessThan(15));

        final lastItem = plan.monthlyPlan.last;
        expect(lastItem.remainingBalance, 0);
      });

      test('avalanche saves more interest than snowball on mixed debts',
          () {
        // This is the classic demonstration: avalanche is cheaper
        // when there is a high-rate debt with larger balance.
        final debts = [
          makeDebt(
            name: 'Small Low Rate',
            balance: 1000,
            interestRate: 5,
            minimumPayment: 50,
          ),
          makeDebt(
            name: 'Large High Rate',
            balance: 10000,
            interestRate: 22,
            minimumPayment: 200,
          ),
        ];

        final snowball = useCase.calculateSnowball(
          debts: debts,
          extraMonthlyPayment: 100,
        );
        final avalanche = useCase.calculateAvalanche(
          debts: debts,
          extraMonthlyPayment: 100,
        );

        expect(
          avalanche.totalInterestPaid,
          lessThanOrEqualTo(snowball.totalInterestPaid),
        );
      });
    });
  });
}
