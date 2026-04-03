import 'package:equatable/equatable.dart';

enum InsightType { tip, warning, positive }

class SpendingInsight extends Equatable {
  const SpendingInsight({
    required this.type,
    required this.title,
    required this.description,
    this.iconName,
  });

  final InsightType type;
  final String title;
  final String description;
  final String? iconName;

  @override
  List<Object?> get props => [type, title, description, iconName];
}
