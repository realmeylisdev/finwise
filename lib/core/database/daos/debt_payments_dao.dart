import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/debt_payments_table.dart';

part 'debt_payments_dao.g.dart';

@DriftAccessor(tables: [DebtPayments])
class DebtPaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$DebtPaymentsDaoMixin {
  DebtPaymentsDao(super.db);

  Future<List<DebtPaymentRow>> getPaymentsForDebt(String debtId) =>
      (select(debtPayments)
            ..where((t) => t.debtId.equals(debtId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<int> insertPayment(DebtPaymentsCompanion entry) =>
      into(debtPayments).insert(entry);

  Future<int> deletePayment(String id) =>
      (delete(debtPayments)..where((t) => t.id.equals(id))).go();

  Future<double> getTotalPaidForDebt(String debtId) async {
    final rows = await getPaymentsForDebt(debtId);
    var total = 0.0;
    for (final row in rows) {
      total += row.amount;
    }
    return total;
  }
}
