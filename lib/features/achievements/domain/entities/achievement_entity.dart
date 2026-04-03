import 'package:equatable/equatable.dart';

class AchievementEntity extends Equatable {
  const AchievementEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.iconName,
    this.unlockedAt,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String title;
  final String description;
  final String iconName;
  final DateTime? unlockedAt;
  final DateTime createdAt;

  bool get isUnlocked => unlockedAt != null;

  AchievementEntity copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? iconName,
    DateTime? unlockedAt,
    DateTime? createdAt,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        iconName,
        unlockedAt,
        createdAt,
      ];
}
