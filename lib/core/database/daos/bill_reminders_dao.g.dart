// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_reminders_dao.dart';

// ignore_for_file: type=lint
mixin _$BillRemindersDaoMixin on DatabaseAccessor<AppDatabase> {
  $BillRemindersTable get billReminders => attachedDatabase.billReminders;
  BillRemindersDaoManager get managers => BillRemindersDaoManager(this);
}

class BillRemindersDaoManager {
  final _$BillRemindersDaoMixin _db;
  BillRemindersDaoManager(this._db);
  $$BillRemindersTableTableManager get billReminders =>
      $$BillRemindersTableTableManager(_db.attachedDatabase, _db.billReminders);
}
