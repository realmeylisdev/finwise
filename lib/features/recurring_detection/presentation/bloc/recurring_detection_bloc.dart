import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/recurring_detection/domain/entities/recurring_pattern_entity.dart';
import 'package:finwise/features/recurring_detection/domain/usecases/detect_recurring_usecase.dart';
import 'package:injectable/injectable.dart';

part 'recurring_detection_event.dart';
part 'recurring_detection_state.dart';

@injectable
class RecurringDetectionBloc
    extends Bloc<RecurringDetectionEvent, RecurringDetectionState> {
  RecurringDetectionBloc({
    required DetectRecurringUseCase detectRecurring,
  })  : _detectRecurring = detectRecurring,
        super(const RecurringDetectionState()) {
    on<RecurringPatternsLoaded>(_onLoaded, transformer: droppable());
  }

  final DetectRecurringUseCase _detectRecurring;

  Future<void> _onLoaded(
    RecurringPatternsLoaded event,
    Emitter<RecurringDetectionState> emit,
  ) async {
    emit(state.copyWith(status: RecurringDetectionStatus.loading));
    final result = await _detectRecurring();
    result.fold(
      (failure) => emit(state.copyWith(
        status: RecurringDetectionStatus.failure,
        failureMessage: failure.message,
      )),
      (patterns) => emit(state.copyWith(
        status: RecurringDetectionStatus.success,
        patterns: patterns,
      )),
    );
  }
}
