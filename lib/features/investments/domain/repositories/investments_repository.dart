import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';
import 'package:finwise/features/investments/domain/entities/investment_performance_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class InvestmentsRepository {
  Future<Either<Failure, List<InvestmentEntity>>> getInvestments();
  Future<Either<Failure, InvestmentEntity>> createInvestment(
    InvestmentEntity investment,
  );
  Future<Either<Failure, InvestmentEntity>> updateInvestment(
    InvestmentEntity investment,
  );
  Future<Either<Failure, void>> deleteInvestment(String id);
  Future<Either<Failure, InvestmentPerformanceEntity>> getPerformance();
  Future<Either<Failure, void>> recordPriceHistory(
    String investmentId,
    double price,
  );
}
