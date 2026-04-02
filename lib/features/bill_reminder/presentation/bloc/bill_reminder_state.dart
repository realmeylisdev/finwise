part of 'bill_reminder_bloc.dart';

enum BillReminderStatus { initial, loading, success, failure }

class BillReminderState extends Equatable {
  const BillReminderState({
    this.status = BillReminderStatus.initial,
    this.bills = const [],
    this.failureMessage,
  });

  final BillReminderStatus status;
  final List<BillReminderEntity> bills;
  final String? failureMessage;

  BillReminderState copyWith({
    BillReminderStatus? status,
    List<BillReminderEntity>? bills,
    String? failureMessage,
  }) {
    return BillReminderState(
      status: status ?? this.status,
      bills: bills ?? this.bills,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, bills, failureMessage];
}
