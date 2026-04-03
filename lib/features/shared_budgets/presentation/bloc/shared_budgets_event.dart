part of 'shared_budgets_bloc.dart';

abstract class SharedBudgetsEvent extends Equatable {
  const SharedBudgetsEvent();
  @override
  List<Object?> get props => [];
}

class SharedBudgetsLoaded extends SharedBudgetsEvent {
  const SharedBudgetsLoaded(this.budgetId);
  final String budgetId;
  @override
  List<Object?> get props => [budgetId];
}

class BudgetShared extends SharedBudgetsEvent {
  const BudgetShared(this.share);
  final SharedBudgetEntity share;
  @override
  List<Object?> get props => [share];
}

class BudgetUnshared extends SharedBudgetsEvent {
  const BudgetUnshared({required this.budgetId, required this.profileId});
  final String budgetId;
  final String profileId;
  @override
  List<Object?> get props => [budgetId, profileId];
}
