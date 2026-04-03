import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/subscriptions_dao.dart';
import 'package:finwise/features/subscription/domain/entities/subscription_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscriptionLocalDatasource {
  SubscriptionLocalDatasource(this._dao);

  final SubscriptionsDao _dao;

  Future<List<SubscriptionEntity>> getAllSubscriptions() async {
    final rows = await _dao.getAllSubscriptions();
    return rows.map(_toEntity).toList();
  }

  Future<List<SubscriptionEntity>> getActiveSubscriptions() async {
    final rows = await _dao.getActiveSubscriptions();
    return rows.map(_toEntity).toList();
  }

  Future<void> insertSubscription(SubscriptionEntity entity) async {
    await _dao.insertSubscription(
      SubscriptionsCompanion.insert(
        id: entity.id,
        name: entity.name,
        amount: entity.amount,
        currencyCode: entity.currencyCode,
        billingCycle: SubscriptionEntity.cycleToString(entity.billingCycle),
        nextBillingDate: entity.nextBillingDate,
        categoryId: Value(entity.categoryId),
        icon: Value(entity.icon),
        color: Value(entity.color),
        isActive: Value(entity.isActive),
        notes: Value(entity.notes),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateSubscription(SubscriptionEntity entity) async {
    await _dao.updateSubscription(
      SubscriptionsCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        amount: Value(entity.amount),
        currencyCode: Value(entity.currencyCode),
        billingCycle:
            Value(SubscriptionEntity.cycleToString(entity.billingCycle)),
        nextBillingDate: Value(entity.nextBillingDate),
        categoryId: Value(entity.categoryId),
        icon: Value(entity.icon),
        color: Value(entity.color),
        isActive: Value(entity.isActive),
        notes: Value(entity.notes),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteSubscription(String id) async {
    await _dao.deleteSubscription(id);
  }

  Future<double> getTotalMonthlyAmount() async {
    return _dao.getTotalMonthlyAmount();
  }

  SubscriptionEntity _toEntity(SubscriptionRow row) {
    return SubscriptionEntity(
      id: row.id,
      name: row.name,
      amount: row.amount,
      currencyCode: row.currencyCode,
      billingCycle: SubscriptionEntity.cycleFromString(row.billingCycle),
      nextBillingDate: row.nextBillingDate,
      categoryId: row.categoryId,
      icon: row.icon,
      color: row.color,
      isActive: row.isActive,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
