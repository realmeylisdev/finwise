part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.incomeCategories = const [],
    this.expenseCategories = const [],
    this.failureMessage,
  });

  final CategoryStatus status;
  final List<CategoryEntity> incomeCategories;
  final List<CategoryEntity> expenseCategories;
  final String? failureMessage;

  List<CategoryEntity> get allCategories => [
        ...expenseCategories,
        ...incomeCategories,
      ];

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? incomeCategories,
    List<CategoryEntity>? expenseCategories,
    String? failureMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incomeCategories,
        expenseCategories,
        failureMessage,
      ];
}
