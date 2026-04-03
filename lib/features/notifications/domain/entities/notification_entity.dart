import 'package:equatable/equatable.dart';

enum NotificationType {
  budgetAlert,
  billReminder,
  insight,
  goalMilestone,
  weeklyDigest,
  achievement,
}

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.isRead = false,
    this.data,
    required this.createdAt,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;
  final String? data;
  final DateTime createdAt;

  NotificationEntity copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? body,
    bool? isRead,
    String? data,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static NotificationType typeFromString(String value) {
    switch (value) {
      case 'budget_alert':
        return NotificationType.budgetAlert;
      case 'bill_reminder':
        return NotificationType.billReminder;
      case 'insight':
        return NotificationType.insight;
      case 'goal_milestone':
        return NotificationType.goalMilestone;
      case 'weekly_digest':
        return NotificationType.weeklyDigest;
      case 'achievement':
        return NotificationType.achievement;
      default:
        return NotificationType.insight;
    }
  }

  static String typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return 'budget_alert';
      case NotificationType.billReminder:
        return 'bill_reminder';
      case NotificationType.insight:
        return 'insight';
      case NotificationType.goalMilestone:
        return 'goal_milestone';
      case NotificationType.weeklyDigest:
        return 'weekly_digest';
      case NotificationType.achievement:
        return 'achievement';
    }
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        body,
        isRead,
        data,
        createdAt,
      ];
}
