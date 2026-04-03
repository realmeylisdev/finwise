import 'package:finwise/core/database/daos/transactions_dao.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/notifications/domain/entities/notification_entity.dart';
import 'package:finwise/features/notifications/domain/repositories/notification_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class GenerateWeeklyDigestUseCase {
  GenerateWeeklyDigestUseCase(
    this._transactionsDao,
    this._notificationRepository,
  );

  final TransactionsDao _transactionsDao;
  final NotificationRepository _notificationRepository;

  Future<Either<Failure, NotificationEntity>> call() async {
    try {
      final now = DateTime.now();
      final thisWeekStart = now.subtract(Duration(days: now.weekday));
      final thisWeekEnd = now;

      final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
      final lastWeekEnd = thisWeekStart;

      // Fetch this week's transactions
      final thisWeekTxns = await _transactionsDao.getTransactionsByDateRange(
        thisWeekStart,
        thisWeekEnd,
      );

      // Fetch last week's transactions
      final lastWeekTxns = await _transactionsDao.getTransactionsByDateRange(
        lastWeekStart,
        lastWeekEnd,
      );

      // Calculate totals
      double thisWeekSpent = 0;
      final categorySpending = <String, double>{};

      for (final txn in thisWeekTxns) {
        if (txn.transaction.type == 'expense') {
          thisWeekSpent += txn.transaction.amount;
          final catName = txn.category?.name ?? 'Uncategorized';
          categorySpending[catName] =
              (categorySpending[catName] ?? 0) + txn.transaction.amount;
        }
      }

      double lastWeekSpent = 0;
      for (final txn in lastWeekTxns) {
        if (txn.transaction.type == 'expense') {
          lastWeekSpent += txn.transaction.amount;
        }
      }

      // Top spending category
      String topCategory = 'None';
      if (categorySpending.isNotEmpty) {
        topCategory = categorySpending.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }

      // Comparison
      String comparison;
      if (lastWeekSpent == 0) {
        comparison = 'No data from last week to compare.';
      } else {
        final diff =
            ((thisWeekSpent - lastWeekSpent) / lastWeekSpent * 100).abs();
        final direction = thisWeekSpent > lastWeekSpent ? 'up' : 'down';
        comparison =
            'Spending is $direction ${diff.toStringAsFixed(1)}% vs last week.';
      }

      // Build body
      final body = StringBuffer()
        ..writeln(
            'You spent \$${thisWeekSpent.toStringAsFixed(2)} this week.')
        ..writeln('Top category: $topCategory.')
        ..write(comparison);

      final notification = NotificationEntity(
        id: const Uuid().v4(),
        type: NotificationType.weeklyDigest,
        title: 'Weekly Spending Digest',
        body: body.toString(),
        createdAt: now,
      );

      final result =
          await _notificationRepository.createNotification(notification);

      return result.fold(
        (failure) => Left(failure),
        (_) => Right(notification),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
