part of 'savings_goal_bloc.dart';

enum SavingsGoalStatus { initial, loading, success, failure }

class SavingsGoalState extends Equatable {
  const SavingsGoalState({
    this.status = SavingsGoalStatus.initial,
    this.goals = const [],
    this.failureMessage,
  });

  final SavingsGoalStatus status;
  final List<SavingsGoalEntity> goals;
  final String? failureMessage;

  List<SavingsGoalEntity> get activeGoals =>
      goals.where((g) => !g.isCompleted).toList();

  List<SavingsGoalEntity> get completedGoals =>
      goals.where((g) => g.isCompleted).toList();

  SavingsGoalState copyWith({
    SavingsGoalStatus? status,
    List<SavingsGoalEntity>? goals,
    String? failureMessage,
  }) {
    return SavingsGoalState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, goals, failureMessage];
}
