import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/category_rule/data/datasources/category_rule_local_datasource.dart';
import 'package:finwise/features/category_rule/domain/entities/category_rule_entity.dart';
import 'package:finwise/features/category_rule/domain/repositories/category_rule_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRuleRepository)
class CategoryRuleRepositoryImpl implements CategoryRuleRepository {
  CategoryRuleRepositoryImpl(this._datasource);

  final CategoryRuleLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<CategoryRuleEntity>>> getRules() async {
    try {
      final rules = await _datasource.getAllRules();
      return Right(rules);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryRuleEntity>> createRule(
    CategoryRuleEntity rule,
  ) async {
    try {
      await _datasource.insertRule(rule);
      return Right(rule);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRule(String id) async {
    try {
      await _datasource.deleteRule(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> findMatchingCategory(String text) async {
    try {
      final categoryId = await _datasource.findMatchingCategoryId(text);
      return Right(categoryId);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
