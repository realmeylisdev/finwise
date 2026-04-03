import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:finwise/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocSelector<NotificationsBloc, NotificationsState, int>(
            selector: (state) => state.unreadCount,
            builder: (context, unreadCount) {
              if (unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context
                    .read<NotificationsBloc>()
                    .add(const AllNotificationsRead()),
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NotificationsStatus.failure) {
            return Center(
              child: Text(state.failureMessage ?? 'Something went wrong'),
            );
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(
                    icon: HugeIcons.strokeRoundedNotification03,
                    size: 48.w,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'All caught up!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'No notifications at the moment',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            itemCount: state.notifications.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 68.w,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return Dismissible(
                key: ValueKey(notification.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 24.w),
                  color: const Color(0xFFEF4444),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                onDismissed: (_) => context
                    .read<NotificationsBloc>()
                    .add(NotificationDeleted(notification.id)),
                child: NotificationTile(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      context
                          .read<NotificationsBloc>()
                          .add(NotificationRead(notification.id));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
