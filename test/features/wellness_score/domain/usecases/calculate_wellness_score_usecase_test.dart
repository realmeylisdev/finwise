import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/repositories/debt_payoff_repository.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:finwise/features/wellness_score/domain/usecases/calculate_wellness_score_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockDebtPayoffRepository extends Mock implements DebtPayoffRepository {}

void main() {
  late MockTransactionRepository mockTransactionRepo;
  late MockBudgetRepository mockBudgetRepo;
  late MockDebtPayoffRepository mockDebtPayoffRepo;
  late CalculateWellnessScoreUseCase useCase;

  setUp(() {
    mockTransactionRepo = MockTransactionRepository();
    mockBudgetRepo = MockBudgetRepository();
    mockDebtPayoffRepo = MockDebtPayoffRepository();
    useCase = CalculateWellnessScoreUseCase(
      transactionRepository: mockTransactionRepo,
      budgetRepository: mockBudgetRepo,
      debtPayoffRepository: mockDebtPayoffRepo,
    );
  });

  /// Helper to stub all repository calls with provided data.
  void stubRepositories({
    double totalIncome = 0,
    double totalExpense = 0,
    List<BudgetWithSpendingEntity> budgets = const [],
    List<DebtEntity> debts = const [],
    List<TransactionEntity> transactions = const [],
  }) {
    when(
      () => mockTransactionRepo.getTotalByType(
        'income',
        any(),
        any(),
      ),
    ).thenAnswer((_) async => Right(totalIncome));

    when(
      () => mockTransactionRepo.getTotalByType(
        'expense',
        any(),
        any(),
      ),
    ).thenAnswer((_) async => Right(totalExpense));

    when(
      () => mockBudgetRepo.getBudgetsForMonth(any(), any()),
    ).thenAnswer((_) async => Right(budgets));

    when(
      () => mockDebtPayoffRepo.getDebts(),
    ).thenAnswer((_) async => Right(debts));

    when(
      () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
    ).thenAnswer((_) async => Right(transactions));
  }

  group('CalculateWellnessScoreUseCase', () {
    test('returns score between 0 and 100', () async {
      stubRepositories(
        totalIncome: 5000,
        totalExpense: 3000,
      );

      final result = await useCase.call();

      expect(result.overallScore, greaterThanOrEqualTo(0));
      expect(result.overallScore, lessThanOrEqualTo(100));
    });

    group('savings score', () {
      test('high savings rate gives high savings score', () async {
        // Savings rate = (5000 - 2000) / 5000 = 60% -> score = 100
        stubRepositories(
          totalIncome: 5000,
          totalExpense: 2000,
        );

        final result = await useCase.call();

        // >= 20% savings rate -> savingsScore = 100
        expect(result.savingsScore, 100);
      });

      test('zero income gives savings score of 0', () async {
        stubRepositories(
          totalIncome: 0,
          totalExpense: 500,
        );

        final result = await useCase.call();

        expect(result.savingsScore, 0);
      });

      test('spending exceeding income gives savings score of 0', () async {
        stubRepositories(
          totalIncome: 3000,
          totalExpense: 4000,
        );

        final result = await useCase.call();

        // Savings rate = (3000-4000)/3000 = negative -> score = 0
        expect(result.savingsScore, 0);
      });

      test('10% savings rate gives score around 50', () async {
        // Savings rate = (5000 - 4500) / 5000 = 10%
        stubRepositories(
          totalIncome: 5000,
          totalExpense: 4500,
        );

        final result = await useCase.call();

        expect(result.savingsScore, 50);
      });

      test('15% savings rate gives score around 75', () async {
        // Savings rate = (5000 - 4250) / 5000 = 15%
        // Score: 50 + (0.15 - 0.10) / 0.10 * 50 = 50 + 25 = 75
        stubRepositories(
          totalIncome: 5000,
          totalExpense: 4250,
        );

        final result = await useCase.call();

        expect(result.savingsScore, 75);
      });
    });

    group('budget score', () {
      BudgetWithSpendingEntity makeBudget({
        required double amount,
        required double spent,
      }) {
        final now = DateTime.now();
        return BudgetWithSpendingEntity(
          budget: BudgetEntity(
            id: 'b_${amount.hashCode}',
            categoryId: 'cat_1',
            amount: amount,
            currencyCode: 'USD',
            year: now.year,
            month: now.month,
            createdAt: now,
            updatedAt: now,
          ),
          categoryName: 'Food',
          categoryIcon: 'food',
          categoryColor: 0xFF000000,
          spent: spent,
        );
      }

      test('all budgets under limit gives high budget score', () async {
        // 5 budgets all under limit:
        // coverageScore = min(5/5, 1.0) * 50 = 50
        // complianceScore = (5/5) * 50 = 50
        // total = 100
        stubRepositories(
          budgets: [
            makeBudget(amount: 500, spent: 400),
            makeBudget(amount: 300, spent: 200),
            makeBudget(amount: 200, spent: 100),
            makeBudget(amount: 400, spent: 350),
            makeBudget(amount: 600, spent: 500),
          ],
        );

        final result = await useCase.call();

        expect(result.budgetScore, 100);
      });

      test('no budgets gives score of 0', () async {
        stubRepositories(budgets: []);

        final result = await useCase.call();

        expect(result.budgetScore, 0);
      });

      test('some budgets over limit reduces compliance score', () async {
        // 2 budgets: 1 under, 1 over
        // coverageScore = min(2/5, 1.0) * 50 = 20
        // complianceScore = (1/2) * 50 = 25
        // total = 45
        stubRepositories(
          budgets: [
            makeBudget(amount: 500, spent: 400),
            makeBudget(amount: 300, spent: 400), // over budget
          ],
        );

        final result = await useCase.call();

        expect(result.budgetScore, 45);
      });
    });

    group('debt score', () {
      DebtEntity makeDebt({
        required double balance,
        required double minimumPayment,
        double interestRate = 18.0,
      }) {
        final now = DateTime.now();
        return DebtEntity(
          id: 'debt_${balance.hashCode}',
          name: 'Debt',
          type: DebtType.creditCard,
          balance: balance,
          interestRate: interestRate,
          minimumPayment: minimumPayment,
          currencyCode: 'USD',
          createdAt: now,
          updatedAt: now,
        );
      }

      test('no debts gives perfect debt score', () async {
        stubRepositories(
          totalIncome: 5000,
          debts: [],
        );

        final result = await useCase.call();

        expect(result.debtScore, 100);
      });

      test('low DTI ratio gives high debt score', () async {
        // DTI = 200/5000 = 4% < 20% -> score = 90
        stubRepositories(
          totalIncome: 5000,
          debts: [makeDebt(balance: 5000, minimumPayment: 200)],
        );

        final result = await useCase.call();

        expect(result.debtScore, 90);
      });

      test('high DTI ratio gives low debt score', () async {
        // DTI = 3000/5000 = 60% >= 50% -> score = 30
        stubRepositories(
          totalIncome: 5000,
          debts: [makeDebt(balance: 50000, minimumPayment: 3000)],
        );

        final result = await useCase.call();

        expect(result.debtScore, 30);
      });

      test('debts with zero income gives score of 30', () async {
        stubRepositories(
          totalIncome: 0,
          debts: [makeDebt(balance: 5000, minimumPayment: 200)],
        );

        final result = await useCase.call();

        expect(result.debtScore, 30);
      });
    });

    group('overall score', () {
      test('handles repository failures gracefully', () async {
        // When repositories return Left (failure), getOrElse defaults
        // kick in (0.0 for numbers, [] for lists)
        when(
          () => mockTransactionRepo.getTotalByType(
            'income',
            any(),
            any(),
          ),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure()),
        );
        when(
          () => mockTransactionRepo.getTotalByType(
            'expense',
            any(),
            any(),
          ),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure()),
        );
        when(
          () => mockBudgetRepo.getBudgetsForMonth(any(), any()),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure()),
        );
        when(
          () => mockDebtPayoffRepo.getDebts(),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure()),
        );
        when(
          () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure()),
        );

        final result = await useCase.call();

        // All defaults: income=0, expense=0, budgets=[], debts=[], txns=[]
        // savingsScore=0, budgetScore=0, debtScore=100, consistencyScore=0
        // overall = (0+0+100+0)/4 = 25
        expect(result.overallScore, 25);
        expect(result.overallScore, greaterThanOrEqualTo(0));
        expect(result.overallScore, lessThanOrEqualTo(100));
      });
    });
  });
}
