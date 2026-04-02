import 'package:finwise/core/errors/exceptions.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/account/data/datasources/account_local_datasource.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._datasource);

  final AccountLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<AccountEntity>>> getAccounts() async {
    try {
      final accounts = await _datasource.getAccounts();
      return Right(accounts);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> getAccountById(String id) async {
    try {
      final account = await _datasource.getAccountById(id);
      if (account == null) {
        return const Left(NotFoundFailure(message: 'Account not found'));
      }
      return Right(account);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> createAccount(
    AccountEntity account,
  ) async {
    try {
      await _datasource.insertAccount(account);
      return Right(account);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> updateAccount(
    AccountEntity account,
  ) async {
    try {
      await _datasource.updateAccount(account);
      return Right(account);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String id) async {
    try {
      await _datasource.deleteAccount(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalBalance() async {
    try {
      final total = await _datasource.getTotalBalance();
      return Right(total);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<AccountEntity>> watchAccounts() {
    return _datasource.watchAccounts();
  }
}
