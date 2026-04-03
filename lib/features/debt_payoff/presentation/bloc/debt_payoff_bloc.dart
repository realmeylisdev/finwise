import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_payment_entity.dart';
import 'package:finwise/features/debt_payoff/domain/entities/payoff_plan_entity.dart';
import 'package:finwise/features/debt_payoff/domain/repositories/debt_payoff_repository.dart';
import 'package:finwise/features/debt_payoff/domain/usecases/calculate_payoff_plan_usecase.dart';
import 'package:injectable/injectable.dart';

part 'debt_payoff_event.dart';
part 'debt_payoff_state.dart';

@injectable
class DebtPayoffBloc extends Bloc<DebtPayoffEvent, DebtPayoffState> {
  DebtPayoffBloc({
    required DebtPayoffRepository repository,
    required CalculatePayoffPlanUseCase calculatePayoffPlan,
  })  : _repository = repository,
        _calculatePayoffPlan = calculatePayoffPlan,
        super(const DebtPayoffState()) {
    on<DebtsLoaded>(_onDebtsLoaded, transformer: droppable());
    on<DebtCreated>(_onDebtCreated, transformer: droppable());
    on<DebtUpdated>(_onDebtUpdated, transformer: droppable());
    on<DebtDeleted>(_onDebtDeleted, transformer: droppable());
    on<PayoffPlanCalculated>(_onPayoffPlanCalculated, transformer: droppable());
    on<PaymentRecorded>(_onPaymentRecorded, transformer: droppable());
  }

  final DebtPayoffRepository _repository;
  final CalculatePayoffPlanUseCase _calculatePayoffPlan;

  Future<void> _onDebtsLoaded(
    DebtsLoaded event,
    Emitter<DebtPayoffState> emit,
  ) async {
    emit(state.copyWith(status: DebtPayoffStatus.loading));

    final result = await _repository.getDebts();

    result.fold(
      (failure) => emit(state.copyWith(
        status: DebtPayoffStatus.failure,
        failureMessage: failure.message,
      )),
      (debts) {
        final totalDebt =
            debts.fold<double>(0, (sum, d) => sum + d.balance);

        emit(state.copyWith(
          status: DebtPayoffStatus.success,
          debts: debts,
          totalDebt: totalDebt,
        ));
      },
    );
  }

  Future<void> _onDebtCreated(
    DebtCreated event,
    Emitter<DebtPayoffState> emit,
  ) async {
    final result = await _repository.createDebt(event.debt);
    result.fold(
      (failure) => emit(state.copyWith(
        status: DebtPayoffStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const DebtsLoaded()),
    );
  }

  Future<void> _onDebtUpdated(
    DebtUpdated event,
    Emitter<DebtPayoffState> emit,
  ) async {
    final result = await _repository.updateDebt(event.debt);
    result.fold(
      (failure) => emit(state.copyWith(
        status: DebtPayoffStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const DebtsLoaded()),
    );
  }

  Future<void> _onDebtDeleted(
    DebtDeleted event,
    Emitter<DebtPayoffState> emit,
  ) async {
    final result = await _repository.deleteDebt(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: DebtPayoffStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const DebtsLoaded()),
    );
  }

  Future<void> _onPayoffPlanCalculated(
    PayoffPlanCalculated event,
    Emitter<DebtPayoffState> emit,
  ) async {
    if (state.debts.isEmpty) return;

    final snowball = _calculatePayoffPlan.calculateSnowball(
      debts: state.debts,
      extraMonthlyPayment: event.extraPayment,
    );
    final avalanche = _calculatePayoffPlan.calculateAvalanche(
      debts: state.debts,
      extraMonthlyPayment: event.extraPayment,
    );

    emit(state.copyWith(
      snowballPlan: snowball,
      avalanchePlan: avalanche,
    ));
  }

  Future<void> _onPaymentRecorded(
    PaymentRecorded event,
    Emitter<DebtPayoffState> emit,
  ) async {
    final result = await _repository.recordPayment(event.payment);
    result.fold(
      (failure) => emit(state.copyWith(
        status: DebtPayoffStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const DebtsLoaded()),
    );
  }
}
