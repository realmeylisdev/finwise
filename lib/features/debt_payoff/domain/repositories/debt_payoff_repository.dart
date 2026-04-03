import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_entity.dart';
import 'package:finwise/features/debt_payoff/domain/entities/debt_payment_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class DebtPayoffRepository {
  Future<Either<Failure, List<DebtEntity>>> getDebts();
  Future<Either<Failure, DebtEntity>> createDebt(DebtEntity debt);
  Future<Either<Failure, DebtEntity>> updateDebt(DebtEntity debt);
  Future<Either<Failure, void>> deleteDebt(String id);
  Future<Either<Failure, List<DebtPaymentEntity>>> getPayments(String debtId);
  Future<Either<Failure, DebtPaymentEntity>> recordPayment(
    DebtPaymentEntity payment,
  );
  Future<Either<Failure, void>> deletePayment(String id);
}
