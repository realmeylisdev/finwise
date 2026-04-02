import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/core/constants/db_constants.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'backup_event.dart';
part 'backup_state.dart';

@injectable
class BackupBloc extends Bloc<BackupEvent, BackupState> {
  BackupBloc({
    required TransactionRepository transactionRepository,
  })  : _transactionRepo = transactionRepository,
        super(const BackupState()) {
    on<ExportCsvRequested>(_onExportCsv);
    on<BackupDatabaseRequested>(_onBackupDb);
  }

  final TransactionRepository _transactionRepo;

  Future<void> _onExportCsv(
    ExportCsvRequested event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(status: BackupStatus.exporting));

    try {
      final result = await _transactionRepo.getTransactions();
      final transactions = result.getOrElse((_) => []);

      final rows = <List<String>>[
        // Header
        [
          'Date',
          'Type',
          'Category',
          'Account',
          'Amount',
          'Currency',
          'Note',
        ],
        // Data
        ...transactions.map(
          (t) => [
            DateFormat('yyyy-MM-dd HH:mm').format(t.date),
            t.type.name,
            t.categoryName ?? '',
            t.accountName ?? '',
            t.amount.toStringAsFixed(2),
            t.currencyCode,
            t.note ?? '',
          ],
        ),
      ];

      final csvData = Csv().encode(rows);
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = p.join(dir.path, 'finwise_export_$timestamp.csv');
      final file = File(filePath);
      await file.writeAsString(csvData);

      await Share.shareXFiles([XFile(filePath)]);

      emit(state.copyWith(
        status: BackupStatus.success,
        message: 'CSV exported successfully',
        exportPath: filePath,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BackupStatus.failure,
        message: 'Export failed: $e',
      ));
    }
  }

  Future<void> _onBackupDb(
    BackupDatabaseRequested event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(status: BackupStatus.exporting));

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(docsDir.path, DbConstants.databaseName));

      if (!dbFile.existsSync()) {
        emit(state.copyWith(
          status: BackupStatus.failure,
          message: 'Database file not found',
        ));
        return;
      }

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final backupPath = p.join(
        docsDir.path,
        'finwise_backup_$timestamp.db',
      );
      await dbFile.copy(backupPath);

      await Share.shareXFiles([XFile(backupPath)]);

      emit(state.copyWith(
        status: BackupStatus.success,
        message: 'Database backup created',
        exportPath: backupPath,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BackupStatus.failure,
        message: 'Backup failed: $e',
      ));
    }
  }
}
