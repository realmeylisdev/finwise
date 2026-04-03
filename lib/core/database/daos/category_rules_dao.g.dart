// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_rules_dao.dart';

// ignore_for_file: type=lint
mixin _$CategoryRulesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryRulesTable get categoryRules => attachedDatabase.categoryRules;
  $CategoriesTable get categories => attachedDatabase.categories;
  CategoryRulesDaoManager get managers => CategoryRulesDaoManager(this);
}

class CategoryRulesDaoManager {
  final _$CategoryRulesDaoMixin _db;
  CategoryRulesDaoManager(this._db);
  $$CategoryRulesTableTableManager get categoryRules =>
      $$CategoryRulesTableTableManager(_db.attachedDatabase, _db.categoryRules);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
}
