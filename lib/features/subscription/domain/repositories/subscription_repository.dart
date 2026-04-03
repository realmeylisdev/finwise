import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/subscription/domain/entities/subscription_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions();
  Future<Either<Failure, List<SubscriptionEntity>>> getActiveSubscriptions();
  Future<Either<Failure, SubscriptionEntity>> createSubscription(
    SubscriptionEntity subscription,
  );
  Future<Either<Failure, SubscriptionEntity>> updateSubscription(
    SubscriptionEntity subscription,
  );
  Future<Either<Failure, void>> deleteSubscription(String id);
  Future<Either<Failure, double>> getTotalMonthlyCost();
}
