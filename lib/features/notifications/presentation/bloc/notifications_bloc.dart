import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/notifications/domain/entities/notification_entity.dart';
import 'package:finwise/features/notifications/domain/repositories/notification_repository.dart';
import 'package:finwise/features/notifications/domain/usecases/generate_weekly_digest_usecase.dart';
import 'package:injectable/injectable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({
    required NotificationRepository repository,
    required GenerateWeeklyDigestUseCase generateWeeklyDigestUseCase,
  })  : _repository = repository,
        _generateWeeklyDigestUseCase = generateWeeklyDigestUseCase,
        super(const NotificationsState()) {
    on<NotificationsLoaded>(_onLoaded, transformer: droppable());
    on<NotificationRead>(_onRead, transformer: droppable());
    on<AllNotificationsRead>(_onAllRead, transformer: droppable());
    on<NotificationDeleted>(_onDeleted, transformer: droppable());
    on<WeeklyDigestGenerated>(_onWeeklyDigest, transformer: droppable());
  }

  final NotificationRepository _repository;
  final GenerateWeeklyDigestUseCase _generateWeeklyDigestUseCase;

  Future<void> _onLoaded(
    NotificationsLoaded event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    final result = await _repository.getNotifications();
    final countResult = await _repository.getUnreadCount();

    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationsStatus.failure,
        failureMessage: failure.message,
      )),
      (notifications) {
        final unread = countResult.fold((_) => 0, (count) => count);
        emit(state.copyWith(
          status: NotificationsStatus.success,
          notifications: notifications,
          unreadCount: unread,
        ));
      },
    );
  }

  Future<void> _onRead(
    NotificationRead event,
    Emitter<NotificationsState> emit,
  ) async {
    await _repository.markAsRead(event.id);

    final updated = state.notifications.map((n) {
      if (n.id == event.id) return n.copyWith(isRead: true);
      return n;
    }).toList();

    final countResult = await _repository.getUnreadCount();
    final unread = countResult.fold((_) => state.unreadCount, (c) => c);

    emit(state.copyWith(
      notifications: updated,
      unreadCount: unread,
    ));
  }

  Future<void> _onAllRead(
    AllNotificationsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    await _repository.markAllAsRead();

    final updated =
        state.notifications.map((n) => n.copyWith(isRead: true)).toList();

    emit(state.copyWith(
      notifications: updated,
      unreadCount: 0,
    ));
  }

  Future<void> _onDeleted(
    NotificationDeleted event,
    Emitter<NotificationsState> emit,
  ) async {
    await _repository.deleteNotification(event.id);

    final updated =
        state.notifications.where((n) => n.id != event.id).toList();
    final countResult = await _repository.getUnreadCount();
    final unread = countResult.fold((_) => state.unreadCount, (c) => c);

    emit(state.copyWith(
      notifications: updated,
      unreadCount: unread,
    ));
  }

  Future<void> _onWeeklyDigest(
    WeeklyDigestGenerated event,
    Emitter<NotificationsState> emit,
  ) async {
    await _generateWeeklyDigestUseCase();
    add(const NotificationsLoaded());
  }
}
