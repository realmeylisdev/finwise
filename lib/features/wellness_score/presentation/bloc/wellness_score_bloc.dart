import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/wellness_score/domain/entities/wellness_score_entity.dart';
import 'package:finwise/features/wellness_score/domain/usecases/calculate_wellness_score_usecase.dart';
import 'package:injectable/injectable.dart';

part 'wellness_score_event.dart';
part 'wellness_score_state.dart';

@injectable
class WellnessScoreBloc extends Bloc<WellnessScoreEvent, WellnessScoreState> {
  WellnessScoreBloc({
    required CalculateWellnessScoreUseCase calculateWellnessScoreUseCase,
  })  : _calculateScore = calculateWellnessScoreUseCase,
        super(const WellnessScoreState()) {
    on<WellnessScoreLoaded>(_onLoaded, transformer: droppable());
  }

  final CalculateWellnessScoreUseCase _calculateScore;

  Future<void> _onLoaded(
    WellnessScoreLoaded event,
    Emitter<WellnessScoreState> emit,
  ) async {
    emit(state.copyWith(status: WellnessScoreStatus.loading));

    try {
      final score = await _calculateScore();

      emit(state.copyWith(
        status: WellnessScoreStatus.success,
        score: score,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: WellnessScoreStatus.failure,
        failureMessage: e.toString(),
      ));
    }
  }
}
