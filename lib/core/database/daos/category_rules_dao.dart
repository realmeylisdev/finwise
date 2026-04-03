import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/category_rules_table.dart';
import '../tables/categories_table.dart';

part 'category_rules_dao.g.dart';

class CategoryRuleWithCategory {
  const CategoryRuleWithCategory({
    required this.rule,
    required this.category,
  });

  final CategoryRuleRow rule;
  final CategoryRow category;
}

@DriftAccessor(tables: [CategoryRules, Categories])
class CategoryRulesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryRulesDaoMixin {
  CategoryRulesDao(super.db);

  Future<List<CategoryRuleWithCategory>> getAllRules() async {
    final query = select(categoryRules).join([
      innerJoin(
        categories,
        categories.id.equalsExp(categoryRules.categoryId),
      ),
    ])
      ..orderBy([OrderingTerm.asc(categoryRules.keyword)]);

    final rows = await query.get();
    return rows.map((row) {
      return CategoryRuleWithCategory(
        rule: row.readTable(categoryRules),
        category: row.readTable(categories),
      );
    }).toList();
  }

  Future<String?> findMatchingCategoryId(String text) async {
    if (text.isEmpty) return null;
    final lower = text.toLowerCase();
    final rules = await (select(categoryRules)
          ..where((t) => t.isActive.equals(true)))
        .get();
    for (final rule in rules) {
      if (lower.contains(rule.keyword.toLowerCase())) {
        return rule.categoryId;
      }
    }
    return null;
  }

  Future<int> insertRule(CategoryRulesCompanion entry) =>
      into(categoryRules).insert(entry);

  Future<int> deleteRule(String id) =>
      (delete(categoryRules)..where((t) => t.id.equals(id))).go();
}
