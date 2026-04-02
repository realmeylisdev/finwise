import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByType(
    CategoryType type,
  );
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);
  Future<Either<Failure, CategoryEntity>> createCategory(
    CategoryEntity category,
  );
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity category,
  );
  Future<Either<Failure, void>> deleteCategory(String id);
  Stream<List<CategoryEntity>> watchCategories();
  Stream<List<CategoryEntity>> watchCategoriesByType(CategoryType type);
}
