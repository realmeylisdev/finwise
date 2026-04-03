import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/investments/data/datasources/investments_local_datasource.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';
import 'package:finwise/features/investments/domain/entities/investment_performance_entity.dart';
import 'package:finwise/features/investments/domain/repositories/investments_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: InvestmentsRepository)
class InvestmentsRepositoryImpl implements InvestmentsRepository {
  InvestmentsRepositoryImpl(this._datasource);

  final InvestmentsLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<InvestmentEntity>>> getInvestments() async {
    try {
      final investments = await _datasource.getInvestments();
      return Right(investments);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvestmentEntity>> createInvestment(
    InvestmentEntity investment,
  ) async {
    try {
      await _datasource.insertInvestment(investment);
      return Right(investment);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvestmentEntity>> updateInvestment(
    InvestmentEntity investment,
  ) async {
    try {
      await _datasource.updateInvestment(investment);
      return Right(investment);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteInvestment(String id) async {
    try {
      await _datasource.deleteInvestment(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvestmentPerformanceEntity>> getPerformance() async {
    try {
      final performance = await _datasource.getPerformance();
      return Right(performance);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> recordPriceHistory(
    String investmentId,
    double price,
  ) async {
    try {
      await _datasource.recordPriceHistory(investmentId, price);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
