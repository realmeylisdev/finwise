part of 'budget_bloc.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();
  @override
  List<Object?> get props => [];
}

class BudgetsLoaded extends BudgetEvent {
  const BudgetsLoaded({required this.year, required this.month});
  final int year;
  final int month;
  @override
  List<Object?> get props => [year, month];
}

class BudgetCreated extends BudgetEvent {
  const BudgetCreated(this.budget);
  final BudgetEntity budget;
  @override
  List<Object?> get props => [budget];
}

class BudgetUpdated extends BudgetEvent {
  const BudgetUpdated(this.budget);
  final BudgetEntity budget;
  @override
  List<Object?> get props => [budget];
}

class BudgetDeleted extends BudgetEvent {
  const BudgetDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class BudgetMonthChanged extends BudgetEvent {
  const BudgetMonthChanged({required this.year, required this.month});
  final int year;
  final int month;
  @override
  List<Object?> get props => [year, month];
}
