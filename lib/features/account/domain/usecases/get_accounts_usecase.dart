import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAccountsUseCase extends UseCase<List<AccountEntity>, NoParams> {
  GetAccountsUseCase(this._repository);
  final AccountRepository _repository;

  @override
  Future<Either<Failure, List<AccountEntity>>> call(NoParams params) =>
      _repository.getAccounts();
}
