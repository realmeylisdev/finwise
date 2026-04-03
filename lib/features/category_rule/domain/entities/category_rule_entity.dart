import 'package:equatable/equatable.dart';

class CategoryRuleEntity extends Equatable {
  const CategoryRuleEntity({
    required this.id,
    required this.keyword,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String keyword;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final int categoryColor;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryRuleEntity copyWith({
    String? id,
    String? keyword,
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    int? categoryColor,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryRuleEntity(
      id: id ?? this.id,
      keyword: keyword ?? this.keyword,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColor: categoryColor ?? this.categoryColor,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        keyword,
        categoryId,
        categoryName,
        categoryIcon,
        categoryColor,
        isActive,
        createdAt,
        updatedAt,
      ];
}
