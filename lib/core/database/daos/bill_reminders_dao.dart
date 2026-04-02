import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/bill_reminders_table.dart';

part 'bill_reminders_dao.g.dart';

@DriftAccessor(tables: [BillReminders])
class BillRemindersDao extends DatabaseAccessor<AppDatabase>
    with _$BillRemindersDaoMixin {
  BillRemindersDao(super.db);

  Future<List<BillReminderRow>> getActiveBills() =>
      (select(billReminders)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.dueDay)]))
          .get();

  Stream<List<BillReminderRow>> watchActiveBills() =>
      (select(billReminders)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.dueDay)]))
          .watch();

  Future<List<BillReminderRow>> getAllBills() =>
      (select(billReminders)
            ..orderBy([(t) => OrderingTerm.asc(t.dueDay)]))
          .get();

  Future<BillReminderRow?> getBillById(String id) =>
      (select(billReminders)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<BillReminderRow>> getUpcomingBills(int today, int days) {
    final endDay = today + days;
    return (select(billReminders)
          ..where(
            (t) =>
                t.isActive.equals(true) &
                t.dueDay.isBiggerOrEqualValue(today) &
                t.dueDay.isSmallerOrEqualValue(endDay),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.dueDay)]))
        .get();
  }

  Future<int> insertBill(BillRemindersCompanion entry) =>
      into(billReminders).insert(entry);

  Future<bool> updateBill(BillRemindersCompanion entry) =>
      (update(billReminders)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteBill(String id) =>
      (delete(billReminders)..where((t) => t.id.equals(id))).go();
}
