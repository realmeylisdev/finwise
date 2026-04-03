import 'package:equatable/equatable.dart';

class DailyProjection extends Equatable {
  const DailyProjection({
    required this.date,
    required this.projectedBalance,
    required this.incoming,
    required this.outgoing,
  });

  final DateTime date;
  final double projectedBalance;
  final double incoming;
  final double outgoing;

  @override
  List<Object?> get props => [date, projectedBalance, incoming, outgoing];
}

class CashFlowProjectionEntity extends Equatable {
  const CashFlowProjectionEntity({
    required this.startBalance,
    required this.projections,
    required this.lowestBalance,
    required this.lowestBalanceDate,
    required this.endBalance,
  });

  final double startBalance;
  final List<DailyProjection> projections;
  final double lowestBalance;
  final DateTime lowestBalanceDate;
  final double endBalance;

  @override
  List<Object?> get props =>
      [startBalance, projections, lowestBalance, lowestBalanceDate, endBalance];
}
