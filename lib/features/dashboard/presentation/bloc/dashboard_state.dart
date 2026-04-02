part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.summary = const DashboardSummaryEntity(),
    this.failureMessage,
  });

  final DashboardStatus status;
  final DashboardSummaryEntity summary;
  final String? failureMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummaryEntity? summary,
    String? failureMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, failureMessage];
}
