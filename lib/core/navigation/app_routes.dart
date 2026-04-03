abstract class AppRoutes {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String budgets = '/budgets';
  static const String goals = '/goals';
  static const String analytics = '/analytics';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String lock = '/lock';

  // Settings sub-routes
  static const String settingsCategories = '/settings/categories';
  static const String settingsAccounts = '/settings/accounts';
  static const String settingsBills = '/settings/bills';
  static const String settingsBackup = '/settings/backup';
  static const String settingsSecurity = '/settings/security';

  static const String settingsCategoryRules = '/settings/category-rules';

  // Smart features
  static const String recurringPatterns = '/recurring-patterns';

  // Cash Flow
  static const String cashFlow = '/cash-flow';

  // Net Worth
  static const String netWorth = '/net-worth';
  static const String netWorthAssetForm = '/net-worth/asset/new';
  static const String netWorthLiabilityForm = '/net-worth/liability/new';

  // Debt Payoff
  static const String debts = '/debts';
  static const String debtForm = '/debts/new';
  static const String payoffPlan = '/debts/payoff-plan';

  // Achievements
  static const String achievements = '/achievements';

  // Notifications
  static const String notifications = '/notifications';

  // Subscriptions
  static const String subscriptions = '/subscriptions';
  static const String subscriptionForm = '/subscriptions/new';

  // Wellness Score
  static const String wellnessScore = '/wellness-score';

  // Settings form sub-routes
  static const String settingsCategoryForm = '/settings/categories/new';
  static const String settingsAccountForm = '/settings/accounts/new';
  static const String settingsBillForm = '/settings/bills/new';
}
