import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';
import 'package:finwise/features/investments/domain/entities/investment_performance_entity.dart';
import 'package:finwise/features/investments/domain/repositories/investments_repository.dart';
import 'package:injectable/injectable.dart';

part 'investments_event.dart';
part 'investments_state.dart';

@injectable
class InvestmentsBloc extends Bloc<InvestmentsEvent, InvestmentsState> {
  InvestmentsBloc({required InvestmentsRepository repository})
      : _repository = repository,
        super(const InvestmentsState()) {
    on<InvestmentsLoaded>(_onLoaded, transformer: droppable());
    on<InvestmentCreated>(_onCreated, transformer: droppable());
    on<InvestmentUpdated>(_onUpdated, transformer: droppable());
    on<InvestmentDeleted>(_onDeleted, transformer: droppable());
    on<PriceUpdated>(_onPriceUpdated, transformer: droppable());
  }

  final InvestmentsRepository _repository;

  Future<void> _onLoaded(
    InvestmentsLoaded event,
    Emitter<InvestmentsState> emit,
  ) async {
    emit(state.copyWith(status: InvestmentsStatus.loading));

    final investmentsResult = await _repository.getInvestments();
    final performanceResult = await _repository.getPerformance();

    if (investmentsResult.isLeft()) {
      emit(state.copyWith(
        status: InvestmentsStatus.failure,
        failureMessage: investmentsResult.getLeft().toNullable()?.message,
      ));
      return;
    }

    final investments = investmentsResult.getOrElse((_) => []);
    final performance = performanceResult.getOrElse(
      (_) => const InvestmentPerformanceEntity(
        totalValue: 0,
        totalCostBasis: 0,
        totalGainLoss: 0,
        totalGainLossPercent: 0,
        allocationByType: {},
      ),
    );

    emit(state.copyWith(
      status: InvestmentsStatus.success,
      investments: investments,
      performance: performance,
      totalValue: performance.totalValue,
    ));
  }

  Future<void> _onCreated(
    InvestmentCreated event,
    Emitter<InvestmentsState> emit,
  ) async {
    final result = await _repository.createInvestment(event.investment);
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvestmentsStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const InvestmentsLoaded()),
    );
  }

  Future<void> _onUpdated(
    InvestmentUpdated event,
    Emitter<InvestmentsState> emit,
  ) async {
    final result = await _repository.updateInvestment(event.investment);
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvestmentsStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const InvestmentsLoaded()),
    );
  }

  Future<void> _onDeleted(
    InvestmentDeleted event,
    Emitter<InvestmentsState> emit,
  ) async {
    final result = await _repository.deleteInvestment(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvestmentsStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const InvestmentsLoaded()),
    );
  }

  Future<void> _onPriceUpdated(
    PriceUpdated event,
    Emitter<InvestmentsState> emit,
  ) async {
    // Record the price history entry
    await _repository.recordPriceHistory(event.id, event.newPrice);

    // Find the investment and update its current price
    final existing = state.investments.where((i) => i.id == event.id);
    if (existing.isNotEmpty) {
      final updated = existing.first.copyWith(
        currentPrice: event.newPrice,
        updatedAt: DateTime.now(),
      );
      final result = await _repository.updateInvestment(updated);
      result.fold(
        (failure) => emit(state.copyWith(
          status: InvestmentsStatus.failure,
          failureMessage: failure.message,
        )),
        (_) => add(const InvestmentsLoaded()),
      );
    }
  }
}
