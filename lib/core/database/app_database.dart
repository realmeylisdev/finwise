import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:finwise/core/constants/db_constants.dart';
import 'package:finwise/core/database/daos/accounts_dao.dart';
import 'package:finwise/core/database/daos/bill_reminders_dao.dart';
import 'package:finwise/core/database/daos/budgets_dao.dart';
import 'package:finwise/core/database/daos/categories_dao.dart';
import 'package:finwise/core/database/daos/currencies_dao.dart';
import 'package:finwise/core/database/daos/savings_goals_dao.dart';
import 'package:finwise/core/database/daos/transactions_dao.dart';
import 'package:finwise/core/database/seed/default_categories.dart';
import 'package:finwise/core/database/seed/default_currencies.dart';
import 'package:finwise/core/database/tables/accounts_table.dart';
import 'package:finwise/core/database/tables/bill_reminders_table.dart';
import 'package:finwise/core/database/tables/budgets_table.dart';
import 'package:finwise/core/database/tables/categories_table.dart';
import 'package:finwise/core/database/tables/currencies_table.dart';
import 'package:finwise/core/database/tables/savings_goals_table.dart';
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
  ],
  daos: [
    CurrenciesDao,
    AccountsDao,
    CategoriesDao,
    TransactionsDao,
    BudgetsDao,
    SavingsGoalsDao,
    BillRemindersDao,
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
