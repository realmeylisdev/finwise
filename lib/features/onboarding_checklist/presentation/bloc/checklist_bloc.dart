import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/onboarding_checklist/domain/entities/checklist_item_entity.dart';
import 'package:finwise/features/onboarding_checklist/domain/usecases/get_checklist_usecase.dart';
import 'package:injectable/injectable.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';

@injectable
class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  ChecklistBloc({
    required GetChecklistUseCase getChecklistUseCase,
  })  : _getChecklist = getChecklistUseCase,
        super(const ChecklistState()) {
    on<ChecklistLoaded>(_onLoaded, transformer: droppable());
  }

  final GetChecklistUseCase _getChecklist;

  Future<void> _onLoaded(
    ChecklistLoaded event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(state.copyWith(status: ChecklistStatus.loading));

    try {
      final result = await _getChecklist();

      emit(state.copyWith(
        status: ChecklistStatus.success,
        items: result.items,
        completedCount: result.completedCount,
        totalCount: result.totalCount,
        isAllComplete: result.isAllComplete,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: ChecklistStatus.failure,
        failureMessage: e.toString(),
      ));
    }
  }
}
