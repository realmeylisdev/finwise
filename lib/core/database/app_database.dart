import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:finwise/core/constants/db_constants.dart';
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
import 'package:finwise/core/database/seed/default_categories.dart';
import 'package:finwise/core/database/seed/default_currencies.dart';
import 'package:finwise/core/database/tables/accounts_table.dart';
import 'package:finwise/core/database/tables/bill_reminders_table.dart';
import 'package:finwise/core/database/tables/budgets_table.dart';
import 'package:finwise/core/database/tables/categories_table.dart';
import 'package:finwise/core/database/tables/category_rules_table.dart';
import 'package:finwise/core/database/tables/currencies_table.dart';
import 'package:finwise/core/database/tables/savings_goals_table.dart';
import 'package:finwise/core/database/tables/transaction_splits_table.dart';
import 'package:finwise/core/database/tables/assets_table.dart';
import 'package:finwise/core/database/tables/liabilities_table.dart';
import 'package:finwise/core/database/tables/net_worth_snapshots_table.dart';
import 'package:finwise/core/database/tables/debt_payments_table.dart';
import 'package:finwise/core/database/tables/debts_table.dart';
import 'package:finwise/core/database/tables/subscriptions_table.dart';
import 'package:finwise/core/database/tables/transactions_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Currencies,
    Accounts,
    Categories,
    Transactions,
    Budgets,
    SavingsGoals,
    BillReminders,
    CategoryRules,
    TransactionSplits,
    Assets,
    Liabilities,
    NetWorthSnapshots,
    Subscriptions,
    Debts,
    DebtPayments,
  ],
  daos: [
    CurrenciesDao,
    AccountsDao,
    CategoriesDao,
    TransactionsDao,
    BudgetsDao,
    SavingsGoalsDao,
    BillRemindersDao,
    CategoryRulesDao,
    TransactionSplitsDao,
    AssetsDao,
    LiabilitiesDao,
    NetWorthSnapshotsDao,
    SubscriptionsDao,
    DebtsDao,
    DebtPaymentsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  AppDatabase.test(super.e);

  @override
  int get schemaVersion => DbConstants.schemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultData();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(budgets, budgets.rolloverAmount);
            await m.createTable(categoryRules);
          }
          if (from < 3) {
            await m.createTable(transactionSplits);
          }
          if (from < 4) {
            await m.createTable(assets);
            await m.createTable(liabilities);
            await m.createTable(netWorthSnapshots);
          }
          if (from < 5) {
            await m.createTable(subscriptions);
          }
          if (from < 6) {
            await m.createTable(debts);
            await m.createTable(debtPayments);
          }
        },
      );

  Future<void> _seedDefaultData() async {
    await _seedCurrencies();
    await _seedCategories();
  }

  Future<void> _seedCurrencies() async {
    for (final currency in defaultCurrencies) {
      await into(currencies).insert(
        CurrenciesCompanion.insert(
          code: currency.code,
          name: currency.name,
          symbol: currency.symbol,
          decimalPlaces: Value(currency.decimalPlaces),
          isDefault: Value(currency.code == 'USD'),
        ),
      );
    }
  }

  Future<void> _seedCategories() async {
    const uuid = Uuid();
    final now = DateTime.now();

    final allCategories = [
      ...defaultExpenseCategories,
      ...defaultIncomeCategories,
    ];

    for (final category in allCategories) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: uuid.v4(),
          name: category.name,
          type: category.type,
          icon: category.icon,
          color: category.color,
          isDefault: const Value(true),
          sortOrder: Value(category.sortOrder),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, DbConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
