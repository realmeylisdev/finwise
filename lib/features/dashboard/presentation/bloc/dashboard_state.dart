part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.summary = const DashboardSummaryEntity(),
    this.insights = const [],
    this.failureMessage,
  });

  final DashboardStatus status;
  final DashboardSummaryEntity summary;
  final List<SpendingInsight> insights;
  final String? failureMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummaryEntity? summary,
    List<SpendingInsight>? insights,
    String? failureMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      insights: insights ?? this.insights,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, insights, failureMessage];
}
