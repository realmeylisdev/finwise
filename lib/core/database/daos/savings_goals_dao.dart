import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/savings_goals_table.dart';

part 'savings_goals_dao.g.dart';

@DriftAccessor(tables: [SavingsGoals])
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsGoalsDaoMixin {
  SavingsGoalsDao(super.db);

  Future<List<SavingsGoalRow>> getActiveGoals() =>
      (select(savingsGoals)
            ..where(
              (t) =>
                  t.isArchived.equals(false) &
                  t.isCompleted.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Stream<List<SavingsGoalRow>> watchActiveGoals() =>
      (select(savingsGoals)
            ..where(
              (t) =>
                  t.isArchived.equals(false) &
                  t.isCompleted.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<List<SavingsGoalRow>> getAllGoals() =>
      (select(savingsGoals)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([
              (t) => OrderingTerm.asc(t.isCompleted),
              (t) => OrderingTerm.asc(t.createdAt),
            ]))
          .get();

  Stream<List<SavingsGoalRow>> watchAllGoals() =>
      (select(savingsGoals)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([
              (t) => OrderingTerm.asc(t.isCompleted),
              (t) => OrderingTerm.asc(t.createdAt),
            ]))
          .watch();

  Future<SavingsGoalRow?> getGoalById(String id) =>
      (select(savingsGoals)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertGoal(SavingsGoalsCompanion entry) =>
      into(savingsGoals).insert(entry);

  Future<bool> updateGoal(SavingsGoalsCompanion entry) =>
      (update(savingsGoals)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteGoal(String id) =>
      (delete(savingsGoals)..where((t) => t.id.equals(id))).go();

  Future<void> contribute(String id, double amount) async {
    final goal = await getGoalById(id);
    if (goal == null) return;

    final newAmount = goal.savedAmount + amount;
    final isCompleted = newAmount >= goal.targetAmount;

    await (update(savingsGoals)..where((t) => t.id.equals(id))).write(
      SavingsGoalsCompanion(
        savedAmount: Value(newAmount),
        isCompleted: Value(isCompleted),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> withdraw(String id, double amount) async {
    final goal = await getGoalById(id);
    if (goal == null) return;

    final newAmount = (goal.savedAmount - amount).clamp(0.0, double.infinity);

    await (update(savingsGoals)..where((t) => t.id.equals(id))).write(
      SavingsGoalsCompanion(
        savedAmount: Value(newAmount),
        isCompleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
