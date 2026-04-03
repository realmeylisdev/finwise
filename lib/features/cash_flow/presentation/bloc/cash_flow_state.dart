part of 'cash_flow_bloc.dart';

enum CashFlowStatus { initial, loading, success, failure }

class CashFlowState extends Equatable {
  const CashFlowState({
    this.status = CashFlowStatus.initial,
    this.projection,
    this.failureMessage,
  });

  final CashFlowStatus status;
  final CashFlowProjectionEntity? projection;
  final String? failureMessage;

  CashFlowState copyWith({
    CashFlowStatus? status,
    CashFlowProjectionEntity? projection,
    String? failureMessage,
  }) {
    return CashFlowState(
      status: status ?? this.status,
      projection: projection ?? this.projection,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, projection, failureMessage];
}
