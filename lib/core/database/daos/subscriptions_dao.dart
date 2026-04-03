import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/subscriptions_table.dart';

part 'subscriptions_dao.g.dart';

@DriftAccessor(tables: [Subscriptions])
class SubscriptionsDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionsDaoMixin {
  SubscriptionsDao(super.db);

  Future<List<SubscriptionRow>> getAllSubscriptions() =>
      (select(subscriptions)
            ..orderBy([(t) => OrderingTerm.asc(t.nextBillingDate)]))
          .get();

  Future<List<SubscriptionRow>> getActiveSubscriptions() =>
      (select(subscriptions)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.nextBillingDate)]))
          .get();

  Future<int> insertSubscription(SubscriptionsCompanion entry) =>
      into(subscriptions).insert(entry);

  Future<bool> updateSubscription(SubscriptionsCompanion entry) =>
      (update(subscriptions)
            ..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteSubscription(String id) =>
      (delete(subscriptions)..where((t) => t.id.equals(id))).go();

  /// Returns the total monthly cost by converting each subscription's amount
  /// to its monthly equivalent based on its billing cycle.
  Future<double> getTotalMonthlyAmount() async {
    final rows = await getActiveSubscriptions();
    var total = 0.0;
    for (final row in rows) {
      switch (row.billingCycle) {
        case 'weekly':
          total += row.amount * 52 / 12;
        case 'monthly':
          total += row.amount;
        case 'quarterly':
          total += row.amount / 3;
        case 'yearly':
          total += row.amount / 12;
      }
    }
    return total;
  }
}
