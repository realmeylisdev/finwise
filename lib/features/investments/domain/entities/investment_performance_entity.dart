import 'package:equatable/equatable.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';

class InvestmentPerformanceEntity extends Equatable {
  const InvestmentPerformanceEntity({
    required this.totalValue,
    required this.totalCostBasis,
    required this.totalGainLoss,
    required this.totalGainLossPercent,
    required this.allocationByType,
  });

  final double totalValue;
  final double totalCostBasis;
  final double totalGainLoss;
  final double totalGainLossPercent;
  final Map<InvestmentType, double> allocationByType;

  @override
  List<Object?> get props => [
        totalValue, totalCostBasis, totalGainLoss,
        totalGainLossPercent, allocationByType,
      ];
}
