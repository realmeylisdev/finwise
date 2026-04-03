import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/notifications_dao.dart';
import 'package:finwise/features/notifications/domain/entities/notification_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationLocalDatasource {
  NotificationLocalDatasource(this._notificationsDao);

  final NotificationsDao _notificationsDao;

  Future<List<NotificationEntity>> getAllNotifications() async {
    final rows = await _notificationsDao.getAllNotifications();
    return rows.map(_toEntity).toList();
  }

  Future<int> getUnreadCount() => _notificationsDao.getUnreadCount();

  Future<void> insertNotification(NotificationEntity entity) async {
    await _notificationsDao.insertNotification(
      NotificationsCompanion.insert(
        id: entity.id,
        type: NotificationEntity.typeToString(entity.type),
        title: entity.title,
        body: entity.body,
        isRead: Value(entity.isRead),
        data: Value(entity.data),
        createdAt: entity.createdAt,
      ),
    );
  }

  Future<void> markAsRead(String id) => _notificationsDao.markAsRead(id);

  Future<void> markAllAsRead() => _notificationsDao.markAllAsRead();

  Future<void> deleteNotification(String id) =>
      _notificationsDao.deleteNotification(id);

  Future<void> deleteOlderThan(DateTime cutoff) =>
      _notificationsDao.deleteOlderThan(cutoff);

  NotificationEntity _toEntity(NotificationRow row) {
    return NotificationEntity(
      id: row.id,
      type: NotificationEntity.typeFromString(row.type),
      title: row.title,
      body: row.body,
      isRead: row.isRead,
      data: row.data,
      createdAt: row.createdAt,
    );
  }
}
