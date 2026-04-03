import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/notifications_table.dart';

part 'notifications_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationsDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationsDaoMixin {
  NotificationsDao(super.db);

  Future<List<NotificationRow>> getAllNotifications() =>
      (select(notifications)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<NotificationRow>> getUnreadNotifications() =>
      (select(notifications)
            ..where((t) => t.isRead.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> getUnreadCount() async {
    final count = notifications.id.count();
    final query = selectOnly(notifications)
      ..addColumns([count])
      ..where(notifications.isRead.equals(false));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<void> insertNotification(NotificationsCompanion entry) =>
      into(notifications).insert(entry);

  Future<void> markAsRead(String id) async {
    await (update(notifications)..where((t) => t.id.equals(id))).write(
      const NotificationsCompanion(isRead: Value(true)),
    );
  }

  Future<void> markAllAsRead() async {
    await (update(notifications)..where((t) => t.isRead.equals(false))).write(
      const NotificationsCompanion(isRead: Value(true)),
    );
  }

  Future<void> deleteNotification(String id) async {
    await (delete(notifications)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteOlderThan(DateTime cutoff) async {
    await (delete(notifications)
          ..where((t) => t.createdAt.isSmallerThanValue(cutoff)))
        .go();
  }
}
