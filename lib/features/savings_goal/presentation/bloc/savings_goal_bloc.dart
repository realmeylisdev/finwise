import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/savings_goal/domain/entities/savings_goal_entity.dart';
import 'package:finwise/features/savings_goal/domain/usecases/contribute_savings_goal_usecase.dart';
import 'package:finwise/features/savings_goal/domain/usecases/create_savings_goal_usecase.dart';
import 'package:finwise/features/savings_goal/domain/usecases/delete_savings_goal_usecase.dart';
import 'package:finwise/features/savings_goal/domain/usecases/get_savings_goals_usecase.dart';
import 'package:injectable/injectable.dart';

part 'savings_goal_event.dart';
part 'savings_goal_state.dart';

@injectable
class SavingsGoalBloc extends Bloc<SavingsGoalEvent, SavingsGoalState> {
  SavingsGoalBloc({
    required GetSavingsGoalsUseCase getGoals,
    required CreateSavingsGoalUseCase createGoal,
    required DeleteSavingsGoalUseCase deleteGoal,
    required ContributeSavingsGoalUseCase contributeGoal,
  })  : _getGoals = getGoals,
        _createGoal = createGoal,
        _deleteGoal = deleteGoal,
        _contributeGoal = contributeGoal,
        super(const SavingsGoalState()) {
    on<GoalsLoaded>(_onLoaded, transformer: droppable());
    on<GoalCreated>(_onCreated, transformer: droppable());
    on<GoalDeleted>(_onDeleted, transformer: droppable());
    on<GoalContributed>(_onContributed, transformer: droppable());
    on<GoalWithdrawn>(_onWithdrawn, transformer: droppable());
    on<GoalCelebrationAcknowledged>(_onCelebrationAcknowledged);
  }

  final GetSavingsGoalsUseCase _getGoals;
  final CreateSavingsGoalUseCase _createGoal;
  final DeleteSavingsGoalUseCase _deleteGoal;
  final ContributeSavingsGoalUseCase _contributeGoal;

  Future<void> _onLoaded(
    GoalsLoaded event,
    Emitter<SavingsGoalState> emit,
  ) async {
    emit(state.copyWith(status: SavingsGoalStatus.loading));
    final result = await _getGoals(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: SavingsGoalStatus.failure,
        failureMessage: failure.message,
      )),
      (goals) => emit(state.copyWith(
        status: SavingsGoalStatus.success,
        goals: goals,
      )),
    );
  }

  Future<void> _onCreated(
    GoalCreated event,
    Emitter<SavingsGoalState> emit,
  ) async {
    final result = await _createGoal(event.goal);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SavingsGoalStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const GoalsLoaded()),
    );
  }

  Future<void> _onDeleted(
    GoalDeleted event,
    Emitter<SavingsGoalState> emit,
  ) async {
    final result = await _deleteGoal(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SavingsGoalStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const GoalsLoaded()),
    );
  }

  Future<void> _onContributed(
    GoalContributed event,
    Emitter<SavingsGoalState> emit,
  ) async {
    // Check the goal before contributing to detect completion
    final goalBefore =
        state.goals.where((g) => g.id == event.id).firstOrNull;
    final wasCompleted = goalBefore?.isCompleted ?? true;

    final result = await _contributeGoal(
      (id: event.id, amount: event.amount),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: SavingsGoalStatus.failure,
        failureMessage: failure.message,
      )),
      (_) {
        // Detect if the goal just reached its target
        if (!wasCompleted && goalBefore != null) {
          final newSaved = goalBefore.savedAmount + event.amount;
          if (newSaved >= goalBefore.targetAmount) {
            emit(state.copyWith(goalJustCompleted: true));
          }
        }
        add(const GoalsLoaded());
      },
    );
  }

  Future<void> _onWithdrawn(
    GoalWithdrawn event,
    Emitter<SavingsGoalState> emit,
  ) async {
    // Reuse contribute with negative — DAO handles clamp
    final result = await _contributeGoal(
      (id: event.id, amount: -event.amount),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: SavingsGoalStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const GoalsLoaded()),
    );
  }

  void _onCelebrationAcknowledged(
    GoalCelebrationAcknowledged event,
    Emitter<SavingsGoalState> emit,
  ) {
    emit(state.copyWith(goalJustCompleted: false));
  }
}
