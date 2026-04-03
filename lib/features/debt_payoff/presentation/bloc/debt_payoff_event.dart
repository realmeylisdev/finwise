part of 'debt_payoff_bloc.dart';

abstract class DebtPayoffEvent extends Equatable {
  const DebtPayoffEvent();
  @override
  List<Object?> get props => [];
}

class DebtsLoaded extends DebtPayoffEvent {
  const DebtsLoaded();
}

class DebtCreated extends DebtPayoffEvent {
  const DebtCreated(this.debt);
  final DebtEntity debt;
  @override
  List<Object?> get props => [debt];
}

class DebtUpdated extends DebtPayoffEvent {
  const DebtUpdated(this.debt);
  final DebtEntity debt;
  @override
  List<Object?> get props => [debt];
}

class DebtDeleted extends DebtPayoffEvent {
  const DebtDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class PayoffPlanCalculated extends DebtPayoffEvent {
  const PayoffPlanCalculated({this.extraPayment = 0});
  final double extraPayment;
  @override
  List<Object?> get props => [extraPayment];
}

class PaymentRecorded extends DebtPayoffEvent {
  const PaymentRecorded(this.payment);
  final DebtPaymentEntity payment;
  @override
  List<Object?> get props => [payment];
}
