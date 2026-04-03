import 'dart:typed_data';

import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

@injectable
class PdfReportBuilder {
  // ---------------------------------------------------------------------------
  // Monthly report
  // ---------------------------------------------------------------------------
  Future<Uint8List> buildMonthlyReport({
    required int year,
    required int month,
    required double totalIncome,
    required double totalExpense,
    required Map<String, double> spendingByCategory,
    required List<TransactionEntity> transactions,
    required List<BudgetWithSpendingEntity> budgets,
  }) async {
    final doc = pw.Document();
    final monthName = DateFormat.MMMM().format(DateTime(year, month));
    final generatedAt = DateFormat.yMMMd().add_jm().format(DateTime.now());
    final netSavings = totalIncome - totalExpense;
    final currencyFmt = NumberFormat.currency(symbol: r'$');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(
          'FinWise Monthly Report',
          '$monthName $year',
        ),
        footer: (context) => _buildFooter(generatedAt, context),
        build: (context) => [
          // Summary
          _sectionTitle('Summary'),
          _summaryTable(totalIncome, totalExpense, netSavings, currencyFmt),
          pw.SizedBox(height: 20),

          // Spending by Category
          if (spendingByCategory.isNotEmpty) ...[
            _sectionTitle('Spending by Category'),
            _categoryTable(spendingByCategory, totalExpense, currencyFmt),
            pw.SizedBox(height: 20),
          ],

          // Top 5 transactions
          if (transactions.isNotEmpty) ...[
            _sectionTitle('Top 5 Transactions by Amount'),
            _topTransactionsTable(transactions, currencyFmt),
            pw.SizedBox(height: 20),
          ],

          // Budget compliance
          if (budgets.isNotEmpty) ...[
            _sectionTitle('Budget Compliance'),
            _budgetComplianceTable(budgets, currencyFmt),
          ],
        ],
      ),
    );

    return doc.save();
  }

  // ---------------------------------------------------------------------------
  // Annual report
  // ---------------------------------------------------------------------------
  Future<Uint8List> buildAnnualReport({
    required int year,
    required double totalIncome,
    required double totalExpense,
    required Map<String, double> spendingByCategory,
    required List<MonthlyBreakdown> monthlyBreakdown,
    required List<SavingsGoalEntity> savingsGoals,
  }) async {
    final doc = pw.Document();
    final generatedAt = DateFormat.yMMMd().add_jm().format(DateTime.now());
    final netSavings = totalIncome - totalExpense;
    final currencyFmt = NumberFormat.currency(symbol: r'$');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(
          'FinWise Annual Report',
          '$year',
        ),
        footer: (context) => _buildFooter(generatedAt, context),
        build: (context) => [
          // Summary
          _sectionTitle('Year Summary'),
          _summaryTable(totalIncome, totalExpense, netSavings, currencyFmt),
          pw.SizedBox(height: 20),

          // Monthly breakdown
          if (monthlyBreakdown.isNotEmpty) ...[
            _sectionTitle('Monthly Breakdown'),
            _monthlyBreakdownTable(monthlyBreakdown, currencyFmt),
            pw.SizedBox(height: 20),
          ],

          // Spending by Category
          if (spendingByCategory.isNotEmpty) ...[
            _sectionTitle('Spending by Category'),
            _categoryTable(spendingByCategory, totalExpense, currencyFmt),
            pw.SizedBox(height: 20),
          ],

          // Savings Goals
          if (savingsGoals.isNotEmpty) ...[
            _sectionTitle('Savings Goals Progress'),
            _savingsGoalsTable(savingsGoals, currencyFmt),
          ],
        ],
      ),
    );

    return doc.save();
  }

  // ---------------------------------------------------------------------------
  // Shared widgets
  // ---------------------------------------------------------------------------
  pw.Widget _buildHeader(String title, String subtitle) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.indigo, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.indigo,
            ),
          ),
          pw.Text(
            subtitle,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(String generatedAt, pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by FinWise on $generatedAt',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  pw.Widget _summaryTable(
    double income,
    double expense,
    double net,
    NumberFormat fmt,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: [
        _tableRow('Total Income', fmt.format(income), PdfColors.green700),
        _tableRow('Total Expenses', fmt.format(expense), PdfColors.red700),
        _tableRow(
          'Net Savings',
          fmt.format(net),
          net >= 0 ? PdfColors.green700 : PdfColors.red700,
          bold: true,
        ),
      ],
    );
  }

  pw.TableRow _tableRow(
    String label,
    String value,
    PdfColor valueColor, {
    bool bold = false,
  }) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _categoryTable(
    Map<String, double> spending,
    double total,
    NumberFormat fmt,
  ) {
    final sorted = spending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.all(6),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
      },
      headers: ['Category', 'Amount', '%'],
      data: sorted.map((e) {
        final pct = total > 0 ? (e.value / total * 100) : 0.0;
        return [
          e.key,
          fmt.format(e.value),
          '${pct.toStringAsFixed(1)}%',
        ];
      }).toList(),
    );
  }

  pw.Widget _topTransactionsTable(
    List<TransactionEntity> transactions,
    NumberFormat fmt,
  ) {
    final top5 = (transactions.toList()
          ..sort((a, b) => b.amount.compareTo(a.amount)))
        .take(5)
        .toList();

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.all(6),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
      headers: ['Date', 'Category', 'Note', 'Amount'],
      data: top5.map((t) {
        return [
          DateFormat.MMMd().format(t.date),
          t.categoryName ?? '-',
          t.note ?? '-',
          fmt.format(t.amount),
        ];
      }).toList(),
    );
  }

  pw.Widget _budgetComplianceTable(
    List<BudgetWithSpendingEntity> budgets,
    NumberFormat fmt,
  ) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.all(6),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.center,
      },
      headers: ['Category', 'Budget', 'Spent', 'Remaining', 'Status'],
      data: budgets.map((b) {
        final status = b.isOverBudget ? 'Over' : 'OK';
        return [
          b.categoryName,
          fmt.format(b.budget.amount),
          fmt.format(b.spent),
          fmt.format(b.remaining),
          status,
        ];
      }).toList(),
    );
  }

  pw.Widget _monthlyBreakdownTable(
    List<MonthlyBreakdown> breakdown,
    NumberFormat fmt,
  ) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.all(6),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      headers: ['Month', 'Income', 'Expenses', 'Net'],
      data: breakdown.map((m) {
        return [
          m.monthName,
          fmt.format(m.income),
          fmt.format(m.expense),
          fmt.format(m.net),
        ];
      }).toList(),
    );
  }

  pw.Widget _savingsGoalsTable(
    List<SavingsGoalEntity> goals,
    NumberFormat fmt,
  ) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.all(6),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      headers: ['Goal', 'Saved', 'Target', 'Progress'],
      data: goals.map((g) {
        return [
          g.name,
          fmt.format(g.savedAmount),
          fmt.format(g.targetAmount),
          '${(g.percentComplete * 100).toStringAsFixed(1)}%',
        ];
      }).toList(),
    );
  }
}

/// Data holder for the monthly breakdown rows in the annual report.
class MonthlyBreakdown {
  const MonthlyBreakdown({
    required this.monthName,
    required this.income,
    required this.expense,
  });

  final String monthName;
  final double income;
  final double expense;

  double get net => income - expense;
}

