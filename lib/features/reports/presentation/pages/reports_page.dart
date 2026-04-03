import 'dart:io';
import 'dart:typed_data';

import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/reports/presentation/bloc/reports_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late int _selectedMonth;
  late int _selectedYear;
  late int _selectedAnnualYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _selectedAnnualYear = now.year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: BlocConsumer<ReportsBloc, ReportsState>(
        listener: (context, state) {
          if (state.status == ReportsStatus.failure &&
              state.failureMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failureMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // ---- Monthly Report ----
              _SectionHeader(title: 'Monthly Report'),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedMonth,
                              decoration: const InputDecoration(
                                labelText: 'Month',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(12, (i) {
                                final m = i + 1;
                                return DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    DateFormat.MMMM()
                                        .format(DateTime(2000, m)),
                                  ),
                                );
                              }),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedMonth = v);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: AppDimensions.paddingS),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedYear,
                              decoration: const InputDecoration(
                                labelText: 'Year',
                                border: OutlineInputBorder(),
                              ),
                              items: _yearItems(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedYear = v);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.paddingM),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: state.status == ReportsStatus.generating
                              ? null
                              : () => _generateMonthly(context),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Generate Monthly Report'),
                        ),
                      ),
                      if (state.status == ReportsStatus.generating &&
                          state.reportType == ReportType.monthly)
                        Padding(
                          padding:
                              EdgeInsets.only(top: AppDimensions.paddingM),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (state.status == ReportsStatus.ready &&
                          state.reportType == ReportType.monthly &&
                          state.reportBytes != null) ...[
                        SizedBox(height: AppDimensions.paddingM),
                        _ReportActions(
                          reportBytes: state.reportBytes!,
                          fileName: 'finwise_monthly_'
                              '${_selectedYear}_'
                              '${_selectedMonth.toString().padLeft(2, '0')}'
                              '.pdf',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.paddingL),

              // ---- Annual Report ----
              _SectionHeader(title: 'Annual Report'),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<int>(
                        value: _selectedAnnualYear,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                        ),
                        items: _yearItems(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _selectedAnnualYear = v);
                          }
                        },
                      ),
                      SizedBox(height: AppDimensions.paddingM),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: state.status == ReportsStatus.generating
                              ? null
                              : () => _generateAnnual(context),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Generate Annual Report'),
                        ),
                      ),
                      if (state.status == ReportsStatus.generating &&
                          state.reportType == ReportType.annual)
                        Padding(
                          padding:
                              EdgeInsets.only(top: AppDimensions.paddingM),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (state.status == ReportsStatus.ready &&
                          state.reportType == ReportType.annual &&
                          state.reportBytes != null) ...[
                        SizedBox(height: AppDimensions.paddingM),
                        _ReportActions(
                          reportBytes: state.reportBytes!,
                          fileName:
                              'finwise_annual_$_selectedAnnualYear.pdf',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<int>> _yearItems() {
    final current = DateTime.now().year;
    return List.generate(6, (i) {
      final y = current - i;
      return DropdownMenuItem(value: y, child: Text('$y'));
    });
  }

  void _generateMonthly(BuildContext context) {
    context.read<ReportsBloc>().add(MonthlyReportRequested(
          year: _selectedYear,
          month: _selectedMonth,
        ));
  }

  void _generateAnnual(BuildContext context) {
    context.read<ReportsBloc>().add(AnnualReportRequested(
          year: _selectedAnnualYear,
        ));
  }
}

// ---------------------------------------------------------------------------
// Report actions (Preview + Share)
// ---------------------------------------------------------------------------
class _ReportActions extends StatelessWidget {
  const _ReportActions({
    required this.reportBytes,
    required this.fileName,
  });

  final List<int> reportBytes;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _preview(context),
            icon: const Icon(Icons.visibility),
            label: const Text('Preview'),
          ),
        ),
        SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _share(context),
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }

  Future<void> _preview(BuildContext context) async {
    await Printing.layoutPdf(
      onLayout: (_) async => Uint8List.fromList(reportBytes),
      name: fileName,
    );
  }

  Future<void> _share(BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(reportBytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Section header (matches settings page pattern)
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingXS,
        bottom: AppDimensions.paddingS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
