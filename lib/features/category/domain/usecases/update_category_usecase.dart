import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/domain/repositories/category_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCategoryUseCase extends UseCase<CategoryEntity, CategoryEntity> {
  UpdateCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, CategoryEntity>> call(CategoryEntity params) {
    return _repository.updateCategory(params);
  }
}
