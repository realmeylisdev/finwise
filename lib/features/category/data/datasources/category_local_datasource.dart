import 'package:drift/drift.dart';
import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/categories_dao.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryLocalDatasource {
  CategoryLocalDatasource(this._dao);

  final CategoriesDao _dao;

  Future<List<CategoryEntity>> getCategories() async {
    final rows = await _dao.getAllCategories();
    return rows.map(_toEntity).toList();
  }

  Future<List<CategoryEntity>> getCategoriesByType(String type) async {
    final rows = await _dao.getCategoriesByType(type);
    return rows.map(_toEntity).toList();
  }

  Stream<List<CategoryEntity>> watchCategories() {
    return _dao.watchAllCategories().map(
          (rows) => rows.map(_toEntity).toList(),
        );
  }

  Stream<List<CategoryEntity>> watchCategoriesByType(String type) {
    return _dao.watchCategoriesByType(type).map(
          (rows) => rows.map(_toEntity).toList(),
        );
  }

  Future<CategoryEntity?> getCategoryById(String id) async {
    final row = await _dao.getCategoryById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> insertCategory(CategoryEntity entity) async {
    await _dao.insertCategory(
      CategoriesCompanion.insert(
        id: entity.id,
        name: entity.name,
        type: entity.type.name,
        icon: entity.icon,
        color: entity.color,
        parentId: Value(entity.parentId),
        isDefault: Value(entity.isDefault),
        sortOrder: Value(entity.sortOrder),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> updateCategory(CategoryEntity entity) async {
    await _dao.updateCategory(
      CategoriesCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        type: Value(entity.type.name),
        icon: Value(entity.icon),
        color: Value(entity.color),
        parentId: Value(entity.parentId),
        sortOrder: Value(entity.sortOrder),
        updatedAt: Value(entity.updatedAt),
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    await _dao.deleteCategory(id);
  }

  CategoryEntity _toEntity(CategoryRow row) {
    return CategoryEntity(
      id: row.id,
      name: row.name,
      type: row.type == 'income' ? CategoryType.income : CategoryType.expense,
      icon: row.icon,
      color: row.color,
      parentId: row.parentId,
      isDefault: row.isDefault,
      isArchived: row.isArchived,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
