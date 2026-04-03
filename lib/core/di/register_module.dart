import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/accounts_dao.dart';
import 'package:finwise/core/database/daos/bill_reminders_dao.dart';
import 'package:finwise/core/database/daos/budgets_dao.dart';
import 'package:finwise/core/database/daos/categories_dao.dart';
import 'package:finwise/core/database/daos/category_rules_dao.dart';
import 'package:finwise/core/database/daos/currencies_dao.dart';
import 'package:finwise/core/database/daos/savings_goals_dao.dart';
import 'package:finwise/core/database/daos/transaction_splits_dao.dart';
import 'package:finwise/core/database/daos/assets_dao.dart';
import 'package:finwise/core/database/daos/liabilities_dao.dart';
import 'package:finwise/core/database/daos/net_worth_snapshots_dao.dart';
import 'package:finwise/core/database/daos/debt_payments_dao.dart';
import 'package:finwise/core/database/daos/debts_dao.dart';
import 'package:finwise/core/database/daos/subscriptions_dao.dart';
import 'package:finwise/core/database/daos/transactions_dao.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  AppDatabase get database => AppDatabase();

  @singleton
  CurrenciesDao currenciesDao(AppDatabase db) => db.currenciesDao;

  @singleton
  AccountsDao accountsDao(AppDatabase db) => db.accountsDao;

  @singleton
  CategoriesDao categoriesDao(AppDatabase db) => db.categoriesDao;

  @singleton
  TransactionsDao transactionsDao(AppDatabase db) => db.transactionsDao;

  @singleton
  BudgetsDao budgetsDao(AppDatabase db) => db.budgetsDao;

  @singleton
  SavingsGoalsDao savingsGoalsDao(AppDatabase db) => db.savingsGoalsDao;

  @singleton
  BillRemindersDao billRemindersDao(AppDatabase db) => db.billRemindersDao;

  @singleton
  CategoryRulesDao categoryRulesDao(AppDatabase db) => db.categoryRulesDao;

  @singleton
  TransactionSplitsDao transactionSplitsDao(AppDatabase db) =>
      db.transactionSplitsDao;

  @singleton
  AssetsDao assetsDao(AppDatabase db) => db.assetsDao;

  @singleton
  LiabilitiesDao liabilitiesDao(AppDatabase db) => db.liabilitiesDao;

  @singleton
  NetWorthSnapshotsDao netWorthSnapshotsDao(AppDatabase db) =>
      db.netWorthSnapshotsDao;

  @singleton
  SubscriptionsDao subscriptionsDao(AppDatabase db) => db.subscriptionsDao;

  @singleton
  DebtsDao debtsDao(AppDatabase db) => db.debtsDao;

  @singleton
  DebtPaymentsDao debtPaymentsDao(AppDatabase db) => db.debtPaymentsDao;
}
