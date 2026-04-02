import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/domain/usecases/create_budget_usecase.dart';
import 'package:finwise/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:finwise/features/budget/domain/usecases/get_budgets_for_month_usecase.dart';
import 'package:finwise/features/budget/domain/usecases/update_budget_usecase.dart';
import 'package:injectable/injectable.dart';

part 'budget_event.dart';
part 'budget_state.dart';

@injectable
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc({
    required GetBudgetsForMonthUseCase getBudgetsForMonth,
    required CreateBudgetUseCase createBudget,
    required UpdateBudgetUseCase updateBudget,
    required DeleteBudgetUseCase deleteBudget,
  })  : _getBudgetsForMonth = getBudgetsForMonth,
        _createBudget = createBudget,
        _updateBudget = updateBudget,
        _deleteBudget = deleteBudget,
        super(BudgetState()) {
    on<BudgetsLoaded>(_onLoaded, transformer: droppable());
    on<BudgetCreated>(_onCreated, transformer: droppable());
    on<BudgetUpdated>(_onUpdated, transformer: droppable());
    on<BudgetDeleted>(_onDeleted, transformer: droppable());
    on<BudgetMonthChanged>(_onMonthChanged, transformer: droppable());
  }

  final GetBudgetsForMonthUseCase _getBudgetsForMonth;
  final CreateBudgetUseCase _createBudget;
  final UpdateBudgetUseCase _updateBudget;
  final DeleteBudgetUseCase _deleteBudget;

  Future<void> _onLoaded(
    BudgetsLoaded event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    final result = await _getBudgetsForMonth(
      (year: event.year, month: event.month),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: BudgetStatus.failure,
        failureMessage: failure.message,
      )),
      (budgets) => emit(state.copyWith(
        status: BudgetStatus.success,
        budgets: budgets,
        selectedYear: event.year,
        selectedMonth: event.month,
      )),
    );
  }

  Future<void> _onCreated(
    BudgetCreated event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await _createBudget(event.budget);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BudgetStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(BudgetsLoaded(
        year: state.selectedYear,
        month: state.selectedMonth,
      )),
    );
  }

  Future<void> _onUpdated(
    BudgetUpdated event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await _updateBudget(event.budget);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BudgetStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(BudgetsLoaded(
        year: state.selectedYear,
        month: state.selectedMonth,
      )),
    );
  }

  Future<void> _onDeleted(
    BudgetDeleted event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await _deleteBudget(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BudgetStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(BudgetsLoaded(
        year: state.selectedYear,
        month: state.selectedMonth,
      )),
    );
  }

  void _onMonthChanged(
    BudgetMonthChanged event,
    Emitter<BudgetState> emit,
  ) {
    add(BudgetsLoaded(year: event.year, month: event.month));
  }
}
