import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/bill_reminders_dao.dart';
import 'package:finwise/features/bill_reminder/domain/entities/bill_reminder_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class BillReminderLocalDatasource {
  BillReminderLocalDatasource(this._dao);

  final BillRemindersDao _dao;

  Future<List<BillReminderEntity>> getActiveBills() async {
    final rows = await _dao.getActiveBills();
    return rows.map(_toEntity).toList();
  }

  Future<List<BillReminderEntity>> getAllBills() async {
    final rows = await _dao.getAllBills();
    return rows.map(_toEntity).toList();
  }

  Future<List<BillReminderEntity>> getUpcomingBills(
    int today,
    int days,
  ) async {
    final rows = await _dao.getUpcomingBills(today, days);
    return rows.map(_toEntity).toList();
  }

  Future<void> insertBill(BillReminderEntity entity) async {
    await _dao.insertBill(
      BillRemindersCompanion.insert(
        id: entity.id,
        name: entity.name,
        amount: entity.amount,
        categoryId: Value(entity.categoryId),
        accountId: Value(entity.accountId),
        currencyCode: entity.currencyCode,
        dueDay: entity.dueDay,
        note: Value(entity.note),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateBill(BillReminderEntity entity) async {
    await _dao.updateBill(
      BillRemindersCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        amount: Value(entity.amount),
        categoryId: Value(entity.categoryId),
        accountId: Value(entity.accountId),
        dueDay: Value(entity.dueDay),
        note: Value(entity.note),
        isActive: Value(entity.isActive),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteBill(String id) async {
    await _dao.deleteBill(id);
  }

  BillReminderEntity _toEntity(BillReminderRow row) {
    return BillReminderEntity(
      id: row.id,
      name: row.name,
      amount: row.amount,
      categoryId: row.categoryId,
      accountId: row.accountId,
      currencyCode: row.currencyCode,
      dueDay: row.dueDay,
      note: row.note,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
