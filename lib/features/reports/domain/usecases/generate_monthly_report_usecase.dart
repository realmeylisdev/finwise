import 'dart:typed_data';

import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:finwise/features/reports/data/services/pdf_report_builder.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GenerateMonthlyReportUseCase {
  GenerateMonthlyReportUseCase({
    required TransactionRepository transactionRepository,
    required BudgetRepository budgetRepository,
    required PdfReportBuilder pdfReportBuilder,
  })  : _transactionRepo = transactionRepository,
        _budgetRepo = budgetRepository,
        _pdfBuilder = pdfReportBuilder;

  final TransactionRepository _transactionRepo;
  final BudgetRepository _budgetRepo;
  final PdfReportBuilder _pdfBuilder;

  Future<Either<Failure, Uint8List>> call({
    required int year,
    required int month,
  }) async {
    try {
      final start = DateTime(year, month);
      final end = DateTime(year, month + 1);

      // Fetch data
      final transactionsResult =
          await _transactionRepo.getTransactionsByDateRange(start, end);
      final incomeResult =
          await _transactionRepo.getTotalByType('income', start, end);
      final expenseResult =
          await _transactionRepo.getTotalByType('expense', start, end);
      final categoryResult =
          await _transactionRepo.getSpendingByCategory(start, end);
      final budgetsResult =
          await _budgetRepo.getBudgetsForMonth(year, month);

      // Check for failures
      if (transactionsResult.isLeft()) {
        return Left(
          transactionsResult.getLeft().getOrElse(
                () => const DatabaseFailure(message: 'Failed to load data'),
              ),
        );
      }

      final transactions = transactionsResult.getOrElse((_) => []);
      final totalIncome = incomeResult.getOrElse((_) => 0.0);
      final totalExpense = expenseResult.getOrElse((_) => 0.0);
      final spendingByCategory = categoryResult.getOrElse((_) => {});
      final budgets = budgetsResult.getOrElse((_) => []);

      final pdfBytes = await _pdfBuilder.buildMonthlyReport(
        year: year,
        month: month,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        spendingByCategory: spendingByCategory,
        transactions: transactions,
        budgets: budgets,
      );

      return Right(pdfBytes);
    } catch (e) {
      return Left(UnknownFailure(message: 'Report generation failed: $e'));
    }
  }
}
