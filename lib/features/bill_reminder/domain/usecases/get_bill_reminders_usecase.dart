import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/usecases/usecase.dart';
import 'package:finwise/features/bill_reminder/domain/entities/bill_reminder_entity.dart';
import 'package:finwise/features/bill_reminder/domain/repositories/bill_reminder_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBillRemindersUseCase
    extends UseCase<List<BillReminderEntity>, NoParams> {
  GetBillRemindersUseCase(this._repository);
  final BillReminderRepository _repository;

  @override
  Future<Either<Failure, List<BillReminderEntity>>> call(NoParams params) =>
      _repository.getActiveBills();
}
