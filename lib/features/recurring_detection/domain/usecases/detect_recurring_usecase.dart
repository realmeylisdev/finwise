import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/recurring_detection/domain/entities/recurring_pattern_entity.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DetectRecurringUseCase {
  DetectRecurringUseCase(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, List<RecurringPatternEntity>>> call() async {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);

    final result = await _repository.getTransactionsByDateRange(
      sixMonthsAgo,
      now,
    );

    return result.map((transactions) => _detectPatterns(transactions));
  }

  List<RecurringPatternEntity> _detectPatterns(
      List<TransactionEntity> transactions) {
    // Filter only expense transactions with a category
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense && t.categoryId != null)
        .toList();

    // Group by (amount rounded to 2 decimals, categoryId)
    final groups = <String, List<TransactionEntity>>{};
    for (final txn in expenses) {
      final key =
          '${txn.amount.toStringAsFixed(2)}_${txn.categoryId}';
      groups.putIfAbsent(key, () => []).add(txn);
    }

    final patterns = <RecurringPatternEntity>[];

    for (final group in groups.values) {
      if (group.length < 3) continue;

      // Sort by date ascending
      group.sort((a, b) => a.date.compareTo(b.date));

      // Calculate intervals in days between consecutive transactions
      final intervals = <int>[];
      for (var i = 1; i < group.length; i++) {
        intervals.add(group[i].date.difference(group[i - 1].date).inDays);
      }

      // Calculate median interval
      intervals.sort();
      final median = intervals.length.isOdd
          ? intervals[intervals.length ~/ 2].toDouble()
          : (intervals[intervals.length ~/ 2 - 1] +
                  intervals[intervals.length ~/ 2]) /
              2.0;

      final frequency = _classifyFrequency(median);
      if (frequency == RecurringFrequency.unknown) continue;

      final lastTxn = group.last;
      final nextExpected =
          lastTxn.date.add(Duration(days: median.round()));

      patterns.add(RecurringPatternEntity(
        categoryName: lastTxn.categoryName ?? 'Unknown',
        categoryIcon: lastTxn.categoryIcon,
        categoryColor: lastTxn.categoryColor,
        amount: lastTxn.amount,
        frequency: frequency,
        lastDate: lastTxn.date,
        nextExpectedDate: nextExpected,
        occurrences: group.length,
        note: lastTxn.note,
      ));
    }

    // Sort by amount descending (largest recurring expenses first)
    patterns.sort((a, b) => b.amount.compareTo(a.amount));

    return patterns;
  }

  RecurringFrequency _classifyFrequency(double medianDays) {
    if (medianDays >= 6 && medianDays <= 8) return RecurringFrequency.weekly;
    if (medianDays >= 13 && medianDays <= 16) return RecurringFrequency.biweekly;
    if (medianDays >= 27 && medianDays <= 34) return RecurringFrequency.monthly;
    if (medianDays >= 85 && medianDays <= 100) {
      return RecurringFrequency.quarterly;
    }
    if (medianDays >= 350 && medianDays <= 380) {
      return RecurringFrequency.yearly;
    }
    return RecurringFrequency.unknown;
  }
}
