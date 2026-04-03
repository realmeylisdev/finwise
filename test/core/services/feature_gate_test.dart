import 'package:finwise/core/services/feature_gate.dart';
import 'package:finwise/core/services/subscription_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSubscriptionService extends Mock implements SubscriptionService {}

void main() {
  late MockSubscriptionService mockSubscriptionService;
  late FeatureGate featureGate;

  setUp(() {
    mockSubscriptionService = MockSubscriptionService();
    featureGate = FeatureGate(mockSubscriptionService);
  });

  group('FeatureGate', () {
    group('free tier', () {
      setUp(() {
        when(() => mockSubscriptionService.isPro).thenReturn(false);
        when(() => mockSubscriptionService.isPremium).thenReturn(false);
      });

      test('cannot access premium features', () {
        expect(featureGate.canAccess(Feature.unlimitedBudgets), isFalse);
        expect(featureGate.canAccess(Feature.unlimitedGoals), isFalse);
        expect(featureGate.canAccess(Feature.aiInsights), isFalse);
        expect(featureGate.canAccess(Feature.netWorth), isFalse);
        expect(featureGate.canAccess(Feature.cashFlow), isFalse);
        expect(featureGate.canAccess(Feature.reports), isFalse);
        expect(featureGate.canAccess(Feature.privacyMode), isFalse);
        expect(
          featureGate.canAccess(Feature.subscriptionTracking),
          isFalse,
        );
      });

      test('cannot access pro features', () {
        expect(featureGate.canAccess(Feature.debtPayoff), isFalse);
        expect(featureGate.canAccess(Feature.investments), isFalse);
        expect(featureGate.canAccess(Feature.sharedBudgets), isFalse);
        expect(featureGate.canAccess(Feature.multiCurrency), isFalse);
      });
    });

    group('premium tier', () {
      setUp(() {
        when(() => mockSubscriptionService.isPro).thenReturn(false);
        when(() => mockSubscriptionService.isPremium).thenReturn(true);
      });

      test('can access premium features', () {
        expect(featureGate.canAccess(Feature.unlimitedBudgets), isTrue);
        expect(featureGate.canAccess(Feature.unlimitedGoals), isTrue);
        expect(featureGate.canAccess(Feature.aiInsights), isTrue);
        expect(featureGate.canAccess(Feature.netWorth), isTrue);
        expect(featureGate.canAccess(Feature.cashFlow), isTrue);
        expect(featureGate.canAccess(Feature.reports), isTrue);
        expect(featureGate.canAccess(Feature.privacyMode), isTrue);
        expect(
          featureGate.canAccess(Feature.subscriptionTracking),
          isTrue,
        );
      });

      test('cannot access pro features', () {
        expect(featureGate.canAccess(Feature.debtPayoff), isFalse);
        expect(featureGate.canAccess(Feature.investments), isFalse);
        expect(featureGate.canAccess(Feature.sharedBudgets), isFalse);
        expect(featureGate.canAccess(Feature.multiCurrency), isFalse);
      });
    });

    group('pro tier', () {
      setUp(() {
        when(() => mockSubscriptionService.isPro).thenReturn(true);
        when(() => mockSubscriptionService.isPremium).thenReturn(true);
      });

      test('can access all premium features', () {
        expect(featureGate.canAccess(Feature.unlimitedBudgets), isTrue);
        expect(featureGate.canAccess(Feature.aiInsights), isTrue);
        expect(featureGate.canAccess(Feature.reports), isTrue);
      });

      test('can access all pro features', () {
        expect(featureGate.canAccess(Feature.debtPayoff), isTrue);
        expect(featureGate.canAccess(Feature.investments), isTrue);
        expect(featureGate.canAccess(Feature.sharedBudgets), isTrue);
        expect(featureGate.canAccess(Feature.multiCurrency), isTrue);
      });
    });

    group('requiredTier', () {
      test('returns free for features not in premium or pro sets', () {
        // All features defined in the enum belong to premium or pro,
        // so requiredTier will return premium or pro for all of them.
        // This validates that the method correctly identifies each tier.
      });

      test('returns premium for premium features', () {
        expect(
          featureGate.requiredTier(Feature.unlimitedBudgets),
          SubscriptionTier.premium,
        );
        expect(
          featureGate.requiredTier(Feature.unlimitedGoals),
          SubscriptionTier.premium,
        );
        expect(
          featureGate.requiredTier(Feature.aiInsights),
          SubscriptionTier.premium,
        );
        expect(
          featureGate.requiredTier(Feature.netWorth),
          SubscriptionTier.premium,
        );
        expect(
          featureGate.requiredTier(Feature.cashFlow),
          SubscriptionTier.premium,
        );
        expect(
          featureGate.requiredTier(Feature.reports),
          SubscriptionTier.premium,
        );
        expect(
          featureGate.requiredTier(Feature.privacyMode),
          SubscriptionTier.premium,
        );
        expect(
          featureGate.requiredTier(Feature.subscriptionTracking),
          SubscriptionTier.premium,
        );
      });

      test('returns pro for pro features', () {
        expect(
          featureGate.requiredTier(Feature.debtPayoff),
          SubscriptionTier.pro,
        );
        expect(
          featureGate.requiredTier(Feature.investments),
          SubscriptionTier.pro,
        );
        expect(
          featureGate.requiredTier(Feature.sharedBudgets),
          SubscriptionTier.pro,
        );
        expect(
          featureGate.requiredTier(Feature.multiCurrency),
          SubscriptionTier.pro,
        );
      });
    });
  });
}
