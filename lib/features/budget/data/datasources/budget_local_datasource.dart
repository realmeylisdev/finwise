import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/budgets_dao.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class BudgetLocalDatasource {
  BudgetLocalDatasource(this._dao);

  final BudgetsDao _dao;

  Future<List<BudgetWithSpendingEntity>> getBudgetsForMonth(
    int year,
    int month,
  ) async {
    final rows = await _dao.getBudgetsForMonth(year, month);
    final results = <BudgetWithSpendingEntity>[];

    for (final row in rows) {
      final spent = await _dao.getSpentForBudget(
        row.category.id,
        year,
        month,
      );
      results.add(
        BudgetWithSpendingEntity(
          budget: _toBudgetEntity(row.budget),
          categoryName: row.category.name,
          categoryIcon: row.category.icon,
          categoryColor: row.category.color,
          spent: spent,
        ),
      );
    }
    return results;
  }

  Future<BudgetEntity?> getBudgetById(String id) async {
    final row = await _dao.getBudgetById(id);
    return row == null ? null : _toBudgetEntity(row);
  }

  Future<void> insertBudget(BudgetEntity entity) async {
    await _dao.insertBudget(
      BudgetsCompanion.insert(
        id: entity.id,
        categoryId: entity.categoryId,
        amount: entity.amount,
        currencyCode: entity.currencyCode,
        year: entity.year,
        month: entity.month,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateBudget(BudgetEntity entity) async {
    await _dao.updateBudget(
      BudgetsCompanion(
        id: Value(entity.id),
        categoryId: Value(entity.categoryId),
        amount: Value(entity.amount),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteBudget(String id) async {
    await _dao.deleteBudget(id);
  }

  BudgetEntity _toBudgetEntity(BudgetRow row) {
    return BudgetEntity(
      id: row.id,
      categoryId: row.categoryId,
      amount: row.amount,
      currencyCode: row.currencyCode,
      year: row.year,
      month: row.month,
      rolloverAmount: row.rolloverAmount,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
