import 'package:finwise/features/ai_insights/domain/entities/ai_insight_entity.dart';
import 'package:finwise/features/ai_insights/domain/usecases/detect_anomalies_usecase.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late MockTransactionRepository mockTransactionRepo;
  late DetectAnomaliesUseCase useCase;

  setUp(() {
    mockTransactionRepo = MockTransactionRepository();
    useCase = DetectAnomaliesUseCase(
      transactionRepository: mockTransactionRepo,
    );
  });

  TransactionEntity makeExpense({
    required double amount,
    String categoryId = 'cat_food',
    String categoryName = 'Food',
    DateTime? date,
  }) {
    final now = DateTime.now();
    final txnDate = date ?? now;
    return TransactionEntity(
      id: 'txn_${amount.hashCode}_${txnDate.hashCode}',
      amount: amount,
      type: TransactionType.expense,
      categoryId: categoryId,
      accountId: 'acc_1',
      date: txnDate,
      currencyCode: 'USD',
      createdAt: now,
      updatedAt: now,
      categoryName: categoryName,
    );
  }

  TransactionEntity makeIncome({required double amount}) {
    final now = DateTime.now();
    return TransactionEntity(
      id: 'txn_income_${amount.hashCode}',
      amount: amount,
      type: TransactionType.income,
      categoryId: 'cat_salary',
      accountId: 'acc_1',
      date: now,
      currencyCode: 'USD',
      createdAt: now,
      updatedAt: now,
      categoryName: 'Salary',
    );
  }

  group('DetectAnomaliesUseCase', () {
    test('returns empty list when no transactions', () async {
      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase.call();

      expect(result, isEmpty);
    });

    test('returns empty list when only income transactions', () async {
      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer(
        (_) async => Right([
          makeIncome(amount: 5000),
          makeIncome(amount: 3000),
        ]),
      );

      final result = await useCase.call();

      expect(result, isEmpty);
    });

    test('returns empty list when fewer than 3 transactions per category',
        () async {
      // Need at least 3 data points per category to detect anomalies
      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer(
        (_) async => Right([
          makeExpense(amount: 50),
          makeExpense(amount: 60),
        ]),
      );

      final result = await useCase.call();

      expect(result, isEmpty);
    });

    test('does not flag normal transactions', () async {
      // All similar amounts -- nothing should be >2 std devs above mean
      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer(
        (_) async => Right([
          makeExpense(amount: 50),
          makeExpense(amount: 52),
          makeExpense(amount: 48),
          makeExpense(amount: 51),
          makeExpense(amount: 49),
        ]),
      );

      final result = await useCase.call();

      expect(result, isEmpty);
    });

    test('detects transactions >2 std deviations above mean', () async {
      // Normal expenses around 50, then one huge outlier at 500
      // Mean ~ (50+50+50+50+500)/5 = 140
      // Variance is large, but 500 should still exceed mean + 2*stdDev
      // Let's use tight clustering to make the anomaly obvious
      final now = DateTime.now();
      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer(
        (_) async => Right([
          makeExpense(
            amount: 30,
            date: now.subtract(const Duration(days: 5)),
          ),
          makeExpense(
            amount: 32,
            date: now.subtract(const Duration(days: 4)),
          ),
          makeExpense(
            amount: 28,
            date: now.subtract(const Duration(days: 3)),
          ),
          makeExpense(
            amount: 31,
            date: now.subtract(const Duration(days: 2)),
          ),
          makeExpense(
            amount: 29,
            date: now.subtract(const Duration(days: 1)),
          ),
          // Outlier: ~10x the normal amount
          makeExpense(amount: 300, date: now),
        ]),
      );

      final result = await useCase.call();

      expect(result, isNotEmpty);
      expect(result.length, 1);
      expect(result.first.category, InsightCategory.anomaly);
      expect(result.first.severity, InsightSeverity.warning);
      expect(result.first.amount, 300);
      expect(result.first.title, contains('Food'));
    });

    test('detects anomalies per category independently', () async {
      final now = DateTime.now();
      // Food category: normal around 30, anomaly at 300
      final foodTxns = [
        makeExpense(
          amount: 30,
          date: now.subtract(const Duration(days: 5)),
        ),
        makeExpense(
          amount: 32,
          date: now.subtract(const Duration(days: 4)),
        ),
        makeExpense(
          amount: 28,
          date: now.subtract(const Duration(days: 3)),
        ),
        makeExpense(amount: 300, date: now),
      ];

      // Transport category: normal around 20, anomaly at 200
      final transportTxns = [
        makeExpense(
          amount: 20,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now.subtract(const Duration(days: 5)),
        ),
        makeExpense(
          amount: 22,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now.subtract(const Duration(days: 4)),
        ),
        makeExpense(
          amount: 18,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now.subtract(const Duration(days: 3)),
        ),
        makeExpense(
          amount: 200,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now,
        ),
      ];

      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer(
        (_) async => Right([...foodTxns, ...transportTxns]),
      );

      final result = await useCase.call();

      expect(result.length, 2);

      final categoryNames = result.map((i) => i.categoryName).toSet();
      expect(categoryNames, contains('Food'));
      expect(categoryNames, contains('Transport'));
    });

    test('results are sorted by amount descending', () async {
      final now = DateTime.now();
      final txns = [
        // Food: normal ~30, anomaly 300
        makeExpense(
          amount: 30,
          date: now.subtract(const Duration(days: 5)),
        ),
        makeExpense(
          amount: 32,
          date: now.subtract(const Duration(days: 4)),
        ),
        makeExpense(
          amount: 28,
          date: now.subtract(const Duration(days: 3)),
        ),
        makeExpense(amount: 300, date: now),
        // Transport: normal ~20, anomaly 500
        makeExpense(
          amount: 20,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now.subtract(const Duration(days: 5)),
        ),
        makeExpense(
          amount: 22,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now.subtract(const Duration(days: 4)),
        ),
        makeExpense(
          amount: 18,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now.subtract(const Duration(days: 3)),
        ),
        makeExpense(
          amount: 500,
          categoryId: 'cat_transport',
          categoryName: 'Transport',
          date: now,
        ),
      ];

      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer((_) async => Right(txns));

      final result = await useCase.call();

      expect(result.length, 2);
      // Transport anomaly (500) should come first, then Food (300)
      expect(result.first.amount, 500);
      expect(result.last.amount, 300);
    });

    test('insight contains correct metadata', () async {
      final now = DateTime.now();
      when(
        () => mockTransactionRepo.getTransactionsByDateRange(any(), any()),
      ).thenAnswer(
        (_) async => Right([
          makeExpense(
            amount: 30,
            date: now.subtract(const Duration(days: 5)),
          ),
          makeExpense(
            amount: 32,
            date: now.subtract(const Duration(days: 4)),
          ),
          makeExpense(
            amount: 28,
            date: now.subtract(const Duration(days: 3)),
          ),
          makeExpense(amount: 300, date: now),
        ]),
      );

      final result = await useCase.call();

      expect(result, isNotEmpty);
      final insight = result.first;
      expect(insight.id, startsWith('anomaly_'));
      expect(insight.category, InsightCategory.anomaly);
      expect(insight.severity, InsightSeverity.warning);
      expect(insight.title, contains('Unusual'));
      expect(insight.title, contains('Food'));
      expect(insight.description, contains('300.00'));
      expect(insight.amount, 300);
      expect(insight.percentChange, isNotNull);
      expect(insight.percentChange!, greaterThan(0));
      expect(insight.categoryName, 'Food');
    });
  });
}
