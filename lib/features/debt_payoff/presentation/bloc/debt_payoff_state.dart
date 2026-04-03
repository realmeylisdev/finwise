part of 'debt_payoff_bloc.dart';

enum DebtPayoffStatus { initial, loading, success, failure }

class DebtPayoffState extends Equatable {
  const DebtPayoffState({
    this.status = DebtPayoffStatus.initial,
    this.debts = const [],
    this.snowballPlan,
    this.avalanchePlan,
    this.totalDebt = 0,
    this.failureMessage,
  });

  final DebtPayoffStatus status;
  final List<DebtEntity> debts;
  final PayoffPlanEntity? snowballPlan;
  final PayoffPlanEntity? avalanchePlan;
  final double totalDebt;
  final String? failureMessage;

  DebtPayoffState copyWith({
    DebtPayoffStatus? status,
    List<DebtEntity>? debts,
    PayoffPlanEntity? snowballPlan,
    PayoffPlanEntity? avalanchePlan,
    double? totalDebt,
    String? failureMessage,
  }) {
    return DebtPayoffState(
      status: status ?? this.status,
      debts: debts ?? this.debts,
      snowballPlan: snowballPlan ?? this.snowballPlan,
      avalanchePlan: avalanchePlan ?? this.avalanchePlan,
      totalDebt: totalDebt ?? this.totalDebt,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, debts, snowballPlan, avalanchePlan,
        totalDebt, failureMessage,
      ];
}
