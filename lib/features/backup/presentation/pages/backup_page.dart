import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Export')),
      body: BlocConsumer<BackupBloc, BackupState>(
        listener: (context, state) {
          if (state.status == BackupStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Done')),
            );
          }
          if (state.status == BackupStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Failed'),
                backgroundColor: AppColors.expense,
              ),
            );
          }
        },
        builder: (context, state) {
          final isExporting = state.status == BackupStatus.exporting;

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Export section
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.file_download_outlined,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: AppDimensions.paddingS),
                          Text(
                            'Export Transactions',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'Export all transactions to a CSV file that '
                        'can be opened in Excel or Google Sheets.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      SizedBox(height: AppDimensions.paddingM),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isExporting
                              ? null
                              : () => context
                                  .read<BackupBloc>()
                                  .add(const ExportCsvRequested()),
                          icon: isExporting
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.share),
                          label: Text(
                            isExporting ? 'Exporting...' : 'Export CSV',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Backup section
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.backup_outlined,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: AppDimensions.paddingS),
                          Text(
                            'Database Backup',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'Create a full backup of your database. '
                        'Save it somewhere safe to restore later.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      SizedBox(height: AppDimensions.paddingM),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isExporting
                              ? null
                              : () => context
                                  .read<BackupBloc>()
                                  .add(const BackupDatabaseRequested()),
                          icon: const Icon(Icons.save),
                          label: const Text('Create Backup'),
                        ),
                      ),
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
}
