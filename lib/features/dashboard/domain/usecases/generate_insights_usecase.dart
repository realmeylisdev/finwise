import 'package:finwise/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:finwise/features/dashboard/domain/entities/spending_insight.dart';
import 'package:injectable/injectable.dart';

@injectable
class GenerateInsightsUseCase {
  List<SpendingInsight> call(DashboardSummaryEntity summary) {
    final insights = <SpendingInsight>[];

    // 1. Savings rate insight
    if (summary.totalIncome > 0) {
      final savingsRate = (summary.totalIncome - summary.totalExpense) /
          summary.totalIncome *
          100;
      if (savingsRate >= 20) {
        insights.add(SpendingInsight(
          type: InsightType.positive,
          title: 'Great savings rate!',
          description:
              "You're saving ${savingsRate.toInt()}% of your income this month. Keep it up!",
        ));
      } else if (savingsRate > 0) {
        insights.add(SpendingInsight(
          type: InsightType.tip,
          title: 'Room to save more',
          description:
              'Your savings rate is ${savingsRate.toInt()}%. Try to reach 20% for financial health.',
        ));
      } else {
        insights.add(SpendingInsight(
          type: InsightType.warning,
          title: 'Spending exceeds income',
          description:
              "You've spent \$${(summary.totalExpense - summary.totalIncome).toStringAsFixed(0)} more than you earned this month.",
        ));
      }
    }

    // 2. Budget compliance
    final overBudgetCount =
        summary.budgets.where((b) => b.isOverBudget).length;
    if (overBudgetCount > 0) {
      insights.add(SpendingInsight(
        type: InsightType.warning,
        title: '$overBudgetCount budget${overBudgetCount > 1 ? 's' : ''}'
            ' exceeded',
        description: 'Review your spending to stay on track.',
      ));
    } else if (summary.budgets.isNotEmpty) {
      insights.add(const SpendingInsight(
        type: InsightType.positive,
        title: 'All budgets on track',
        description:
            "You're within budget across all categories. Nice work!",
      ));
    }

    // 3. Spending trend (compare first vs second half of daily spending)
    if (summary.dailySpending.length >= 14) {
      final firstHalf =
          summary.dailySpending.take(15).fold<double>(0, (a, b) => a + b);
      final secondHalf =
          summary.dailySpending.skip(15).fold<double>(0, (a, b) => a + b);
      if (secondHalf > firstHalf * 1.3 && firstHalf > 0) {
        insights.add(SpendingInsight(
          type: InsightType.warning,
          title: 'Spending is trending up',
          description:
              'Your recent spending is ${((secondHalf / firstHalf - 1) * 100).toInt()}% higher than earlier this month.',
        ));
      } else if (secondHalf < firstHalf * 0.7 && firstHalf > 0) {
        insights.add(const SpendingInsight(
          type: InsightType.positive,
          title: 'Spending is going down',
          description:
              'Great job! Your recent spending has decreased compared to earlier.',
        ));
      }
    }

    // 4. Upcoming bills warning
    final dueTodayCount =
        summary.upcomingBills.where((b) => b.isDueToday(DateTime.now().day)).length;
    if (dueTodayCount > 0) {
      insights.add(SpendingInsight(
        type: InsightType.warning,
        title: '$dueTodayCount bill${dueTodayCount > 1 ? 's' : ''} due today',
        description: "Don't forget to make your payments.",
      ));
    }

    // 5. Goal progress
    final nearCompleteGoals =
        summary.activeGoals.where((g) => g.percentComplete >= 0.8).toList();
    if (nearCompleteGoals.isNotEmpty) {
      insights.add(SpendingInsight(
        type: InsightType.positive,
        title: '${nearCompleteGoals.first.name} almost done!',
        description:
            "You're ${(nearCompleteGoals.first.percentComplete * 100).toInt()}% of the way to your goal.",
      ));
    }

    return insights.take(3).toList();
  }
}
