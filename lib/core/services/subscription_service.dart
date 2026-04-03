import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum SubscriptionTier { free, premium, pro }

@singleton
class SubscriptionService extends ChangeNotifier {
  SubscriptionTier _currentTier = SubscriptionTier.free;

  SubscriptionTier get currentTier => _currentTier;
  bool get isPremium =>
      _currentTier == SubscriptionTier.premium ||
      _currentTier == SubscriptionTier.pro;
  bool get isPro => _currentTier == SubscriptionTier.pro;

  /// For testing/development -- will be replaced with real store logic.
  void upgradeTo(SubscriptionTier tier) {
    _currentTier = tier;
    notifyListeners();
  }

  void restorePurchases() {
    // TODO: Implement with purchases_flutter
  }

  static const premiumMonthlyPrice = 7.99;
  static const premiumYearlyPrice = 59.99;
  static const proMonthlyPrice = 12.99;
  static const proYearlyPrice = 99.99;
}
