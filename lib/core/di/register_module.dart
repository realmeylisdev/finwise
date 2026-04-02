import 'package:finwise/core/database/app_database.dart';
import 'package:finwise/core/database/daos/accounts_dao.dart';
import 'package:finwise/core/database/daos/bill_reminders_dao.dart';
import 'package:finwise/core/database/daos/budgets_dao.dart';
import 'package:finwise/core/database/daos/categories_dao.dart';
import 'package:finwise/core/database/daos/currencies_dao.dart';
import 'package:finwise/core/database/daos/savings_goals_dao.dart';
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
}
