import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteTransactionUseCase extends UseCase<void, String> {
  DeleteTransactionUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.deleteTransaction(params);
}
