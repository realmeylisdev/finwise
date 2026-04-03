import 'package:equatable/equatable.dart';
import 'package:finwise/features/onboarding_checklist/domain/entities/checklist_item_entity.dart';

class ChecklistResultEntity extends Equatable {
  const ChecklistResultEntity({
    required this.items,
    required this.completedCount,
    required this.totalCount,
  });

  final List<ChecklistItemEntity> items;
  final int completedCount;
  final int totalCount;

  double get completionPercentage =>
      totalCount > 0 ? completedCount / totalCount : 0;

  bool get isAllComplete => completedCount >= totalCount;

  @override
  List<Object?> get props => [items, completedCount, totalCount];
}
