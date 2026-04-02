import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/bill_reminder/data/datasources/bill_reminder_local_datasource.dart';
import 'package:finwise/features/bill_reminder/domain/entities/bill_reminder_entity.dart';
import 'package:finwise/features/bill_reminder/domain/repositories/bill_reminder_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BillReminderRepository)
class BillReminderRepositoryImpl implements BillReminderRepository {
  BillReminderRepositoryImpl(this._datasource);

  final BillReminderLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<BillReminderEntity>>> getBills() async {
    try {
      final bills = await _datasource.getAllBills();
      return Right(bills);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BillReminderEntity>>> getActiveBills() async {
    try {
      final bills = await _datasource.getActiveBills();
      return Right(bills);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BillReminderEntity>>> getUpcomingBills(
    int today,
    int days,
  ) async {
    try {
      final bills = await _datasource.getUpcomingBills(today, days);
      return Right(bills);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BillReminderEntity>> createBill(
    BillReminderEntity bill,
  ) async {
    try {
      await _datasource.insertBill(bill);
      return Right(bill);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BillReminderEntity>> updateBill(
    BillReminderEntity bill,
  ) async {
    try {
      await _datasource.updateBill(bill);
      return Right(bill);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBill(String id) async {
    try {
      await _datasource.deleteBill(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
