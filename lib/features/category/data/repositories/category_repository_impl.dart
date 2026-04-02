import 'package:finwise/core/errors/exceptions.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/category/data/datasources/category_local_datasource.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/domain/repositories/category_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._datasource);

  final CategoryLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await _datasource.getCategories();
      return Right(categories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByType(
    CategoryType type,
  ) async {
    try {
      final categories = await _datasource.getCategoriesByType(type.name);
      return Right(categories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    try {
      final category = await _datasource.getCategoryById(id);
      if (category == null) {
        return const Left(NotFoundFailure(message: 'Category not found'));
      }
      return Right(category);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(
    CategoryEntity category,
  ) async {
    try {
      await _datasource.insertCategory(category);
      return Right(category);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity category,
  ) async {
    try {
      await _datasource.updateCategory(category);
      return Right(category);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _datasource.deleteCategory(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return _datasource.watchCategories();
  }

  @override
  Stream<List<CategoryEntity>> watchCategoriesByType(CategoryType type) {
    return _datasource.watchCategoriesByType(type.name);
  }
}
