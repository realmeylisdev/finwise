import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAccountUseCase extends UseCase<AccountEntity, AccountEntity> {
  UpdateAccountUseCase(this._repository);
  final AccountRepository _repository;

  @override
  Future<Either<Failure, AccountEntity>> call(AccountEntity params) =>
      _repository.updateAccount(params);
}
