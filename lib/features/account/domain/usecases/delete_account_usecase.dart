import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAccountUseCase extends UseCase<void, String> {
  DeleteAccountUseCase(this._repository);
  final AccountRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.deleteAccount(params);
}
