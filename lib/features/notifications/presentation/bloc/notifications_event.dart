part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}

class NotificationsLoaded extends NotificationsEvent {
  const NotificationsLoaded();
}

class NotificationRead extends NotificationsEvent {
  const NotificationRead(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class AllNotificationsRead extends NotificationsEvent {
  const AllNotificationsRead();
}

class NotificationDeleted extends NotificationsEvent {
  const NotificationDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class WeeklyDigestGenerated extends NotificationsEvent {
  const WeeklyDigestGenerated();
}
