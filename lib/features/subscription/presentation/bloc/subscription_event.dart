part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
  @override
  List<Object?> get props => [];
}

class SubscriptionsLoaded extends SubscriptionEvent {
  const SubscriptionsLoaded();
}

class SubscriptionCreated extends SubscriptionEvent {
  const SubscriptionCreated(this.subscription);
  final SubscriptionEntity subscription;
  @override
  List<Object?> get props => [subscription];
}

class SubscriptionUpdated extends SubscriptionEvent {
  const SubscriptionUpdated(this.subscription);
  final SubscriptionEntity subscription;
  @override
  List<Object?> get props => [subscription];
}

class SubscriptionDeleted extends SubscriptionEvent {
  const SubscriptionDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class SubscriptionToggled extends SubscriptionEvent {
  const SubscriptionToggled(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
