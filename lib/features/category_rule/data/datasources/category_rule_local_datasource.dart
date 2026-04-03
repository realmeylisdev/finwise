import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/category_rules_dao.dart';
import 'package:finwise/features/category_rule/domain/entities/category_rule_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryRuleLocalDatasource {
  CategoryRuleLocalDatasource(this._dao);

  final CategoryRulesDao _dao;

  Future<List<CategoryRuleEntity>> getAllRules() async {
    final rows = await _dao.getAllRules();
    return rows.map(_toEntity).toList();
  }

  Future<void> insertRule(CategoryRuleEntity entity) async {
    await _dao.insertRule(
      CategoryRulesCompanion.insert(
        id: entity.id,
        keyword: entity.keyword,
        categoryId: entity.categoryId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
  }

  Future<void> deleteRule(String id) async {
    await _dao.deleteRule(id);
  }

  Future<String?> findMatchingCategoryId(String text) async {
    return _dao.findMatchingCategoryId(text);
  }

  CategoryRuleEntity _toEntity(CategoryRuleWithCategory row) {
    return CategoryRuleEntity(
      id: row.rule.id,
      keyword: row.rule.keyword,
      categoryId: row.rule.categoryId,
      categoryName: row.category.name,
      categoryIcon: row.category.icon,
      categoryColor: row.category.color,
      isActive: row.rule.isActive,
      createdAt: row.rule.createdAt,
      updatedAt: row.rule.updatedAt,
    );
  }
}
