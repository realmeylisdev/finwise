import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/category/domain/repositories/category_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteCategoryUseCase extends UseCase<void, String> {
  DeleteCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.deleteCategory(params);
  }
}
