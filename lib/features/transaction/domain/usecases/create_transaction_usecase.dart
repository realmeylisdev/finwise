import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTransactionUseCase
    extends UseCase<TransactionEntity, TransactionEntity> {
  CreateTransactionUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, TransactionEntity>> call(
    TransactionEntity params,
  ) =>
      _repository.createTransaction(params);
}
