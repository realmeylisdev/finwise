import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/budgets_table.dart';
import '../tables/categories_table.dart';
import '../tables/transactions_table.dart';

part 'budgets_dao.g.dart';

class BudgetWithCategory {
  const BudgetWithCategory({
    required this.budget,
    required this.category,
  });

  final BudgetRow budget;
  final CategoryRow category;
}

@DriftAccessor(tables: [Budgets, Categories, Transactions])
class BudgetsDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  Future<List<BudgetWithCategory>> getBudgetsForMonth(
    int year,
    int month,
  ) async {
    final query = select(budgets).join([
      innerJoin(
        categories,
        categories.id.equalsExp(budgets.categoryId),
      ),
    ])
      ..where(
        budgets.year.equals(year) & budgets.month.equals(month),
      );

    final rows = await query.get();
    return rows.map((row) {
      return BudgetWithCategory(
        budget: row.readTable(budgets),
        category: row.readTable(categories),
      );
    }).toList();
  }

  Stream<List<BudgetWithCategory>> watchBudgetsForMonth(
    int year,
    int month,
  ) {
    final query = select(budgets).join([
      innerJoin(
        categories,
        categories.id.equalsExp(budgets.categoryId),
      ),
    ])
      ..where(
        budgets.year.equals(year) & budgets.month.equals(month),
      );

    return query.watch().map(
          (rows) => rows.map((row) {
            return BudgetWithCategory(
              budget: row.readTable(budgets),
              category: row.readTable(categories),
            );
          }).toList(),
        );
  }

  Future<BudgetRow?> getBudgetById(String id) =>
      (select(budgets)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertBudget(BudgetsCompanion entry) =>
      into(budgets).insert(entry);

  Future<bool> updateBudget(BudgetsCompanion entry) =>
      (update(budgets)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteBudget(String id) =>
      (delete(budgets)..where((t) => t.id.equals(id))).go();

  Future<double> getSpentForBudget(
    String categoryId,
    int year,
    int month,
  ) async {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);

    final sum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([sum])
      ..where(
        transactions.categoryId.equals(categoryId) &
            transactions.type.equals('expense') &
            transactions.date.isBiggerOrEqualValue(start) &
            transactions.date.isSmallerOrEqualValue(end),
      );

    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }
}
