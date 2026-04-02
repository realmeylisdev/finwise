import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/savings_goals_dao.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class SavingsGoalLocalDatasource {
  SavingsGoalLocalDatasource(this._dao);

  final SavingsGoalsDao _dao;

  Future<List<SavingsGoalEntity>> getGoals() async {
    final rows = await _dao.getAllGoals();
    return rows.map(_toEntity).toList();
  }

  Future<SavingsGoalEntity?> getGoalById(String id) async {
    final row = await _dao.getGoalById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> insertGoal(SavingsGoalEntity entity) async {
    await _dao.insertGoal(
      SavingsGoalsCompanion.insert(
        id: entity.id,
        name: entity.name,
        targetAmount: entity.targetAmount,
        savedAmount: Value(entity.savedAmount),
        currencyCode: entity.currencyCode,
        deadline: Value(entity.deadline),
        icon: entity.icon,
        color: entity.color,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateGoal(SavingsGoalEntity entity) async {
    await _dao.updateGoal(
      SavingsGoalsCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        targetAmount: Value(entity.targetAmount),
        deadline: Value(entity.deadline),
        icon: Value(entity.icon),
        color: Value(entity.color),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteGoal(String id) async {
    await _dao.deleteGoal(id);
  }

  Future<void> contribute(String id, double amount) async {
    await _dao.contribute(id, amount);
  }

  Future<void> withdraw(String id, double amount) async {
    await _dao.withdraw(id, amount);
  }

  SavingsGoalEntity _toEntity(SavingsGoalRow row) {
    return SavingsGoalEntity(
      id: row.id,
      name: row.name,
      targetAmount: row.targetAmount,
      savedAmount: row.savedAmount,
      currencyCode: row.currencyCode,
      deadline: row.deadline,
      icon: row.icon,
      color: row.color,
      isCompleted: row.isCompleted,
      isArchived: row.isArchived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
