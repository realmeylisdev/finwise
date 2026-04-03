part of 'cash_flow_bloc.dart';

abstract class CashFlowEvent extends Equatable {
  const CashFlowEvent();
  @override
  List<Object?> get props => [];
}

class CashFlowLoaded extends CashFlowEvent {
  const CashFlowLoaded();
}
