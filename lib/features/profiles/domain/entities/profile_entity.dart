import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.name,
    this.email,
    this.avatarColor = 0xFF6366F1,
    this.isOwner = false,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? email;
  final int avatarColor;
  final bool isOwner;
  final DateTime createdAt;

  ProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    int? avatarColor,
    bool? isOwner,
    DateTime? createdAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarColor: avatarColor ?? this.avatarColor,
      isOwner: isOwner ?? this.isOwner,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Initials derived from name for avatar display.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [id, name, email, avatarColor, isOwner, createdAt];
}
