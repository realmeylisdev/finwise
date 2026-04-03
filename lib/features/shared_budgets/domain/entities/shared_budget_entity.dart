import 'package:equatable/equatable.dart';

enum AccessLevel { owner, editor, viewer }

class SharedBudgetEntity extends Equatable {
  const SharedBudgetEntity({
    required this.id,
    required this.budgetId,
    required this.profileId,
    required this.profileName,
    this.accessLevel = AccessLevel.viewer,
  });

  final String id;
  final String budgetId;
  final String profileId;
  final String profileName;
  final AccessLevel accessLevel;

  SharedBudgetEntity copyWith({
    String? id,
    String? budgetId,
    String? profileId,
    String? profileName,
    AccessLevel? accessLevel,
  }) {
    return SharedBudgetEntity(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      profileId: profileId ?? this.profileId,
      profileName: profileName ?? this.profileName,
      accessLevel: accessLevel ?? this.accessLevel,
    );
  }

  static String accessLevelToString(AccessLevel level) {
    switch (level) {
      case AccessLevel.owner:
        return 'owner';
      case AccessLevel.editor:
        return 'editor';
      case AccessLevel.viewer:
        return 'viewer';
    }
  }

  static AccessLevel accessLevelFromString(String value) {
    switch (value) {
      case 'owner':
        return AccessLevel.owner;
      case 'editor':
        return AccessLevel.editor;
      case 'viewer':
      default:
        return AccessLevel.viewer;
    }
  }

  static String accessLevelDisplayName(AccessLevel level) {
    switch (level) {
      case AccessLevel.owner:
        return 'Owner';
      case AccessLevel.editor:
        return 'Editor';
      case AccessLevel.viewer:
        return 'Viewer';
    }
  }

  @override
  List<Object?> get props =>
      [id, budgetId, profileId, profileName, accessLevel];
}
