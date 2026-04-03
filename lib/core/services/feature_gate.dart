import 'package:finwise/core/services/subscription_service.dart';
import 'package:injectable/injectable.dart';

enum Feature {
  unlimitedBudgets,
  unlimitedGoals,
  aiInsights,
  netWorth,
  cashFlow,
  reports,
  privacyMode,
  debtPayoff,
  investments,
  sharedBudgets,
  multiCurrency,
  subscriptionTracking,
}

@singleton
class FeatureGate {
  FeatureGate(this._subscriptionService);
  final SubscriptionService _subscriptionService;

  static const _premiumFeatures = {
    Feature.unlimitedBudgets,
    Feature.unlimitedGoals,
    Feature.aiInsights,
    Feature.netWorth,
    Feature.cashFlow,
    Feature.reports,
    Feature.privacyMode,
    Feature.subscriptionTracking,
  };

  static const _proFeatures = {
    Feature.debtPayoff,
    Feature.investments,
    Feature.sharedBudgets,
    Feature.multiCurrency,
  };

  bool canAccess(Feature feature) {
    if (_subscriptionService.isPro) return true;
    if (_subscriptionService.isPremium) {
      return _premiumFeatures.contains(feature);
    }
    // Free tier -- feature is not in premium or pro sets = it's free
    return !_premiumFeatures.contains(feature) &&
        !_proFeatures.contains(feature);
  }

  SubscriptionTier requiredTier(Feature feature) {
    if (_proFeatures.contains(feature)) return SubscriptionTier.pro;
    if (_premiumFeatures.contains(feature)) return SubscriptionTier.premium;
    return SubscriptionTier.free;
  }
}
