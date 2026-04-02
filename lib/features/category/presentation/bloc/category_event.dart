part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class CategoriesLoaded extends CategoryEvent {
  const CategoriesLoaded();
}

class CategoryCreated extends CategoryEvent {
  const CategoryCreated(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

class CategoryUpdated extends CategoryEvent {
  const CategoryUpdated(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

class CategoryDeleted extends CategoryEvent {
  const CategoryDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
