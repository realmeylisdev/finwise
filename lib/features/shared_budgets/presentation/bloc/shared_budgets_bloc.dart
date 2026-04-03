import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/shared_budgets/domain/entities/shared_budget_entity.dart';
import 'package:finwise/features/shared_budgets/domain/repositories/shared_budget_repository.dart';
import 'package:injectable/injectable.dart';

part 'shared_budgets_event.dart';
part 'shared_budgets_state.dart';

@injectable
class SharedBudgetsBloc
    extends Bloc<SharedBudgetsEvent, SharedBudgetsState> {
  SharedBudgetsBloc({required SharedBudgetRepository repository})
      : _repository = repository,
        super(const SharedBudgetsState()) {
    on<SharedBudgetsLoaded>(_onLoaded, transformer: droppable());
    on<BudgetShared>(_onShared, transformer: droppable());
    on<BudgetUnshared>(_onUnshared, transformer: droppable());
  }

  final SharedBudgetRepository _repository;

  Future<void> _onLoaded(
    SharedBudgetsLoaded event,
    Emitter<SharedBudgetsState> emit,
  ) async {
    emit(state.copyWith(
      status: SharedBudgetsStatus.loading,
      currentBudgetId: event.budgetId,
    ));

    final result = await _repository.getSharesForBudget(event.budgetId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SharedBudgetsStatus.failure,
        failureMessage: failure.message,
      )),
      (shares) => emit(state.copyWith(
        status: SharedBudgetsStatus.success,
        shares: shares,
      )),
    );
  }

  Future<void> _onShared(
    BudgetShared event,
    Emitter<SharedBudgetsState> emit,
  ) async {
    final result = await _repository.shareBudget(event.share);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SharedBudgetsStatus.failure,
        failureMessage: failure.message,
      )),
      (_) {
        if (state.currentBudgetId != null) {
          add(SharedBudgetsLoaded(state.currentBudgetId!));
        }
      },
    );
  }

  Future<void> _onUnshared(
    BudgetUnshared event,
    Emitter<SharedBudgetsState> emit,
  ) async {
    final result = await _repository.unshareBudget(
      event.budgetId,
      event.profileId,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: SharedBudgetsStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(SharedBudgetsLoaded(event.budgetId)),
    );
  }
}
