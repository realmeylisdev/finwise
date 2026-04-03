import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/investment_history_dao.dart';
import 'package:finwise/core/database/daos/investments_dao.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';
import 'package:finwise/features/investments/domain/entities/investment_performance_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class InvestmentsLocalDatasource {
  InvestmentsLocalDatasource(this._investmentsDao, this._historyDao);

  final InvestmentsDao _investmentsDao;
  final InvestmentHistoryDao _historyDao;

  // ── Investments ──

  Future<List<InvestmentEntity>> getInvestments() async {
    final rows = await _investmentsDao.getAllInvestments();
    return rows.map(_toEntity).toList();
  }

  Future<void> insertInvestment(InvestmentEntity entity) async {
    await _investmentsDao.insertInvestment(
      InvestmentsCompanion.insert(
        id: entity.id,
        name: entity.name,
        type: InvestmentEntity.typeToString(entity.type),
        ticker: Value(entity.ticker),
        units: entity.units,
        costBasis: entity.costBasis,
        currentPrice: entity.currentPrice,
        currencyCode: entity.currencyCode,
        notes: Value(entity.notes),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateInvestment(InvestmentEntity entity) async {
    await _investmentsDao.updateInvestment(
      InvestmentsCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        type: Value(InvestmentEntity.typeToString(entity.type)),
        ticker: Value(entity.ticker),
        units: Value(entity.units),
        costBasis: Value(entity.costBasis),
        currentPrice: Value(entity.currentPrice),
        currencyCode: Value(entity.currencyCode),
        notes: Value(entity.notes),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteInvestment(String id) async {
    await _investmentsDao.deleteInvestment(id);
  }

  Future<InvestmentPerformanceEntity> getPerformance() async {
    final rows = await _investmentsDao.getAllInvestments();
    final entities = rows.map(_toEntity).toList();

    double totalValue = 0;
    double totalCostBasis = 0;
    final allocationByType = <InvestmentType, double>{};

    for (final e in entities) {
      totalValue += e.currentValue;
      totalCostBasis += e.costBasis;

      allocationByType.update(
        e.type,
        (existing) => existing + e.currentValue,
        ifAbsent: () => e.currentValue,
      );
    }

    final totalGainLoss = totalValue - totalCostBasis;
    final totalGainLossPercent =
        totalCostBasis > 0 ? (totalGainLoss / totalCostBasis * 100) : 0.0;

    return InvestmentPerformanceEntity(
      totalValue: totalValue,
      totalCostBasis: totalCostBasis,
      totalGainLoss: totalGainLoss,
      totalGainLossPercent: totalGainLossPercent,
      allocationByType: allocationByType,
    );
  }

  Future<void> recordPriceHistory(String investmentId, double price) async {
    await _historyDao.insertHistory(
      InvestmentHistoryCompanion.insert(
        id: const Uuid().v4(),
        investmentId: investmentId,
        price: price,
        date: DateTime.now(),
      ),
    );
  }

  // ── Mapper ──

  InvestmentEntity _toEntity(InvestmentRow row) {
    return InvestmentEntity(
      id: row.id,
      name: row.name,
      type: InvestmentEntity.typeFromString(row.type),
      ticker: row.ticker,
      units: row.units,
      costBasis: row.costBasis,
      currentPrice: row.currentPrice,
      currencyCode: row.currencyCode,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
