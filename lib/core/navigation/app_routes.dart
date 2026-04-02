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

  // Settings form sub-routes
  static const String settingsCategoryForm = '/settings/categories/new';
  static const String settingsAccountForm = '/settings/accounts/new';
  static const String settingsBillForm = '/settings/bills/new';
}
