import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/cash_flow/domain/entities/cash_flow_projection_entity.dart';
import 'package:finwise/features/cash_flow/domain/usecases/generate_forecast_usecase.dart';
import 'package:injectable/injectable.dart';

part 'cash_flow_event.dart';
part 'cash_flow_state.dart';

@injectable
class CashFlowBloc extends Bloc<CashFlowEvent, CashFlowState> {
  CashFlowBloc({required GenerateForecastUseCase generateForecastUseCase})
      : _generateForecastUseCase = generateForecastUseCase,
        super(const CashFlowState()) {
    on<CashFlowLoaded>(_onLoaded, transformer: droppable());
  }

  final GenerateForecastUseCase _generateForecastUseCase;

  Future<void> _onLoaded(
    CashFlowLoaded event,
    Emitter<CashFlowState> emit,
  ) async {
    emit(state.copyWith(status: CashFlowStatus.loading));

    final result = await _generateForecastUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: CashFlowStatus.failure,
        failureMessage: failure.message,
      )),
      (projection) => emit(state.copyWith(
        status: CashFlowStatus.success,
        projection: projection,
      )),
    );
  }
}
