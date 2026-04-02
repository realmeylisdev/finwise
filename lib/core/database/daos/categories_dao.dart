import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Future<List<CategoryRow>> getAllCategories() =>
      (select(categories)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<CategoryRow>> watchAllCategories() =>
      (select(categories)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<CategoryRow>> getCategoriesByType(String type) =>
      (select(categories)
            ..where(
              (t) => t.type.equals(type) & t.isArchived.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<CategoryRow>> watchCategoriesByType(String type) =>
      (select(categories)
            ..where(
              (t) => t.type.equals(type) & t.isArchived.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<CategoryRow?> getCategoryById(String id) =>
      (select(categories)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<bool> updateCategory(CategoriesCompanion entry) =>
      (update(categories)..where((t) => t.id.equals(entry.id.value)))
          .write(entry)
          .then((rows) => rows > 0);

  Future<int> deleteCategory(String id) =>
      (delete(categories)..where((t) => t.id.equals(id))).go();
}
