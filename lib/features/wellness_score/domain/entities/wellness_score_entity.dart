import 'package:equatable/equatable.dart';

class WellnessScoreEntity extends Equatable {
  const WellnessScoreEntity({
    required this.overallScore,
    required this.budgetScore,
    required this.savingsScore,
    required this.debtScore,
    required this.consistencyScore,
  });

  final int overallScore; // 0-100
  final int budgetScore; // 0-100
  final int savingsScore; // 0-100
  final int debtScore; // 0-100
  final int consistencyScore; // 0-100

  String get grade {
    if (overallScore >= 90) return 'A+';
    if (overallScore >= 80) return 'A';
    if (overallScore >= 70) return 'B';
    if (overallScore >= 60) return 'C';
    if (overallScore >= 50) return 'D';
    return 'F';
  }

  String get description {
    if (overallScore >= 80) return 'Excellent financial health!';
    if (overallScore >= 60) return 'Good progress, keep going!';
    if (overallScore >= 40) return 'Room for improvement';
    return 'Let\'s work on your finances';
  }

  @override
  List<Object?> get props => [
        overallScore,
        budgetScore,
        savingsScore,
        debtScore,
        consistencyScore,
      ];
}
