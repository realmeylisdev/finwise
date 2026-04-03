import 'dart:typed_data';

import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/reports/data/services/pdf_report_builder.dart';
import 'package:finwise/features/savings_goal/domain/repositories/savings_goal_repository.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class GenerateAnnualReportUseCase {
  GenerateAnnualReportUseCase({
    required TransactionRepository transactionRepository,
    required SavingsGoalRepository savingsGoalRepository,
    required PdfReportBuilder pdfReportBuilder,
  })  : _transactionRepo = transactionRepository,
        _savingsGoalRepo = savingsGoalRepository,
        _pdfBuilder = pdfReportBuilder;

  final TransactionRepository _transactionRepo;
  final SavingsGoalRepository _savingsGoalRepo;
  final PdfReportBuilder _pdfBuilder;

  Future<Either<Failure, Uint8List>> call({required int year}) async {
    try {
      final yearStart = DateTime(year);
      final yearEnd = DateTime(year + 1);

      // Fetch yearly totals and spending breakdown
      final incomeResult =
          await _transactionRepo.getTotalByType('income', yearStart, yearEnd);
      final expenseResult =
          await _transactionRepo.getTotalByType('expense', yearStart, yearEnd);
      final categoryResult =
          await _transactionRepo.getSpendingByCategory(yearStart, yearEnd);
      final goalsResult = await _savingsGoalRepo.getGoals();

      final totalIncome = incomeResult.getOrElse((_) => 0.0);
      final totalExpense = expenseResult.getOrElse((_) => 0.0);
      final spendingByCategory = categoryResult.getOrElse((_) => {});
      final savingsGoals = goalsResult.getOrElse((_) => []);

      // Build monthly breakdown
      final monthlyBreakdown = <MonthlyBreakdown>[];
      for (var m = 1; m <= 12; m++) {
        final mStart = DateTime(year, m);
        final mEnd = DateTime(year, m + 1);

        // If the month is in the future, skip
        if (mStart.isAfter(DateTime.now())) break;

        final mIncomeResult =
            await _transactionRepo.getTotalByType('income', mStart, mEnd);
        final mExpenseResult =
            await _transactionRepo.getTotalByType('expense', mStart, mEnd);

        final mIncome = mIncomeResult.getOrElse((_) => 0.0);
        final mExpense = mExpenseResult.getOrElse((_) => 0.0);

        monthlyBreakdown.add(MonthlyBreakdown(
          monthName: DateFormat.MMMM().format(DateTime(year, m)),
          income: mIncome,
          expense: mExpense,
        ));
      }

      final pdfBytes = await _pdfBuilder.buildAnnualReport(
        year: year,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        spendingByCategory: spendingByCategory,
        monthlyBreakdown: monthlyBreakdown,
        savingsGoals: savingsGoals,
      );

      return Right(pdfBytes);
    } catch (e) {
      return Left(UnknownFailure(message: 'Report generation failed: $e'));
    }
  }
}
