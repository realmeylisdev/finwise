import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/category_rule/domain/entities/category_rule_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class CategoryRuleRepository {
  Future<Either<Failure, List<CategoryRuleEntity>>> getRules();
  Future<Either<Failure, CategoryRuleEntity>> createRule(
    CategoryRuleEntity rule,
  );
  Future<Either<Failure, void>> deleteRule(String id);
  Future<Either<Failure, String?>> findMatchingCategory(String text);
}
