import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/domain/usecases/create_category_usecase.dart';
import 'package:finwise/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:finwise/features/category/domain/usecases/get_categories_by_type_usecase.dart';
import 'package:finwise/features/category/domain/usecases/update_category_usecase.dart';
import 'package:injectable/injectable.dart';

part 'category_event.dart';
part 'category_state.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required GetCategoriesByTypeUseCase getCategoriesByType,
    required CreateCategoryUseCase createCategory,
    required UpdateCategoryUseCase updateCategory,
    required DeleteCategoryUseCase deleteCategory,
  })  : _getCategoriesByType = getCategoriesByType,
        _createCategory = createCategory,
        _updateCategory = updateCategory,
        _deleteCategory = deleteCategory,
        super(const CategoryState()) {
    on<CategoriesLoaded>(_onLoaded, transformer: droppable());
    on<CategoryCreated>(_onCreated, transformer: droppable());
    on<CategoryUpdated>(_onUpdated, transformer: droppable());
    on<CategoryDeleted>(_onDeleted, transformer: droppable());
  }

  final GetCategoriesByTypeUseCase _getCategoriesByType;
  final CreateCategoryUseCase _createCategory;
  final UpdateCategoryUseCase _updateCategory;
  final DeleteCategoryUseCase _deleteCategory;

  Future<void> _onLoaded(
    CategoriesLoaded event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final expenseResult = await _getCategoriesByType(CategoryType.expense);
    final incomeResult = await _getCategoriesByType(CategoryType.income);

    final expense = expenseResult.getOrElse((_) => []);
    final income = incomeResult.getOrElse((_) => []);

    emit(
      state.copyWith(
        status: CategoryStatus.success,
        expenseCategories: expense,
        incomeCategories: income,
      ),
    );
  }

  Future<void> _onCreated(
    CategoryCreated event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await _createCategory(event.category);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const CategoriesLoaded()),
    );
  }

  Future<void> _onUpdated(
    CategoryUpdated event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await _updateCategory(event.category);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const CategoriesLoaded()),
    );
  }

  Future<void> _onDeleted(
    CategoryDeleted event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await _deleteCategory(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (_) => add(const CategoriesLoaded()),
    );
  }
}
