import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/notifications/domain/entities/notification_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, void>> createNotification(NotificationEntity entity);
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String id);
  Future<Either<Failure, void>> clearOld(DateTime cutoff);
}
