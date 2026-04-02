import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTransactionsUseCase
    extends UseCase<List<TransactionEntity>, NoParams> {
  GetTransactionsUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(NoParams params) =>
      _repository.getTransactions();
}
