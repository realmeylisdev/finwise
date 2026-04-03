import 'package:finwise/features/shared_budgets/domain/entities/shared_budget_entity.dart';
import 'package:injectable/injectable.dart';

/// In-memory datasource for shared budgets.
///
/// TODO(batch-4.4): Replace with DAO-backed datasource once [SharedBudgetsDao]
/// is registered in [AppDatabase] and schema v10 migration is added.
@singleton
class SharedBudgetLocalDatasource {
  final List<SharedBudgetEntity> _store = [];

  Future<List<SharedBudgetEntity>> getSharesForBudget(
    String budgetId,
  ) async {
    return _store.where((s) => s.budgetId == budgetId).toList();
  }

  Future<void> shareBudget(SharedBudgetEntity share) async {
    // Remove existing share for same budget+profile, then add new one
    _store.removeWhere(
      (s) => s.budgetId == share.budgetId && s.profileId == share.profileId,
    );
    _store.add(share);
  }

  Future<void> unshareBudget(String budgetId, String profileId) async {
    _store.removeWhere(
      (s) => s.budgetId == budgetId && s.profileId == profileId,
    );
  }
}
