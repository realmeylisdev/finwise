import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    required this.onTap,
    super.key,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = _iconAndColor(notification.type);
    final timeAgo = _formatTimeAgo(notification.createdAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: color.withValues(alpha: 0.12),
              child: HugeIcon(
                icon: icon,
                size: 20.w,
                color: color,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          notification.isRead ? FontWeight.w400 : FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    notification.body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeAgo,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!notification.isRead) ...[
                  SizedBox(height: 6.h),
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  (List<List<dynamic>>, Color) _iconAndColor(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return (HugeIcons.strokeRoundedPieChart01, const Color(0xFFF59E0B));
      case NotificationType.billReminder:
        return (HugeIcons.strokeRoundedInvoice03, const Color(0xFFEF4444));
      case NotificationType.insight:
        return (HugeIcons.strokeRoundedIdea01, const Color(0xFF8B5CF6));
      case NotificationType.goalMilestone:
        return (HugeIcons.strokeRoundedFlag02, const Color(0xFF22C55E));
      case NotificationType.weeklyDigest:
        return (HugeIcons.strokeRoundedCalendar03, const Color(0xFF3B82F6));
      case NotificationType.achievement:
        return (HugeIcons.strokeRoundedAward01, const Color(0xFFF59E0B));
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
