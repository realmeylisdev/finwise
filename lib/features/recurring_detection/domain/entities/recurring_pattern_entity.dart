import 'package:equatable/equatable.dart';

enum RecurringFrequency { weekly, biweekly, monthly, quarterly, yearly, unknown }

class RecurringPatternEntity extends Equatable {
  const RecurringPatternEntity({
    required this.categoryName,
    this.categoryIcon,
    this.categoryColor,
    required this.amount,
    required this.frequency,
    required this.lastDate,
    this.nextExpectedDate,
    required this.occurrences,
    this.note,
  });

  final String categoryName;
  final String? categoryIcon;
  final int? categoryColor;
  final double amount;
  final RecurringFrequency frequency;
  final DateTime lastDate;
  final DateTime? nextExpectedDate;
  final int occurrences;
  final String? note;

  @override
  List<Object?> get props => [
        categoryName,
        amount,
        frequency,
        lastDate,
        nextExpectedDate,
        occurrences,
        note,
      ];
}
