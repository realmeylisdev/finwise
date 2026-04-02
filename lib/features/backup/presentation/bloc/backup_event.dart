part of 'backup_bloc.dart';

abstract class BackupEvent extends Equatable {
  const BackupEvent();
  @override
  List<Object?> get props => [];
}

class ExportCsvRequested extends BackupEvent {
  const ExportCsvRequested();
}

class BackupDatabaseRequested extends BackupEvent {
  const BackupDatabaseRequested();
}
