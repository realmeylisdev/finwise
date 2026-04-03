import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/investment_history_table.dart';

part 'investment_history_dao.g.dart';

@DriftAccessor(tables: [InvestmentHistory])
class InvestmentHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$InvestmentHistoryDaoMixin {
  InvestmentHistoryDao(super.db);

  Future<List<InvestmentHistoryRow>> getHistoryForInvestment(
    String investmentId,
  ) =>
      (select(investmentHistory)
            ..where((t) => t.investmentId.equals(investmentId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<int> insertHistory(InvestmentHistoryCompanion entry) =>
      into(investmentHistory).insert(entry);

  Future<InvestmentHistoryRow?> getLatestPrice(String investmentId) =>
      (select(investmentHistory)
            ..where((t) => t.investmentId.equals(investmentId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(1))
          .getSingleOrNull();
}
