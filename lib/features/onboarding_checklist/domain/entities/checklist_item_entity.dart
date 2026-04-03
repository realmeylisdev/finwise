import 'package:equatable/equatable.dart';

class ChecklistItemEntity extends Equatable {
  const ChecklistItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.route,
    this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String route; // navigation route when tapped
  final String? iconName;

  @override
  List<Object?> get props => [id, title, description, isCompleted, route, iconName];
}
