import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/debt_payoff/data/datasources/debt_payoff_local_datasource.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_payment_entity.dart';
import 'package:finwise/features/debt_payoff/domain/repositories/debt_payoff_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DebtPayoffRepository)
class DebtPayoffRepositoryImpl implements DebtPayoffRepository {
  DebtPayoffRepositoryImpl(this._datasource);

  final DebtPayoffLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<DebtEntity>>> getDebts() async {
    try {
      final debts = await _datasource.getAllDebts();
      return Right(debts);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DebtEntity>> createDebt(DebtEntity debt) async {
    try {
      await _datasource.insertDebt(debt);
      return Right(debt);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DebtEntity>> updateDebt(DebtEntity debt) async {
    try {
      await _datasource.updateDebt(debt);
      return Right(debt);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDebt(String id) async {
    try {
      await _datasource.deleteDebt(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DebtPaymentEntity>>> getPayments(
    String debtId,
  ) async {
    try {
      final payments = await _datasource.getPaymentsForDebt(debtId);
      return Right(payments);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DebtPaymentEntity>> recordPayment(
    DebtPaymentEntity payment,
  ) async {
    try {
      await _datasource.insertPayment(payment);
      return Right(payment);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment(String id) async {
    try {
      await _datasource.deletePayment(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
