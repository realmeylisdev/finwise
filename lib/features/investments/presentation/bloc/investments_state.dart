part of 'investments_bloc.dart';

enum InvestmentsStatus { initial, loading, success, failure }

class InvestmentsState extends Equatable {
  const InvestmentsState({
    this.status = InvestmentsStatus.initial,
    this.investments = const [],
    this.performance,
    this.totalValue = 0,
    this.failureMessage,
  });

  final InvestmentsStatus status;
  final List<InvestmentEntity> investments;
  final InvestmentPerformanceEntity? performance;
  final double totalValue;
  final String? failureMessage;

  InvestmentsState copyWith({
    InvestmentsStatus? status,
    List<InvestmentEntity>? investments,
    InvestmentPerformanceEntity? performance,
    double? totalValue,
    String? failureMessage,
  }) {
    return InvestmentsState(
      status: status ?? this.status,
      investments: investments ?? this.investments,
      performance: performance ?? this.performance,
      totalValue: totalValue ?? this.totalValue,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, investments, performance, totalValue, failureMessage,
      ];
}
