import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/bill_reminder/domain/repositories/bill_reminder_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteBillReminderUseCase extends UseCase<void, String> {
  DeleteBillReminderUseCase(this._repository);
  final BillReminderRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.deleteBill(params);
}
