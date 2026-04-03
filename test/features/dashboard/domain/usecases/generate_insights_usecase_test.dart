import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:finwise/features/dashboard/domain/entities/spending_insight.dart';
import 'package:finwise/features/dashboard/domain/usecases/generate_insights_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GenerateInsightsUseCase useCase;

  setUp(() {
    useCase = GenerateInsightsUseCase();
  });

  BudgetWithSpendingEntity makeBudget({
    required double amount,
    required double spent,
    String name = 'Food',
  }) {
    final now = DateTime.now();
    return BudgetWithSpendingEntity(
      budget: BudgetEntity(
        id: 'b_${name.hashCode}',
        categoryId: 'cat_1',
        amount: amount,
        currencyCode: 'USD',
        year: now.year,
        month: now.month,
        createdAt: now,
        updatedAt: now,
      ),
      categoryName: name,
      categoryIcon: 'food',
      categoryColor: 0xFF000000,
      spent: spent,
    );
  }

  group('GenerateInsightsUseCase', () {
    test('returns empty list when no data', () {
      const summary = DashboardSummaryEntity();

      final insights = useCase.call(summary);

      expect(insights, isEmpty);
    });

    group('savings rate insights', () {
      test('generates savings rate insight when income > 0', () {
        const summary = DashboardSummaryEntity(
          totalIncome: 5000,
          totalExpense: 4000,
        );

        final insights = useCase.call(summary);

        expect(insights, isNotEmpty);
        // 20% savings rate -> positive insight
        expect(
          insights.any((i) => i.type == InsightType.positive ||
              i.type == InsightType.tip),
          isTrue,
        );
      });

      test('positive insight when savings rate >= 20%', () {
        const summary = DashboardSummaryEntity(
          totalIncome: 5000,
          totalExpense: 3500, // 30% savings rate
        );

        final insights = useCase.call(summary);

        final savingsInsight = insights.firstWhere(
          (i) => i.title.contains('savings rate'),
          orElse: () => const SpendingInsight(
            type: InsightType.tip,
            title: '',
            description: '',
          ),
        );

        expect(savingsInsight.type, InsightType.positive);
        expect(savingsInsight.title, contains('Great savings rate'));
      });

      test('tip insight when savings rate is positive but below 20%', () {
        const summary = DashboardSummaryEntity(
          totalIncome: 5000,
          totalExpense: 4500, // 10% savings rate
        );

        final insights = useCase.call(summary);

        final savingsInsight = insights.firstWhere(
          (i) => i.title.contains('save more'),
          orElse: () => const SpendingInsight(
            type: InsightType.positive,
            title: '',
            description: '',
          ),
        );

        expect(savingsInsight.type, InsightType.tip);
        expect(savingsInsight.title, contains('Room to save more'));
      });

      test('warning when spending exceeds income', () {
        const summary = DashboardSummaryEntity(
          totalIncome: 3000,
          totalExpense: 4000,
        );

        final insights = useCase.call(summary);

        final warningInsight = insights.firstWhere(
          (i) => i.title.contains('exceeds income'),
          orElse: () => const SpendingInsight(
            type: InsightType.positive,
            title: '',
            description: '',
          ),
        );

        expect(warningInsight.type, InsightType.warning);
        expect(warningInsight.title, 'Spending exceeds income');
        expect(warningInsight.description, contains('1000'));
      });
    });

    group('budget compliance insights', () {
      test('budget exceeded warning when budgets are over', () {
        final summary = DashboardSummaryEntity(
          totalIncome: 5000,
          totalExpense: 3000,
          budgets: [
            makeBudget(amount: 500, spent: 600), // over budget
            makeBudget(amount: 300, spent: 200, name: 'Transport'),
          ],
        );

        final insights = useCase.call(summary);

        final budgetInsight = insights.firstWhere(
          (i) => i.title.contains('exceeded'),
          orElse: () => const SpendingInsight(
            type: InsightType.positive,
            title: '',
            description: '',
          ),
        );

        expect(budgetInsight.type, InsightType.warning);
        expect(budgetInsight.title, contains('1 budget'));
        expect(budgetInsight.title, contains('exceeded'));
      });

      test('multiple budgets exceeded shows correct count', () {
        final summary = DashboardSummaryEntity(
          totalIncome: 5000,
          totalExpense: 3000,
          budgets: [
            makeBudget(amount: 500, spent: 600),
            makeBudget(amount: 300, spent: 400, name: 'Transport'),
            makeBudget(amount: 200, spent: 100, name: 'Entertainment'),
          ],
        );

        final insights = useCase.call(summary);

        final budgetInsight = insights.firstWhere(
          (i) => i.title.contains('exceeded'),
          orElse: () => const SpendingInsight(
            type: InsightType.positive,
            title: '',
            description: '',
          ),
        );

        expect(budgetInsight.title, contains('2 budgets'));
      });

      test('all budgets on track gives positive insight', () {
        final summary = DashboardSummaryEntity(
          totalIncome: 5000,
          totalExpense: 3000,
          budgets: [
            makeBudget(amount: 500, spent: 400),
            makeBudget(amount: 300, spent: 200, name: 'Transport'),
          ],
        );

        final insights = useCase.call(summary);

        final budgetInsight = insights.firstWhere(
          (i) => i.title.contains('on track'),
          orElse: () => const SpendingInsight(
            type: InsightType.warning,
            title: '',
            description: '',
          ),
        );

        expect(budgetInsight.type, InsightType.positive);
        expect(budgetInsight.title, 'All budgets on track');
      });
    });

    group('output limits', () {
      test('returns at most 3 insights', () {
        // Provide a summary that would generate many insights
        final summary = DashboardSummaryEntity(
          totalIncome: 5000,
          totalExpense: 3000,
          budgets: [
            makeBudget(amount: 500, spent: 600), // over budget
          ],
          // 30+ daily spending entries to trigger trend insight
          dailySpending: [
            ...List.filled(15, 100.0), // first half
            ...List.filled(15, 200.0), // second half (trending up)
          ],
        );

        final insights = useCase.call(summary);

        expect(insights.length, lessThanOrEqualTo(3));
      });
    });
  });
}
