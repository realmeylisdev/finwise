import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/subscription/data/datasources/subscription_local_datasource.dart';
import 'package:finwise/features/subscription/domain/entities/subscription_entity.dart';
import 'package:finwise/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._datasource);

  final SubscriptionLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions() async {
    try {
      final subscriptions = await _datasource.getAllSubscriptions();
      return Right(subscriptions);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionEntity>>>
      getActiveSubscriptions() async {
    try {
      final subscriptions = await _datasource.getActiveSubscriptions();
      return Right(subscriptions);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> createSubscription(
    SubscriptionEntity subscription,
  ) async {
    try {
      await _datasource.insertSubscription(subscription);
      return Right(subscription);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> updateSubscription(
    SubscriptionEntity subscription,
  ) async {
    try {
      await _datasource.updateSubscription(subscription);
      return Right(subscription);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubscription(String id) async {
    try {
      await _datasource.deleteSubscription(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalMonthlyCost() async {
    try {
      final total = await _datasource.getTotalMonthlyAmount();
      return Right(total);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
