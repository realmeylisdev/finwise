part of 'savings_goal_bloc.dart';

abstract class SavingsGoalEvent extends Equatable {
  const SavingsGoalEvent();
  @override
  List<Object?> get props => [];
}

class GoalsLoaded extends SavingsGoalEvent {
  const GoalsLoaded();
}

class GoalCreated extends SavingsGoalEvent {
  const GoalCreated(this.goal);
  final SavingsGoalEntity goal;
  @override
  List<Object?> get props => [goal];
}

class GoalDeleted extends SavingsGoalEvent {
  const GoalDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class GoalContributed extends SavingsGoalEvent {
  const GoalContributed({required this.id, required this.amount});
  final String id;
  final double amount;
  @override
  List<Object?> get props => [id, amount];
}

class GoalWithdrawn extends SavingsGoalEvent {
  const GoalWithdrawn({required this.id, required this.amount});
  final String id;
  final double amount;
  @override
  List<Object?> get props => [id, amount];
}

class GoalCelebrationAcknowledged extends SavingsGoalEvent {
  const GoalCelebrationAcknowledged();
}
