import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/domain/repositories/category_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesByTypeUseCase
    extends UseCase<List<CategoryEntity>, CategoryType> {
  GetCategoriesByTypeUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(CategoryType params) {
    return _repository.getCategoriesByType(params);
  }
}
