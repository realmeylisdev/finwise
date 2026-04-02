part of 'backup_bloc.dart';

enum BackupStatus { initial, exporting, success, failure }

class BackupState extends Equatable {
  const BackupState({
    this.status = BackupStatus.initial,
    this.message,
    this.exportPath,
  });

  final BackupStatus status;
  final String? message;
  final String? exportPath;

  BackupState copyWith({
    BackupStatus? status,
    String? message,
    String? exportPath,
  }) {
    return BackupState(
      status: status ?? this.status,
      message: message,
      exportPath: exportPath,
    );
  }

  @override
  List<Object?> get props => [status, message, exportPath];
}
