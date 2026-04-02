import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<AccountEntity>>> getAccounts();
  Future<Either<Failure, AccountEntity>> getAccountById(String id);
  Future<Either<Failure, AccountEntity>> createAccount(AccountEntity account);
  Future<Either<Failure, AccountEntity>> updateAccount(AccountEntity account);
  Future<Either<Failure, void>> deleteAccount(String id);
  Future<Either<Failure, double>> getTotalBalance();
  Stream<List<AccountEntity>> watchAccounts();
}
