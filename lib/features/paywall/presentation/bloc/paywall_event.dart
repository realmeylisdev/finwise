part of 'paywall_bloc.dart';

abstract class PaywallEvent extends Equatable {
  const PaywallEvent();
  @override
  List<Object?> get props => [];
}

class PaywallLoaded extends PaywallEvent {
  const PaywallLoaded();
}

class PaywallTierSelected extends PaywallEvent {
  const PaywallTierSelected(this.tier);
  final SubscriptionTier tier;

  @override
  List<Object?> get props => [tier];
}

class PaywallPurchaseRequested extends PaywallEvent {
  const PaywallPurchaseRequested();
}

class PaywallRestoreRequested extends PaywallEvent {
  const PaywallRestoreRequested();
}

class PaywallBillingCycleToggled extends PaywallEvent {
  const PaywallBillingCycleToggled();
}
