import 'package:finwise/features/achievements/domain/entities/achievement_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({required this.achievement, super.key});

  final AchievementEntity achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = achievement.isUnlocked;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: isUnlocked
            ? theme.colorScheme.primary.withValues(alpha: 0.06)
            : theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUnlocked
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: isUnlocked
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.06),
                child: Icon(
                  _getIcon(achievement.iconName),
                  size: 24.w,
                  color: isUnlocked
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface
                          .withValues(alpha: 0.25),
                ),
              ),
              if (!isUnlocked)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock,
                      size: 12.w,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.3),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w500,
              color: isUnlocked
                  ? null
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(height: 2.h),
          if (isUnlocked && achievement.unlockedAt != null)
            Text(
              DateFormat.MMMd().format(achievement.unlockedAt!),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 10.sp,
              ),
            )
          else
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.35),
                fontSize: 9.sp,
              ),
            ),
        ],
      ),
    );
  }

  static IconData _getIcon(String name) {
    return _iconMap[name] ?? Icons.emoji_events;
  }

  static const Map<String, IconData> _iconMap = {
    'receipt': Icons.receipt_long,
    'list': Icons.format_list_numbered,
    'trending_up': Icons.trending_up,
    'star': Icons.star,
    'pie_chart': Icons.pie_chart,
    'dashboard': Icons.dashboard,
    'flag': Icons.flag,
    'trophy': Icons.emoji_events,
    'savings': Icons.savings,
    'diamond': Icons.diamond,
    'local_fire_department': Icons.local_fire_department,
    'whatshot': Icons.whatshot,
    'verified': Icons.verified,
    'account_balance': Icons.account_balance,
  };
}
