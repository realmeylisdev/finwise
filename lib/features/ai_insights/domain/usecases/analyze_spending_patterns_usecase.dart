import 'package:finwise/features/ai_insights/domain/entities/ai_insight_entity.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:finwise/shared/extensions/date_extensions.dart';
import 'package:injectable/injectable.dart';

@injectable
class AnalyzeSpendingPatternsUseCase {
  AnalyzeSpendingPatternsUseCase({
    required TransactionRepository transactionRepository,
  }) : _transactionRepo = transactionRepository;

  final TransactionRepository _transactionRepo;

  Future<List<AiInsightEntity>> call() async {
    final now = DateTime.now();
    final thisMonthStart = now.startOfMonth;
    final thisMonthEnd = now.endOfMonth;
    final lastMonthStart = DateTime(now.year, now.month - 1).startOfMonth;
    final lastMonthEnd = DateTime(now.year, now.month - 1).endOfMonth;

    // Fetch transactions for this month and last month
    final thisMonthResult = await _transactionRepo.getTransactionsByDateRange(
      thisMonthStart,
      thisMonthEnd,
    );
    final lastMonthResult = await _transactionRepo.getTransactionsByDateRange(
      lastMonthStart,
      lastMonthEnd,
    );

    final thisMonthTxns = thisMonthResult.getOrElse((_) => []);
    final lastMonthTxns = lastMonthResult.getOrElse((_) => []);

    final insights = <AiInsightEntity>[];
    var idCounter = 0;

    String nextId() => 'sp_${idCounter++}';

    final thisMonthExpenses = thisMonthTxns
        .where((t) => t.type == TransactionType.expense)
        .toList();
    final lastMonthExpenses = lastMonthTxns
        .where((t) => t.type == TransactionType.expense)
        .toList();

    // 1. Month-over-month changes per category
    insights.addAll(
      _analyzeMonthOverMonth(
        thisMonthExpenses,
        lastMonthExpenses,
        now,
        nextId,
      ),
    );

    // 2. Unusual spending days
    insights.addAll(
      _analyzeUnusualDays(thisMonthExpenses, now, nextId),
    );

    // 3. Spending velocity
    insights.addAll(
      _analyzeSpendingVelocity(
        thisMonthExpenses,
        lastMonthExpenses,
        now,
        nextId,
      ),
    );

    // 4. Category concentration
    insights.addAll(
      _analyzeCategoryConcentration(thisMonthExpenses, now, nextId),
    );

    // 5. Weekend vs weekday spending
    insights.addAll(
      _analyzeWeekendVsWeekday(thisMonthExpenses, now, nextId),
    );

    // Sort by severity: warning first, then positive, then info
    insights.sort((a, b) {
      const order = {
        InsightSeverity.warning: 0,
        InsightSeverity.positive: 1,
        InsightSeverity.info: 2,
      };
      return order[a.severity]!.compareTo(order[b.severity]!);
    });

    return insights.take(10).toList();
  }

  List<AiInsightEntity> _analyzeMonthOverMonth(
    List<TransactionEntity> thisMonth,
    List<TransactionEntity> lastMonth,
    DateTime now,
    String Function() nextId,
  ) {
    final insights = <AiInsightEntity>[];

    // Group by category
    final thisMonthByCategory = _groupByCategory(thisMonth);
    final lastMonthByCategory = _groupByCategory(lastMonth);

    // Combine all category keys
    final allCategories = {
      ...thisMonthByCategory.keys,
      ...lastMonthByCategory.keys,
    };

    for (final catKey in allCategories) {
      final thisTotal = thisMonthByCategory[catKey]?.total ?? 0;
      final lastTotal = lastMonthByCategory[catKey]?.total ?? 0;

      if (lastTotal <= 0) continue;

      final change = ((thisTotal - lastTotal) / lastTotal) * 100;

      if (change > 20) {
        final catName =
            thisMonthByCategory[catKey]?.name ??
            lastMonthByCategory[catKey]?.name ??
            'Unknown';
        insights.add(AiInsightEntity(
          id: nextId(),
          category: InsightCategory.trend,
          severity: InsightSeverity.warning,
          title: '$catName spending increased',
          description:
              'Your $catName spending rose ${change.toStringAsFixed(0)}% '
              'compared to last month (\$${lastTotal.toStringAsFixed(0)} '
              'to \$${thisTotal.toStringAsFixed(0)}).',
          amount: thisTotal,
          percentChange: change,
          categoryName: catName,
          createdAt: now,
        ));
      } else if (change < -20) {
        final catName =
            thisMonthByCategory[catKey]?.name ??
            lastMonthByCategory[catKey]?.name ??
            'Unknown';
        insights.add(AiInsightEntity(
          id: nextId(),
          category: InsightCategory.trend,
          severity: InsightSeverity.positive,
          title: '$catName spending decreased',
          description:
              'Great job! Your $catName spending dropped '
              '${change.abs().toStringAsFixed(0)}% '
              'compared to last month.',
          amount: thisTotal,
          percentChange: change,
          categoryName: catName,
          createdAt: now,
        ));
      }
    }

    return insights;
  }

  List<AiInsightEntity> _analyzeUnusualDays(
    List<TransactionEntity> expenses,
    DateTime now,
    String Function() nextId,
  ) {
    final insights = <AiInsightEntity>[];
    if (expenses.isEmpty) return insights;

    // Group by day
    final dailyTotals = <int, double>{};
    for (final txn in expenses) {
      final day = txn.date.day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + txn.amount;
    }

    if (dailyTotals.isEmpty) return insights;

    final dailyValues = dailyTotals.values.toList();
    final avgDaily =
        dailyValues.reduce((a, b) => a + b) / dailyValues.length;

    for (final entry in dailyTotals.entries) {
      if (entry.value > avgDaily * 2 && avgDaily > 0) {
        insights.add(AiInsightEntity(
          id: nextId(),
          category: InsightCategory.anomaly,
          severity: InsightSeverity.warning,
          title: 'Unusual spending on day ${entry.key}',
          description:
              'You spent \$${entry.value.toStringAsFixed(0)} on '
              '${now.month}/${entry.key}, which is more than double '
              'your daily average of \$${avgDaily.toStringAsFixed(0)}.',
          amount: entry.value,
          createdAt: now,
        ));
      }
    }

    return insights;
  }

  List<AiInsightEntity> _analyzeSpendingVelocity(
    List<TransactionEntity> thisMonthExpenses,
    List<TransactionEntity> lastMonthExpenses,
    DateTime now,
    String Function() nextId,
  ) {
    final insights = <AiInsightEntity>[];

    final lastMonthTotal = lastMonthExpenses.fold<double>(
      0,
      (sum, t) => sum + t.amount,
    );
    if (lastMonthTotal <= 0) return insights;

    // First half of month spending
    final midMonth = 15;
    final firstHalfSpending = thisMonthExpenses
        .where((t) => t.date.day <= midMonth)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final velocityRatio = firstHalfSpending / lastMonthTotal;

    if (velocityRatio > 0.60 && now.day <= 20) {
      insights.add(AiInsightEntity(
        id: nextId(),
        category: InsightCategory.forecast,
        severity: InsightSeverity.warning,
        title: 'Spending pace is high',
        description:
            'You\'ve already spent ${(velocityRatio * 100).toStringAsFixed(0)}% '
            'of last month\'s total in the first half of this month. '
            'Consider slowing down to stay on track.',
        amount: firstHalfSpending,
        percentChange: velocityRatio * 100,
        createdAt: now,
      ));
    }

    return insights;
  }

  List<AiInsightEntity> _analyzeCategoryConcentration(
    List<TransactionEntity> expenses,
    DateTime now,
    String Function() nextId,
  ) {
    final insights = <AiInsightEntity>[];
    if (expenses.isEmpty) return insights;

    final totalSpending = expenses.fold<double>(0, (sum, t) => sum + t.amount);
    if (totalSpending <= 0) return insights;

    final byCategory = _groupByCategory(expenses);

    for (final entry in byCategory.entries) {
      final ratio = entry.value.total / totalSpending;
      if (ratio > 0.50) {
        insights.add(AiInsightEntity(
          id: nextId(),
          category: InsightCategory.recommendation,
          severity: InsightSeverity.info,
          title: 'High concentration in ${entry.value.name}',
          description:
              '${(ratio * 100).toStringAsFixed(0)}% of your spending is '
              'in ${entry.value.name}. Consider reviewing if this aligns '
              'with your financial goals.',
          amount: entry.value.total,
          percentChange: ratio * 100,
          categoryName: entry.value.name,
          createdAt: now,
        ));
      }
    }

    return insights;
  }

  List<AiInsightEntity> _analyzeWeekendVsWeekday(
    List<TransactionEntity> expenses,
    DateTime now,
    String Function() nextId,
  ) {
    final insights = <AiInsightEntity>[];
    if (expenses.isEmpty) return insights;

    var weekendTotal = 0.0;
    var weekdayTotal = 0.0;
    final weekendDays = <int>{};
    final weekdayDays = <int>{};

    for (final txn in expenses) {
      final isWeekend =
          txn.date.weekday == DateTime.saturday ||
          txn.date.weekday == DateTime.sunday;
      if (isWeekend) {
        weekendTotal += txn.amount;
        weekendDays.add(txn.date.day);
      } else {
        weekdayTotal += txn.amount;
        weekdayDays.add(txn.date.day);
      }
    }

    if (weekendDays.isEmpty || weekdayDays.isEmpty) return insights;

    final avgWeekend = weekendTotal / weekendDays.length;
    final avgWeekday = weekdayTotal / weekdayDays.length;

    if (avgWeekday > 0 && avgWeekend > avgWeekday * 2) {
      insights.add(AiInsightEntity(
        id: nextId(),
        category: InsightCategory.recommendation,
        severity: InsightSeverity.warning,
        title: 'Weekend spending is high',
        description:
            'You spend an average of \$${avgWeekend.toStringAsFixed(0)} '
            'per weekend day vs \$${avgWeekday.toStringAsFixed(0)} on '
            'weekdays. Look for ways to reduce weekend expenses.',
        amount: avgWeekend,
        createdAt: now,
      ));
    }

    return insights;
  }

  Map<String, _CategoryTotal> _groupByCategory(
    List<TransactionEntity> transactions,
  ) {
    final map = <String, _CategoryTotal>{};
    for (final txn in transactions) {
      final key = txn.categoryId ?? 'uncategorized';
      final name = txn.categoryName ?? 'Uncategorized';
      if (map.containsKey(key)) {
        map[key] = _CategoryTotal(name, map[key]!.total + txn.amount);
      } else {
        map[key] = _CategoryTotal(name, txn.amount);
      }
    }
    return map;
  }
}

class _CategoryTotal {
  const _CategoryTotal(this.name, this.total);
  final String name;
  final double total;
}
