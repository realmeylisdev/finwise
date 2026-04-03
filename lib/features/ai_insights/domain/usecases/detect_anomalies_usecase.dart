import 'dart:math' as math;

import 'package:finwise/features/ai_insights/domain/entities/ai_insight_entity.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DetectAnomaliesUseCase {
  DetectAnomaliesUseCase({
    required TransactionRepository transactionRepository,
  }) : _transactionRepo = transactionRepository;

  final TransactionRepository _transactionRepo;

  Future<List<AiInsightEntity>> call() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final result = await _transactionRepo.getTransactionsByDateRange(
      thirtyDaysAgo,
      now,
    );

    final transactions = result.getOrElse((_) => []);
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    if (expenses.isEmpty) return [];

    // Group by category
    final byCategory = <String, List<TransactionEntity>>{};
    for (final txn in expenses) {
      final key = txn.categoryId ?? 'uncategorized';
      byCategory.putIfAbsent(key, () => []).add(txn);
    }

    final insights = <AiInsightEntity>[];
    var idCounter = 0;

    for (final entry in byCategory.entries) {
      final categoryTxns = entry.value;
      if (categoryTxns.length < 3) continue; // Need enough data points

      final amounts = categoryTxns.map((t) => t.amount).toList();
      final mean = amounts.reduce((a, b) => a + b) / amounts.length;
      final variance = amounts
              .map((a) => math.pow(a - mean, 2))
              .reduce((a, b) => a + b) /
          amounts.length;
      final stdDev = math.sqrt(variance);

      if (stdDev <= 0) continue;

      final threshold = mean + 2 * stdDev;

      for (final txn in categoryTxns) {
        if (txn.amount > threshold) {
          final catName = txn.categoryName ?? 'Uncategorized';
          insights.add(AiInsightEntity(
            id: 'anomaly_${idCounter++}',
            category: InsightCategory.anomaly,
            severity: InsightSeverity.warning,
            title: 'Unusual $catName transaction',
            description:
                'A \$${txn.amount.toStringAsFixed(2)} $catName transaction '
                'on ${txn.date.month}/${txn.date.day} is significantly '
                'higher than the category average of '
                '\$${mean.toStringAsFixed(2)}.',
            amount: txn.amount,
            percentChange:
                mean > 0 ? ((txn.amount - mean) / mean) * 100 : null,
            categoryName: catName,
            createdAt: now,
          ));
        }
      }
    }

    // Sort by amount descending
    insights.sort(
      (a, b) => (b.amount ?? 0).compareTo(a.amount ?? 0),
    );

    return insights;
  }
}
