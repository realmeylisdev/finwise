import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/debt_payments_dao.dart';
import 'package:finwise/core/database/daos/debts_dao.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_payment_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class DebtPayoffLocalDatasource {
  DebtPayoffLocalDatasource(this._debtsDao, this._paymentsDao);

  final DebtsDao _debtsDao;
  final DebtPaymentsDao _paymentsDao;

  // ── Debts ──────────────────────────────────────────────────────────────

  Future<List<DebtEntity>> getAllDebts() async {
    final rows = await _debtsDao.getAllDebts();
    return rows.map(_toDebtEntity).toList();
  }

  Future<void> insertDebt(DebtEntity entity) async {
    await _debtsDao.insertDebt(
      DebtsCompanion.insert(
        id: entity.id,
        name: entity.name,
        type: DebtEntity.typeToString(entity.type),
        balance: entity.balance,
        interestRate: Value(entity.interestRate),
        minimumPayment: Value(entity.minimumPayment),
        currencyCode: entity.currencyCode,
        notes: Value(entity.notes),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateDebt(DebtEntity entity) async {
    await _debtsDao.updateDebt(
      DebtsCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        type: Value(DebtEntity.typeToString(entity.type)),
        balance: Value(entity.balance),
        interestRate: Value(entity.interestRate),
        minimumPayment: Value(entity.minimumPayment),
        currencyCode: Value(entity.currencyCode),
        notes: Value(entity.notes),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteDebt(String id) async {
    await _debtsDao.deleteDebt(id);
  }

  // ── Payments ───────────────────────────────────────────────────────────

  Future<List<DebtPaymentEntity>> getPaymentsForDebt(String debtId) async {
    final rows = await _paymentsDao.getPaymentsForDebt(debtId);
    return rows.map(_toPaymentEntity).toList();
  }

  Future<void> insertPayment(DebtPaymentEntity entity) async {
    await _paymentsDao.insertPayment(
      DebtPaymentsCompanion.insert(
        id: entity.id,
        debtId: entity.debtId,
        amount: entity.amount,
        date: entity.date,
        note: Value(entity.note),
      ),
    );
  }

  Future<void> deletePayment(String id) async {
    await _paymentsDao.deletePayment(id);
  }

  // ── Mappers ────────────────────────────────────────────────────────────

  DebtEntity _toDebtEntity(DebtRow row) {
    return DebtEntity(
      id: row.id,
      name: row.name,
      type: DebtEntity.typeFromString(row.type),
      balance: row.balance,
      interestRate: row.interestRate,
      minimumPayment: row.minimumPayment,
      currencyCode: row.currencyCode,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  DebtPaymentEntity _toPaymentEntity(DebtPaymentRow row) {
    return DebtPaymentEntity(
      id: row.id,
      debtId: row.debtId,
      amount: row.amount,
      date: row.date,
      note: row.note,
    );
  }
}
