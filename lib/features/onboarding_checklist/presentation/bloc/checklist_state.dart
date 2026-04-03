part of 'checklist_bloc.dart';

enum ChecklistStatus { initial, loading, success, failure }

class ChecklistState extends Equatable {
  const ChecklistState({
    this.status = ChecklistStatus.initial,
    this.items = const [],
    this.completedCount = 0,
    this.totalCount = 0,
    this.isAllComplete = false,
    this.failureMessage,
  });

  final ChecklistStatus status;
  final List<ChecklistItemEntity> items;
  final int completedCount;
  final int totalCount;
  final bool isAllComplete;
  final String? failureMessage;

  ChecklistState copyWith({
    ChecklistStatus? status,
    List<ChecklistItemEntity>? items,
    int? completedCount,
    int? totalCount,
    bool? isAllComplete,
    String? failureMessage,
  }) {
    return ChecklistState(
      status: status ?? this.status,
      items: items ?? this.items,
      completedCount: completedCount ?? this.completedCount,
      totalCount: totalCount ?? this.totalCount,
      isAllComplete: isAllComplete ?? this.isAllComplete,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        completedCount,
        totalCount,
        isAllComplete,
        failureMessage,
      ];
}
