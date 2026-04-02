part of 'bill_reminder_bloc.dart';

abstract class BillReminderEvent extends Equatable {
  const BillReminderEvent();
  @override
  List<Object?> get props => [];
}

class BillsLoaded extends BillReminderEvent {
  const BillsLoaded();
}

class BillCreated extends BillReminderEvent {
  const BillCreated(this.bill);
  final BillReminderEntity bill;
  @override
  List<Object?> get props => [bill];
}

class BillDeleted extends BillReminderEvent {
  const BillDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
