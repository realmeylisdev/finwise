part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
  @override
  List<Object?> get props => [];
}

class MonthlyReportRequested extends ReportsEvent {
  const MonthlyReportRequested({required this.year, required this.month});

  final int year;
  final int month;

  @override
  List<Object?> get props => [year, month];
}

class AnnualReportRequested extends ReportsEvent {
  const AnnualReportRequested({required this.year});

  final int year;

  @override
  List<Object?> get props => [year];
}
