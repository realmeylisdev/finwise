part of 'shared_budgets_bloc.dart';

enum SharedBudgetsStatus { initial, loading, success, failure }

class SharedBudgetsState extends Equatable {
  const SharedBudgetsState({
    this.status = SharedBudgetsStatus.initial,
    this.shares = const [],
    this.currentBudgetId,
    this.failureMessage,
  });

  final SharedBudgetsStatus status;
  final List<SharedBudgetEntity> shares;
  final String? currentBudgetId;
  final String? failureMessage;

  SharedBudgetsState copyWith({
    SharedBudgetsStatus? status,
    List<SharedBudgetEntity>? shares,
    String? currentBudgetId,
    String? failureMessage,
  }) {
    return SharedBudgetsState(
      status: status ?? this.status,
      shares: shares ?? this.shares,
      currentBudgetId: currentBudgetId ?? this.currentBudgetId,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  /// Whether a given profile has access to the current budget.
  bool isSharedWith(String profileId) {
    return shares.any((s) => s.profileId == profileId);
  }

  @override
  List<Object?> get props => [status, shares, currentBudgetId, failureMessage];
}
