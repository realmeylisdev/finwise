import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/presentation/pages/account_form_page.dart';
import 'package:finwise/features/account/presentation/pages/accounts_page.dart';
import 'package:finwise/features/analytics/presentation/pages/analytics_page.dart';
import 'package:finwise/features/backup/presentation/pages/backup_page.dart';
import 'package:finwise/features/bill_reminder/presentation/pages/bill_reminders_page.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/presentation/pages/categories_page.dart';
import 'package:finwise/features/category/presentation/pages/category_form_page.dart';
import 'package:finwise/features/budget/presentation/pages/budget_detail_page.dart';
import 'package:finwise/features/budget/presentation/pages/budget_form_page.dart';
import 'package:finwise/features/budget/presentation/pages/budgets_page.dart';
import 'package:finwise/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:finwise/features/main/main_shell.dart';
import 'package:finwise/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:finwise/features/savings_goal/presentation/pages/savings_goal_detail_page.dart';
import 'package:finwise/features/savings_goal/presentation/pages/savings_goal_form_page.dart';
import 'package:finwise/features/savings_goal/presentation/pages/savings_goals_page.dart';
import 'package:finwise/features/search/presentation/pages/search_page.dart';
import 'package:finwise/features/security/presentation/pages/lock_screen_page.dart';
import 'package:finwise/features/security/presentation/pages/pin_setup_page.dart';
import 'package:finwise/features/settings/presentation/pages/settings_page.dart';
import 'package:finwise/features/transaction/presentation/pages/transaction_detail_page.dart';
import 'package:finwise/features/transaction/presentation/pages/transaction_form_page.dart';
import 'package:finwise/features/transaction/presentation/pages/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _dashboardNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'dashboard');
  static final _transactionsNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'transactions');
  static final _budgetsNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'budgets');
  static final _goalsNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'goals');
  static final _settingsNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'settings');

  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    routes: [
      // Top-level routes (outside shell)
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        name: 'analytics',
        builder: (context, state) => const AnalyticsPage(),
      ),
      GoRoute(
        path: AppRoutes.lock,
        name: 'lock',
        builder: (context, state) => const LockScreenPage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchPage(),
      ),

      // Main shell with 5-tab bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // Tab 0: Dashboard
          StatefulShellBranch(
            navigatorKey: _dashboardNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // Tab 1: Transactions
          StatefulShellBranch(
            navigatorKey: _transactionsNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                name: 'transactions',
                builder: (context, state) => const TransactionsPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: 'transaction-form',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const TransactionFormPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'transaction-detail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => TransactionDetailPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 2: Budgets
          StatefulShellBranch(
            navigatorKey: _budgetsNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.budgets,
                name: 'budgets',
                builder: (context, state) => const BudgetsPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: 'budget-form',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const BudgetFormPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'budget-detail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => BudgetDetailPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 3: Goals
          StatefulShellBranch(
            navigatorKey: _goalsNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.goals,
                name: 'goals',
                builder: (context, state) => const SavingsGoalsPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: 'goal-form',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SavingsGoalFormPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'goal-detail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => SavingsGoalDetailPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 4: Settings
          StatefulShellBranch(
            navigatorKey: _settingsNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'categories',
                    name: 'settings-categories',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const CategoriesPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: 'settings-category-form',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => CategoryFormPage(
                          category: state.extra as CategoryEntity?,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'accounts',
                    name: 'settings-accounts',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const AccountsPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: 'settings-account-form',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => AccountFormPage(
                          account: state.extra as AccountEntity?,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'bills',
                    name: 'settings-bills',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const BillRemindersPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: 'settings-bill-form',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            const BillReminderFormPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'backup',
                    name: 'settings-backup',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const BackupPage(),
                  ),
                  GoRoute(
                    path: 'security',
                    name: 'settings-security',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const PinSetupPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
