import 'package:equatable/equatable.dart';

enum InsightCategory { anomaly, trend, recommendation, forecast }

enum InsightSeverity { info, warning, positive }

class AiInsightEntity extends Equatable {
  const AiInsightEntity({
    required this.id,
    required this.category,
    required this.severity,
    required this.title,
    required this.description,
    this.amount,
    this.percentChange,
    this.categoryName,
    required this.createdAt,
  });

  final String id;
  final InsightCategory category;
  final InsightSeverity severity;
  final String title;
  final String description;
  final double? amount;
  final double? percentChange;
  final String? categoryName;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        category,
        severity,
        title,
        description,
        amount,
        percentChange,
        categoryName,
        createdAt,
      ];
}
