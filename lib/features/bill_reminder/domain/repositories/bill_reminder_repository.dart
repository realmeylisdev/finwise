import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/bill_reminder/domain/entities/bill_reminder_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class BillReminderRepository {
  Future<Either<Failure, List<BillReminderEntity>>> getBills();
  Future<Either<Failure, List<BillReminderEntity>>> getActiveBills();
  Future<Either<Failure, List<BillReminderEntity>>> getUpcomingBills(
    int today,
    int days,
  );
  Future<Either<Failure, BillReminderEntity>> createBill(
    BillReminderEntity bill,
  );
  Future<Either<Failure, BillReminderEntity>> updateBill(
    BillReminderEntity bill,
  );
  Future<Either<Failure, void>> deleteBill(String id);
}
