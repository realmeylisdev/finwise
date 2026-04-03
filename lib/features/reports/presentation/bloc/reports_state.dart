part of 'reports_bloc.dart';

enum ReportsStatus { initial, generating, ready, failure }

enum ReportType { monthly, annual }

class ReportsState extends Equatable {
  const ReportsState({
    this.status = ReportsStatus.initial,
    this.reportBytes,
    this.reportType,
    this.failureMessage,
  });

  final ReportsStatus status;
  final Uint8List? reportBytes;
  final ReportType? reportType;
  final String? failureMessage;

  ReportsState copyWith({
    ReportsStatus? status,
    Uint8List? reportBytes,
    ReportType? reportType,
    String? failureMessage,
  }) {
    return ReportsState(
      status: status ?? this.status,
      reportBytes: reportBytes ?? this.reportBytes,
      reportType: reportType ?? this.reportType,
      failureMessage: failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, reportBytes, reportType, failureMessage];
}
