// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/account/data/datasources/account_local_datasource.dart'
    as _i29;
import '../../features/account/data/repositories/account_repository_impl.dart'
    as _i857;
import '../../features/account/domain/repositories/account_repository.dart'
    as _i1067;
import '../../features/account/domain/usecases/create_account_usecase.dart'
    as _i947;
import '../../features/account/domain/usecases/delete_account_usecase.dart'
    as _i949;
import '../../features/account/domain/usecases/get_accounts_usecase.dart'
    as _i67;
import '../../features/account/domain/usecases/update_account_usecase.dart'
    as _i688;
import '../../features/account/presentation/bloc/account_bloc.dart' as _i708;
import '../../features/analytics/presentation/bloc/analytics_bloc.dart' as _i70;
import '../../features/backup/presentation/bloc/backup_bloc.dart' as _i894;
import '../../features/bill_reminder/data/datasources/bill_reminder_local_datasource.dart'
    as _i212;
import '../../features/bill_reminder/data/repositories/bill_reminder_repository_impl.dart'
    as _i728;
import '../../features/bill_reminder/domain/repositories/bill_reminder_repository.dart'
    as _i998;
import '../../features/bill_reminder/domain/usecases/create_bill_reminder_usecase.dart'
    as _i611;
import '../../features/bill_reminder/domain/usecases/delete_bill_reminder_usecase.dart'
    as _i954;
import '../../features/bill_reminder/domain/usecases/get_bill_reminders_usecase.dart'
    as _i134;
import '../../features/bill_reminder/presentation/bloc/bill_reminder_bloc.dart'
    as _i391;
import '../../features/budget/data/datasources/budget_local_datasource.dart'
    as _i441;
import '../../features/budget/data/repositories/budget_repository_impl.dart'
    as _i74;
import '../../features/budget/domain/repositories/budget_repository.dart'
    as _i438;
import '../../features/budget/domain/usecases/create_budget_usecase.dart'
    as _i430;
import '../../features/budget/domain/usecases/delete_budget_usecase.dart'
    as _i860;
import '../../features/budget/domain/usecases/get_budgets_for_month_usecase.dart'
    as _i167;
import '../../features/budget/domain/usecases/update_budget_usecase.dart'
    as _i651;
import '../../features/budget/presentation/bloc/budget_bloc.dart' as _i438;
import '../../features/category/data/datasources/category_local_datasource.dart'
    as _i759;
import '../../features/category/data/repositories/category_repository_impl.dart'
    as _i528;
import '../../features/category/domain/repositories/category_repository.dart'
    as _i869;
import '../../features/category/domain/usecases/create_category_usecase.dart'
    as _i894;
import '../../features/category/domain/usecases/delete_category_usecase.dart'
    as _i1064;
import '../../features/category/domain/usecases/get_categories_by_type_usecase.dart'
    as _i438;
import '../../features/category/domain/usecases/get_categories_usecase.dart'
    as _i125;
import '../../features/category/domain/usecases/update_category_usecase.dart'
    as _i312;
import '../../features/category/presentation/bloc/category_bloc.dart' as _i292;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i792;
import '../../features/savings_goal/data/datasources/savings_goal_local_datasource.dart'
    as _i680;
import '../../features/savings_goal/data/repositories/savings_goal_repository_impl.dart'
    as _i32;
import '../../features/savings_goal/domain/repositories/savings_goal_repository.dart'
    as _i555;
import '../../features/savings_goal/domain/usecases/contribute_savings_goal_usecase.dart'
    as _i717;
import '../../features/savings_goal/domain/usecases/create_savings_goal_usecase.dart'
    as _i398;
import '../../features/savings_goal/domain/usecases/delete_savings_goal_usecase.dart'
    as _i309;
import '../../features/savings_goal/domain/usecases/get_savings_goals_usecase.dart'
    as _i738;
import '../../features/savings_goal/presentation/bloc/savings_goal_bloc.dart'
    as _i1030;
import '../../features/search/presentation/bloc/search_bloc.dart' as _i552;
import '../../features/security/presentation/bloc/security_bloc.dart' as _i676;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;
import '../../features/transaction/data/datasources/transaction_local_datasource.dart'
    as _i330;
import '../../features/transaction/data/repositories/transaction_repository_impl.dart'
    as _i600;
import '../../features/transaction/domain/repositories/transaction_repository.dart'
    as _i1022;
import '../../features/transaction/domain/usecases/create_transaction_usecase.dart'
    as _i346;
import '../../features/transaction/domain/usecases/delete_transaction_usecase.dart'
    as _i572;
import '../../features/transaction/domain/usecases/get_transactions_usecase.dart'
    as _i794;
import '../../features/transaction/presentation/bloc/transaction_bloc.dart'
    as _i356;
import '../database/app_database.dart' as _i982;
import '../database/daos/accounts_dao.dart' as _i144;
import '../database/daos/bill_reminders_dao.dart' as _i855;
import '../database/daos/budgets_dao.dart' as _i152;
import '../database/daos/categories_dao.dart' as _i676;
import '../database/daos/currencies_dao.dart' as _i545;
import '../database/daos/savings_goals_dao.dart' as _i800;
import '../database/daos/transactions_dao.dart' as _i76;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i676.SecurityBloc>(() => _i676.SecurityBloc());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i982.AppDatabase>(() => registerModule.database);
    gh.singleton<_i585.SettingsBloc>(() => _i585.SettingsBloc());
    gh.singleton<_i545.CurrenciesDao>(
      () => registerModule.currenciesDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i144.AccountsDao>(
      () => registerModule.accountsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i676.CategoriesDao>(
      () => registerModule.categoriesDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i76.TransactionsDao>(
      () => registerModule.transactionsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i152.BudgetsDao>(
      () => registerModule.budgetsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i800.SavingsGoalsDao>(
      () => registerModule.savingsGoalsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i855.BillRemindersDao>(
      () => registerModule.billRemindersDao(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i212.BillReminderLocalDatasource>(
      () => _i212.BillReminderLocalDatasource(gh<_i855.BillRemindersDao>()),
    );
    gh.factory<_i680.SavingsGoalLocalDatasource>(
      () => _i680.SavingsGoalLocalDatasource(gh<_i800.SavingsGoalsDao>()),
    );
    gh.factory<_i998.BillReminderRepository>(
      () => _i728.BillReminderRepositoryImpl(
        gh<_i212.BillReminderLocalDatasource>(),
      ),
    );
    gh.factory<_i555.SavingsGoalRepository>(
      () => _i32.SavingsGoalRepositoryImpl(
        gh<_i680.SavingsGoalLocalDatasource>(),
      ),
    );
    gh.factory<_i717.ContributeSavingsGoalUseCase>(
      () =>
          _i717.ContributeSavingsGoalUseCase(gh<_i555.SavingsGoalRepository>()),
    );
    gh.factory<_i398.CreateSavingsGoalUseCase>(
      () => _i398.CreateSavingsGoalUseCase(gh<_i555.SavingsGoalRepository>()),
    );
    gh.factory<_i309.DeleteSavingsGoalUseCase>(
      () => _i309.DeleteSavingsGoalUseCase(gh<_i555.SavingsGoalRepository>()),
    );
    gh.factory<_i738.GetSavingsGoalsUseCase>(
      () => _i738.GetSavingsGoalsUseCase(gh<_i555.SavingsGoalRepository>()),
    );
    gh.factory<_i759.CategoryLocalDatasource>(
      () => _i759.CategoryLocalDatasource(gh<_i676.CategoriesDao>()),
    );
    gh.factory<_i29.AccountLocalDatasource>(
      () => _i29.AccountLocalDatasource(gh<_i144.AccountsDao>()),
    );
    gh.factory<_i611.CreateBillReminderUseCase>(
      () => _i611.CreateBillReminderUseCase(gh<_i998.BillReminderRepository>()),
    );
    gh.factory<_i954.DeleteBillReminderUseCase>(
      () => _i954.DeleteBillReminderUseCase(gh<_i998.BillReminderRepository>()),
    );
    gh.factory<_i134.GetBillRemindersUseCase>(
      () => _i134.GetBillRemindersUseCase(gh<_i998.BillReminderRepository>()),
    );
    gh.factory<_i1030.SavingsGoalBloc>(
      () => _i1030.SavingsGoalBloc(
        getGoals: gh<_i738.GetSavingsGoalsUseCase>(),
        createGoal: gh<_i398.CreateSavingsGoalUseCase>(),
        deleteGoal: gh<_i309.DeleteSavingsGoalUseCase>(),
        contributeGoal: gh<_i717.ContributeSavingsGoalUseCase>(),
      ),
    );
    gh.factory<_i1067.AccountRepository>(
      () => _i857.AccountRepositoryImpl(gh<_i29.AccountLocalDatasource>()),
    );
    gh.factory<_i330.TransactionLocalDatasource>(
      () => _i330.TransactionLocalDatasource(gh<_i76.TransactionsDao>()),
    );
    gh.factory<_i441.BudgetLocalDatasource>(
      () => _i441.BudgetLocalDatasource(gh<_i152.BudgetsDao>()),
    );
    gh.factory<_i792.OnboardingBloc>(
      () => _i792.OnboardingBloc(
        accountRepository: gh<_i1067.AccountRepository>(),
        settingsBloc: gh<_i585.SettingsBloc>(),
      ),
    );
    gh.factory<_i947.CreateAccountUseCase>(
      () => _i947.CreateAccountUseCase(gh<_i1067.AccountRepository>()),
    );
    gh.factory<_i949.DeleteAccountUseCase>(
      () => _i949.DeleteAccountUseCase(gh<_i1067.AccountRepository>()),
    );
    gh.factory<_i67.GetAccountsUseCase>(
      () => _i67.GetAccountsUseCase(gh<_i1067.AccountRepository>()),
    );
    gh.factory<_i688.UpdateAccountUseCase>(
      () => _i688.UpdateAccountUseCase(gh<_i1067.AccountRepository>()),
    );
    gh.factory<_i391.BillReminderBloc>(
      () => _i391.BillReminderBloc(
        getBills: gh<_i134.GetBillRemindersUseCase>(),
        createBill: gh<_i611.CreateBillReminderUseCase>(),
        deleteBill: gh<_i954.DeleteBillReminderUseCase>(),
      ),
    );
    gh.factory<_i869.CategoryRepository>(
      () => _i528.CategoryRepositoryImpl(gh<_i759.CategoryLocalDatasource>()),
    );
    gh.factory<_i1022.TransactionRepository>(
      () => _i600.TransactionRepositoryImpl(
        gh<_i330.TransactionLocalDatasource>(),
      ),
    );
    gh.factory<_i346.CreateTransactionUseCase>(
      () => _i346.CreateTransactionUseCase(gh<_i1022.TransactionRepository>()),
    );
    gh.factory<_i572.DeleteTransactionUseCase>(
      () => _i572.DeleteTransactionUseCase(gh<_i1022.TransactionRepository>()),
    );
    gh.factory<_i794.GetTransactionsUseCase>(
      () => _i794.GetTransactionsUseCase(gh<_i1022.TransactionRepository>()),
    );
    gh.factory<_i708.AccountBloc>(
      () => _i708.AccountBloc(
        getAccounts: gh<_i67.GetAccountsUseCase>(),
        createAccount: gh<_i947.CreateAccountUseCase>(),
        updateAccount: gh<_i688.UpdateAccountUseCase>(),
        deleteAccount: gh<_i949.DeleteAccountUseCase>(),
        repository: gh<_i1067.AccountRepository>(),
      ),
    );
    gh.factory<_i894.BackupBloc>(
      () => _i894.BackupBloc(
        transactionRepository: gh<_i1022.TransactionRepository>(),
      ),
    );
    gh.factory<_i552.SearchBloc>(
      () => _i552.SearchBloc(
        transactionRepository: gh<_i1022.TransactionRepository>(),
      ),
    );
    gh.factory<_i356.TransactionBloc>(
      () => _i356.TransactionBloc(
        getTransactions: gh<_i794.GetTransactionsUseCase>(),
        createTransaction: gh<_i346.CreateTransactionUseCase>(),
        deleteTransaction: gh<_i572.DeleteTransactionUseCase>(),
        repository: gh<_i1022.TransactionRepository>(),
      ),
    );
    gh.factory<_i894.CreateCategoryUseCase>(
      () => _i894.CreateCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i1064.DeleteCategoryUseCase>(
      () => _i1064.DeleteCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i438.GetCategoriesByTypeUseCase>(
      () => _i438.GetCategoriesByTypeUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i125.GetCategoriesUseCase>(
      () => _i125.GetCategoriesUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i312.UpdateCategoryUseCase>(
      () => _i312.UpdateCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i438.BudgetRepository>(
      () => _i74.BudgetRepositoryImpl(gh<_i441.BudgetLocalDatasource>()),
    );
    gh.factory<_i70.AnalyticsBloc>(
      () => _i70.AnalyticsBloc(
        transactionRepository: gh<_i1022.TransactionRepository>(),
        categoryRepository: gh<_i869.CategoryRepository>(),
      ),
    );
    gh.factory<_i652.DashboardBloc>(
      () => _i652.DashboardBloc(
        accountRepository: gh<_i1067.AccountRepository>(),
        transactionRepository: gh<_i1022.TransactionRepository>(),
        budgetRepository: gh<_i438.BudgetRepository>(),
        savingsGoalRepository: gh<_i555.SavingsGoalRepository>(),
        billReminderRepository: gh<_i998.BillReminderRepository>(),
      ),
    );
    gh.factory<_i292.CategoryBloc>(
      () => _i292.CategoryBloc(
        getCategoriesByType: gh<_i438.GetCategoriesByTypeUseCase>(),
        createCategory: gh<_i894.CreateCategoryUseCase>(),
        updateCategory: gh<_i312.UpdateCategoryUseCase>(),
        deleteCategory: gh<_i1064.DeleteCategoryUseCase>(),
      ),
    );
    gh.factory<_i430.CreateBudgetUseCase>(
      () => _i430.CreateBudgetUseCase(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i860.DeleteBudgetUseCase>(
      () => _i860.DeleteBudgetUseCase(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i167.GetBudgetsForMonthUseCase>(
      () => _i167.GetBudgetsForMonthUseCase(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i651.UpdateBudgetUseCase>(
      () => _i651.UpdateBudgetUseCase(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i438.BudgetBloc>(
      () => _i438.BudgetBloc(
        getBudgetsForMonth: gh<_i167.GetBudgetsForMonthUseCase>(),
        createBudget: gh<_i430.CreateBudgetUseCase>(),
        updateBudget: gh<_i651.UpdateBudgetUseCase>(),
        deleteBudget: gh<_i860.DeleteBudgetUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
