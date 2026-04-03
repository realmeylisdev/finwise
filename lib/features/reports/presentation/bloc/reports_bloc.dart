import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/reports/domain/usecases/generate_annual_report_usecase.dart';
import 'package:finwise/features/reports/domain/usecases/generate_monthly_report_usecase.dart';
import 'package:injectable/injectable.dart';

part 'reports_event.dart';
part 'reports_state.dart';

@injectable
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc({
    required GenerateMonthlyReportUseCase generateMonthlyReport,
    required GenerateAnnualReportUseCase generateAnnualReport,
  })  : _generateMonthlyReport = generateMonthlyReport,
        _generateAnnualReport = generateAnnualReport,
        super(const ReportsState()) {
    on<MonthlyReportRequested>(_onMonthlyReport, transformer: droppable());
    on<AnnualReportRequested>(_onAnnualReport, transformer: droppable());
  }

  final GenerateMonthlyReportUseCase _generateMonthlyReport;
  final GenerateAnnualReportUseCase _generateAnnualReport;

  Future<void> _onMonthlyReport(
    MonthlyReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(
      status: ReportsStatus.generating,
      reportType: ReportType.monthly,
    ));

    final result = await _generateMonthlyReport(
      year: event.year,
      month: event.month,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ReportsStatus.failure,
        failureMessage: failure.message,
      )),
      (bytes) => emit(state.copyWith(
        status: ReportsStatus.ready,
        reportBytes: bytes,
        reportType: ReportType.monthly,
      )),
    );
  }

  Future<void> _onAnnualReport(
    AnnualReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(
      status: ReportsStatus.generating,
      reportType: ReportType.annual,
    ));

    final result = await _generateAnnualReport(year: event.year);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ReportsStatus.failure,
        failureMessage: failure.message,
      )),
      (bytes) => emit(state.copyWith(
        status: ReportsStatus.ready,
        reportBytes: bytes,
        reportType: ReportType.annual,
      )),
    );
  }
}
