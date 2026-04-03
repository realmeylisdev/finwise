import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/tables/shared_budgets_table.dart';

part 'shared_budgets_dao.g.dart';

@DriftAccessor(tables: [SharedBudgets])
class SharedBudgetsDao extends DatabaseAccessor<AppDatabase>
    with _$SharedBudgetsDaoMixin {
  SharedBudgetsDao(super.db);

  Future<List<SharedBudgetRow>> getSharedBudgets(String profileId) =>
      (select(sharedBudgets)..where((t) => t.profileId.equals(profileId)))
          .get();

  Future<List<SharedBudgetRow>> getSharesForBudget(String budgetId) =>
      (select(sharedBudgets)..where((t) => t.budgetId.equals(budgetId)))
          .get();

  Future<int> shareBudget(SharedBudgetsCompanion entry) =>
      into(sharedBudgets).insert(entry);

  Future<int> unshareBudget(String id) =>
      (delete(sharedBudgets)..where((t) => t.id.equals(id))).go();

  Future<int> unshareBudgetForProfile(String budgetId, String profileId) =>
      (delete(sharedBudgets)
            ..where((t) =>
                t.budgetId.equals(budgetId) &
                t.profileId.equals(profileId)))
          .go();
}
