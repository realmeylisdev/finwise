import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:finwise/features/bill_reminder/domain/repositories/bill_reminder_repository.dart';
import 'package:finwise/features/cash_flow/domain/entities/cash_flow_projection_entity.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GenerateForecastUseCase {
  GenerateForecastUseCase({
    required AccountRepository accountRepository,
    required BillReminderRepository billReminderRepository,
    required TransactionRepository transactionRepository,
  })  : _accountRepository = accountRepository,
        _billReminderRepository = billReminderRepository,
        _transactionRepository = transactionRepository;

  final AccountRepository _accountRepository;
  final BillReminderRepository _billReminderRepository;
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, CashFlowProjectionEntity>> call() async {
    // 1. Get current total balance
    final balanceResult = await _accountRepository.getTotalBalance();
    if (balanceResult.isLeft()) {
      return Left(balanceResult.getLeft().toNullable() ??
          const DatabaseFailure(message: 'Failed to get balance'));
    }
    final currentBalance = balanceResult.getOrElse((_) => 0);

    // 2. Get all active bill reminders
    final billsResult = await _billReminderRepository.getActiveBills();
    final bills = billsResult.getOrElse((_) => []);

    // 3. Get last 3 months of transactions to detect income patterns
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    final transactionsResult =
        await _transactionRepository.getTransactionsByDateRange(
      threeMonthsAgo,
      now,
    );
    final transactions = transactionsResult.getOrElse((_) => []);

    // Detect monthly income: look for recurring income transactions
    final incomeTransactions = transactions
        .where((t) => t.type == TransactionType.income)
        .toList();

    // Group income by approximate day-of-month to detect patterns
    final incomeByDay = <int, List<double>>{};
    for (final txn in incomeTransactions) {
      final day = txn.date.day;
      incomeByDay.putIfAbsent(day, () => []).add(txn.amount);
    }

    // Find recurring income: days that appear in at least 2 of the 3 months
    final recurringIncome = <int, double>{};
    for (final entry in incomeByDay.entries) {
      if (entry.value.length >= 2) {
        // Use the average amount
        final avgAmount =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
        recurringIncome[entry.key] = avgAmount;
      }
    }

    // Calculate average daily discretionary spending
    // Total expenses minus bill amounts, divided by days in the period
    final totalExpenseResult = await _transactionRepository.getTotalByType(
      'expense',
      threeMonthsAgo,
      now,
    );
    final totalExpenses = totalExpenseResult.getOrElse((_) => 0);

    // Sum of monthly bill amounts over 3 months
    final totalBillAmounts =
        bills.fold<double>(0, (sum, b) => sum + b.amount) * 3;

    final daysPeriod = now.difference(threeMonthsAgo).inDays;
    final discretionaryTotal =
        (totalExpenses - totalBillAmounts).clamp(0, double.infinity);
    final avgDailyDiscretionary =
        daysPeriod > 0 ? discretionaryTotal / daysPeriod : 0.0;

    // 4. Project 30 days forward
    final projections = <DailyProjection>[];
    var runningBalance = currentBalance;
    var lowestBalance = currentBalance;
    var lowestBalanceDate = now;

    for (var i = 1; i <= 30; i++) {
      final date = DateTime(now.year, now.month, now.day + i);
      var incoming = 0.0;
      var outgoing = 0.0;

      // Check for recurring income on this day of month
      if (recurringIncome.containsKey(date.day)) {
        incoming += recurringIncome[date.day]!;
      }

      // Check for bill due dates
      for (final bill in bills) {
        if (bill.dueDay == date.day && bill.isActive) {
          outgoing += bill.amount;
        }
      }

      // Add average daily discretionary spending
      outgoing += avgDailyDiscretionary;

      runningBalance = runningBalance + incoming - outgoing;

      projections.add(DailyProjection(
        date: date,
        projectedBalance: runningBalance,
        incoming: incoming,
        outgoing: outgoing,
      ));

      if (runningBalance < lowestBalance) {
        lowestBalance = runningBalance;
        lowestBalanceDate = date;
      }
    }

    return Right(CashFlowProjectionEntity(
      startBalance: currentBalance,
      projections: projections,
      lowestBalance: lowestBalance,
      lowestBalanceDate: lowestBalanceDate,
      endBalance: runningBalance,
    ));
  }
}
