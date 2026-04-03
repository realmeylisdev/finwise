part of 'savings_goal_bloc.dart';

enum SavingsGoalStatus { initial, loading, success, failure }

class SavingsGoalState extends Equatable {
  const SavingsGoalState({
    this.status = SavingsGoalStatus.initial,
    this.goals = const [],
    this.failureMessage,
    this.goalJustCompleted = false,
  });

  final SavingsGoalStatus status;
  final List<SavingsGoalEntity> goals;
  final String? failureMessage;
  final bool goalJustCompleted;

  List<SavingsGoalEntity> get activeGoals =>
      goals.where((g) => !g.isCompleted).toList();

  List<SavingsGoalEntity> get completedGoals =>
      goals.where((g) => g.isCompleted).toList();

  SavingsGoalState copyWith({
    SavingsGoalStatus? status,
    List<SavingsGoalEntity>? goals,
    String? failureMessage,
    bool? goalJustCompleted,
  }) {
    return SavingsGoalState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      failureMessage: failureMessage ?? this.failureMessage,
      goalJustCompleted: goalJustCompleted ?? this.goalJustCompleted,
    );
  }

  @override
  List<Object?> get props => [status, goals, failureMessage, goalJustCompleted];
}
