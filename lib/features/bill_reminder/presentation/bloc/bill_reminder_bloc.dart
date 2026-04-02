import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/bill_reminder/domain/entities/bill_reminder_entity.dart';
import 'package:finwise/features/bill_reminder/domain/usecases/create_bill_reminder_usecase.dart';
import 'package:finwise/features/bill_reminder/domain/usecases/delete_bill_reminder_usecase.dart';
import 'package:finwise/features/bill_reminder/domain/usecases/get_bill_reminders_usecase.dart';
import 'package:injectable/injectable.dart';

part 'bill_reminder_event.dart';
part 'bill_reminder_state.dart';

@injectable
class BillReminderBloc extends Bloc<BillReminderEvent, BillReminderState> {
  BillReminderBloc({
    required GetBillRemindersUseCase getBills,
    required CreateBillReminderUseCase createBill,
    required DeleteBillReminderUseCase deleteBill,
  })  : _getBills = getBills,
        _createBill = createBill,
        _deleteBill = deleteBill,
        super(const BillReminderState()) {
    on<BillsLoaded>(_onLoaded, transformer: droppable());
    on<BillCreated>(_onCreated, transformer: droppable());
    on<BillDeleted>(_onDeleted, transformer: droppable());
  }

  final GetBillRemindersUseCase _getBills;
  final CreateBillReminderUseCase _createBill;
  final DeleteBillReminderUseCase _deleteBill;

  Future<void> _onLoaded(
    BillsLoaded event,
    Emitter<BillReminderState> emit,
  ) async {
    emit(state.copyWith(status: BillReminderStatus.loading));
    final result = await _getBills(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: BillReminderStatus.failure,
        failureMessage: failure.message,
      )),
      (bills) => emit(state.copyWith(
        status: BillReminderStatus.success,
        bills: bills,
      )),
    );
  }

  Future<void> _onCreated(
    BillCreated event,
    Emitter<BillReminderState> emit,
  ) async {
    final result = await _createBill(event.bill);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BillReminderStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const BillsLoaded()),
    );
  }

  Future<void> _onDeleted(
    BillDeleted event,
    Emitter<BillReminderState> emit,
  ) async {
    final result = await _deleteBill(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BillReminderStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const BillsLoaded()),
    );
  }
}
