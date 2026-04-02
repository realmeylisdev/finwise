part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class TransactionsLoaded extends TransactionEvent {
  const TransactionsLoaded();
}

class TransactionCreated extends TransactionEvent {
  const TransactionCreated(this.transaction);
  final TransactionEntity transaction;
  @override
  List<Object?> get props => [transaction];
}

class TransactionUpdated extends TransactionEvent {
  const TransactionUpdated(this.transaction);
  final TransactionEntity transaction;
  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleted extends TransactionEvent {
  const TransactionDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class TransactionDateRangeChanged extends TransactionEvent {
  const TransactionDateRangeChanged({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
  @override
  List<Object?> get props => [start, end];
}
