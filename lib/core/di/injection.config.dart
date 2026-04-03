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
import '../../features/achievements/data/datasources/achievement_local_datasource.dart'
    as _i140;
import '../../features/achievements/data/repositories/achievement_repository_impl.dart'
    as _i445;
import '../../features/achievements/domain/repositories/achievement_repository.dart'
    as _i282;
import '../../features/achievements/domain/usecases/check_achievements_usecase.dart'
    as _i798;
import '../../features/achievements/presentation/bloc/achievements_bloc.dart'
    as _i411;
import '../../features/ai_insights/domain/usecases/analyze_spending_patterns_usecase.dart'
    as _i829;
import '../../features/ai_insights/domain/usecases/detect_anomalies_usecase.dart'
    as _i595;
import '../../features/ai_insights/presentation/bloc/ai_insights_bloc.dart'
    as _i585;
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
import '../../features/cash_flow/domain/usecases/generate_forecast_usecase.dart'
    as _i851;
import '../../features/cash_flow/presentation/bloc/cash_flow_bloc.dart'
    as _i405;
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
import '../../features/category_rule/data/datasources/category_rule_local_datasource.dart'
    as _i1012;
import '../../features/category_rule/data/repositories/category_rule_repository_impl.dart'
    as _i624;
import '../../features/category_rule/domain/repositories/category_rule_repository.dart'
    as _i870;
import '../../features/category_rule/presentation/bloc/category_rule_bloc.dart'
    as _i444;
import '../../features/dashboard/domain/usecases/generate_insights_usecase.dart'
    as _i228;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/debt_payoff/data/datasources/debt_payoff_local_datasource.dart'
    as _i262;
import '../../features/debt_payoff/data/repositories/debt_payoff_repository_impl.dart'
    as _i103;
import '../../features/debt_payoff/domain/repositories/debt_payoff_repository.dart'
    as _i341;
import '../../features/debt_payoff/domain/usecases/calculate_payoff_plan_usecase.dart'
    as _i822;
import '../../features/debt_payoff/presentation/bloc/debt_payoff_bloc.dart'
    as _i946;
import '../../features/investments/data/datasources/investments_local_datasource.dart'
    as _i338;
import '../../features/investments/data/repositories/investments_repository_impl.dart'
    as _i837;
import '../../features/investments/domain/repositories/investments_repository.dart'
    as _i896;
import '../../features/investments/presentation/bloc/investments_bloc.dart'
    as _i963;
import '../../features/net_worth/data/datasources/net_worth_local_datasource.dart'
    as _i224;
import '../../features/net_worth/data/repositories/net_worth_repository_impl.dart'
    as _i74;
import '../../features/net_worth/domain/repositories/net_worth_repository.dart'
    as _i569;
import '../../features/net_worth/presentation/bloc/net_worth_bloc.dart'
    as _i486;
import '../../features/notifications/data/datasources/notification_local_datasource.dart'
    as _i372;
import '../../features/notifications/data/repositories/notification_repository_impl.dart'
    as _i361;
import '../../features/notifications/domain/repositories/notification_repository.dart'
    as _i367;
import '../../features/notifications/domain/usecases/generate_weekly_digest_usecase.dart'
    as _i386;
import '../../features/notifications/presentation/bloc/notifications_bloc.dart'
    as _i1041;
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i792;
import '../../features/onboarding_checklist/domain/usecases/get_checklist_usecase.dart'
    as _i145;
import '../../features/onboarding_checklist/presentation/bloc/checklist_bloc.dart'
    as _i641;
import '../../features/profiles/data/datasources/profile_local_datasource.dart'
    as _i544;
import '../../features/profiles/data/repositories/profile_repository_impl.dart'
    as _i275;
import '../../features/profiles/domain/repositories/profile_repository.dart'
    as _i428;
import '../../features/profiles/presentation/bloc/profiles_bloc.dart' as _i630;
import '../../features/recurring_detection/domain/usecases/detect_recurring_usecase.dart'
    as _i579;
import '../../features/recurring_detection/presentation/bloc/recurring_detection_bloc.dart'
    as _i897;
import '../../features/reports/data/services/pdf_report_builder.dart' as _i826;
import '../../features/reports/domain/usecases/generate_annual_report_usecase.dart'
    as _i1062;
import '../../features/reports/domain/usecases/generate_monthly_report_usecase.dart'
    as _i851;
import '../../features/reports/presentation/bloc/reports_bloc.dart' as _i554;
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
import '../../features/shared_budgets/data/datasources/shared_budget_local_datasource.dart'
    as _i750;
import '../../features/shared_budgets/data/repositories/shared_budget_repository_impl.dart'
    as _i172;
import '../../features/shared_budgets/domain/repositories/shared_budget_repository.dart'
    as _i146;
import '../../features/shared_budgets/presentation/bloc/shared_budgets_bloc.dart'
    as _i104;
import '../../features/split_transaction/data/datasources/split_transaction_local_datasource.dart'
    as _i175;
import '../../features/split_transaction/data/repositories/split_transaction_repository_impl.dart'
    as _i475;
import '../../features/split_transaction/domain/repositories/split_transaction_repository.dart'
    as _i421;
import '../../features/subscription/data/datasources/subscription_local_datasource.dart'
    as _i174;
import '../../features/subscription/data/repositories/subscription_repository_impl.dart'
    as _i331;
import '../../features/subscription/domain/repositories/subscription_repository.dart'
    as _i185;
import '../../features/subscription/presentation/bloc/subscription_bloc.dart'
    as _i858;
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
import '../../features/wellness_score/domain/usecases/calculate_wellness_score_usecase.dart'
    as _i817;
import '../../features/wellness_score/presentation/bloc/wellness_score_bloc.dart'
    as _i998;
import '../database/app_database.dart' as _i982;
import '../database/daos/accounts_dao.dart' as _i144;
import '../database/daos/achievements_dao.dart' as _i1063;
import '../database/daos/assets_dao.dart' as _i662;
import '../database/daos/bill_reminders_dao.dart' as _i855;
import '../database/daos/budgets_dao.dart' as _i152;
import '../database/daos/categories_dao.dart' as _i676;
import '../database/daos/category_rules_dao.dart' as _i409;
import '../database/daos/currencies_dao.dart' as _i545;
import '../database/daos/debt_payments_dao.dart' as _i781;
import '../database/daos/debts_dao.dart' as _i744;
import '../database/daos/investment_history_dao.dart' as _i515;
import '../database/daos/investments_dao.dart' as _i547;
import '../database/daos/liabilities_dao.dart' as _i878;
import '../database/daos/net_worth_snapshots_dao.dart' as _i956;
import '../database/daos/notifications_dao.dart' as _i496;
import '../database/daos/profiles_dao.dart' as _i526;
import '../database/daos/savings_goals_dao.dart' as _i800;
import '../database/daos/shared_budgets_dao.dart' as _i811;
import '../database/daos/subscriptions_dao.dart' as _i434;
import '../database/daos/transaction_splits_dao.dart' as _i658;
import '../database/daos/transactions_dao.dart' as _i76;
import '../database/daos/user_stats_dao.dart' as _i608;
import '../services/currency_service.dart' as _i31;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i228.GenerateInsightsUseCase>(
      () => _i228.GenerateInsightsUseCase(),
    );
    gh.factory<_i822.CalculatePayoffPlanUseCase>(
      () => _i822.CalculatePayoffPlanUseCase(),
    );
    gh.factory<_i826.PdfReportBuilder>(() => _i826.PdfReportBuilder());
    gh.factory<_i676.SecurityBloc>(() => _i676.SecurityBloc());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i982.AppDatabase>(() => registerModule.database);
    gh.singleton<_i31.CurrencyService>(() => _i31.CurrencyService());
    gh.singleton<_i544.ProfileLocalDatasource>(
      () => _i544.ProfileLocalDatasource(),
    );
    gh.singleton<_i585.SettingsBloc>(() => _i585.SettingsBloc());
    gh.singleton<_i750.SharedBudgetLocalDatasource>(
      () => _i750.SharedBudgetLocalDatasource(),
    );
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
    gh.singleton<_i409.CategoryRulesDao>(
      () => registerModule.categoryRulesDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i658.TransactionSplitsDao>(
      () => registerModule.transactionSplitsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i662.AssetsDao>(
      () => registerModule.assetsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i878.LiabilitiesDao>(
      () => registerModule.liabilitiesDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i956.NetWorthSnapshotsDao>(
      () => registerModule.netWorthSnapshotsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i434.SubscriptionsDao>(
      () => registerModule.subscriptionsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i744.DebtsDao>(
      () => registerModule.debtsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i781.DebtPaymentsDao>(
      () => registerModule.debtPaymentsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i1063.AchievementsDao>(
      () => registerModule.achievementsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i608.UserStatsDao>(
      () => registerModule.userStatsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i496.NotificationsDao>(
      () => registerModule.notificationsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i547.InvestmentsDao>(
      () => registerModule.investmentsDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i515.InvestmentHistoryDao>(
      () => registerModule.investmentHistoryDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i526.ProfilesDao>(
      () => registerModule.profilesDao(gh<_i982.AppDatabase>()),
    );
    gh.singleton<_i811.SharedBudgetsDao>(
      () => registerModule.sharedBudgetsDao(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i212.BillReminderLocalDatasource>(
      () => _i212.BillReminderLocalDatasource(gh<_i855.BillRemindersDao>()),
    );
    gh.factory<_i428.ProfileRepository>(
      () => _i275.ProfileRepositoryImpl(gh<_i544.ProfileLocalDatasource>()),
    );
    gh.factory<_i224.NetWorthLocalDatasource>(
      () => _i224.NetWorthLocalDatasource(
        gh<_i662.AssetsDao>(),
        gh<_i878.LiabilitiesDao>(),
        gh<_i956.NetWorthSnapshotsDao>(),
      ),
    );
    gh.factory<_i372.NotificationLocalDatasource>(
      () => _i372.NotificationLocalDatasource(gh<_i496.NotificationsDao>()),
    );
    gh.factory<_i680.SavingsGoalLocalDatasource>(
      () => _i680.SavingsGoalLocalDatasource(gh<_i800.SavingsGoalsDao>()),
    );
    gh.factory<_i998.BillReminderRepository>(
      () => _i728.BillReminderRepositoryImpl(
        gh<_i212.BillReminderLocalDatasource>(),
      ),
    );
    gh.factory<_i338.InvestmentsLocalDatasource>(
      () => _i338.InvestmentsLocalDatasource(
        gh<_i547.InvestmentsDao>(),
        gh<_i515.InvestmentHistoryDao>(),
      ),
    );
    gh.factory<_i555.SavingsGoalRepository>(
      () => _i32.SavingsGoalRepositoryImpl(
        gh<_i680.SavingsGoalLocalDatasource>(),
      ),
    );
    gh.factory<_i630.ProfilesBloc>(
      () => _i630.ProfilesBloc(repository: gh<_i428.ProfileRepository>()),
    );
    gh.factory<_i140.AchievementLocalDatasource>(
      () => _i140.AchievementLocalDatasource(
        gh<_i1063.AchievementsDao>(),
        gh<_i608.UserStatsDao>(),
      ),
    );
    gh.factory<_i896.InvestmentsRepository>(
      () => _i837.InvestmentsRepositoryImpl(
        gh<_i338.InvestmentsLocalDatasource>(),
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
    gh.factory<_i963.InvestmentsBloc>(
      () =>
          _i963.InvestmentsBloc(repository: gh<_i896.InvestmentsRepository>()),
    );
    gh.factory<_i759.CategoryLocalDatasource>(
      () => _i759.CategoryLocalDatasource(gh<_i676.CategoriesDao>()),
    );
    gh.factory<_i146.SharedBudgetRepository>(
      () => _i172.SharedBudgetRepositoryImpl(
        gh<_i750.SharedBudgetLocalDatasource>(),
      ),
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
    gh.factory<_i1012.CategoryRuleLocalDatasource>(
      () => _i1012.CategoryRuleLocalDatasource(gh<_i409.CategoryRulesDao>()),
    );
    gh.factory<_i174.SubscriptionLocalDatasource>(
      () => _i174.SubscriptionLocalDatasource(gh<_i434.SubscriptionsDao>()),
    );
    gh.factory<_i1067.AccountRepository>(
      () => _i857.AccountRepositoryImpl(gh<_i29.AccountLocalDatasource>()),
    );
    gh.factory<_i367.NotificationRepository>(
      () => _i361.NotificationRepositoryImpl(
        gh<_i372.NotificationLocalDatasource>(),
      ),
    );
    gh.factory<_i330.TransactionLocalDatasource>(
      () => _i330.TransactionLocalDatasource(gh<_i76.TransactionsDao>()),
    );
    gh.factory<_i262.DebtPayoffLocalDatasource>(
      () => _i262.DebtPayoffLocalDatasource(
        gh<_i744.DebtsDao>(),
        gh<_i781.DebtPaymentsDao>(),
      ),
    );
    gh.factory<_i441.BudgetLocalDatasource>(
      () => _i441.BudgetLocalDatasource(gh<_i152.BudgetsDao>()),
    );
    gh.factory<_i175.SplitTransactionLocalDatasource>(
      () => _i175.SplitTransactionLocalDatasource(
        gh<_i658.TransactionSplitsDao>(),
      ),
    );
    gh.factory<_i185.SubscriptionRepository>(
      () => _i331.SubscriptionRepositoryImpl(
        gh<_i174.SubscriptionLocalDatasource>(),
      ),
    );
    gh.factory<_i386.GenerateWeeklyDigestUseCase>(
      () => _i386.GenerateWeeklyDigestUseCase(
        gh<_i76.TransactionsDao>(),
        gh<_i367.NotificationRepository>(),
      ),
    );
    gh.factory<_i569.NetWorthRepository>(
      () => _i74.NetWorthRepositoryImpl(gh<_i224.NetWorthLocalDatasource>()),
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
    gh.factory<_i870.CategoryRuleRepository>(
      () => _i624.CategoryRuleRepositoryImpl(
        gh<_i1012.CategoryRuleLocalDatasource>(),
      ),
    );
    gh.factory<_i104.SharedBudgetsBloc>(
      () => _i104.SharedBudgetsBloc(
        repository: gh<_i146.SharedBudgetRepository>(),
      ),
    );
    gh.factory<_i869.CategoryRepository>(
      () => _i528.CategoryRepositoryImpl(gh<_i759.CategoryLocalDatasource>()),
    );
    gh.factory<_i282.AchievementRepository>(
      () => _i445.AchievementRepositoryImpl(
        gh<_i140.AchievementLocalDatasource>(),
      ),
    );
    gh.factory<_i858.SubscriptionBloc>(
      () => _i858.SubscriptionBloc(
        repository: gh<_i185.SubscriptionRepository>(),
      ),
    );
    gh.factory<_i1022.TransactionRepository>(
      () => _i600.TransactionRepositoryImpl(
        gh<_i330.TransactionLocalDatasource>(),
      ),
    );
    gh.factory<_i579.DetectRecurringUseCase>(
      () => _i579.DetectRecurringUseCase(gh<_i1022.TransactionRepository>()),
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
    gh.factory<_i1041.NotificationsBloc>(
      () => _i1041.NotificationsBloc(
        repository: gh<_i367.NotificationRepository>(),
        generateWeeklyDigestUseCase: gh<_i386.GenerateWeeklyDigestUseCase>(),
      ),
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
    gh.factory<_i829.AnalyzeSpendingPatternsUseCase>(
      () => _i829.AnalyzeSpendingPatternsUseCase(
        transactionRepository: gh<_i1022.TransactionRepository>(),
      ),
    );
    gh.factory<_i595.DetectAnomaliesUseCase>(
      () => _i595.DetectAnomaliesUseCase(
        transactionRepository: gh<_i1022.TransactionRepository>(),
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
    gh.factory<_i486.NetWorthBloc>(
      () => _i486.NetWorthBloc(repository: gh<_i569.NetWorthRepository>()),
    );
    gh.factory<_i851.GenerateForecastUseCase>(
      () => _i851.GenerateForecastUseCase(
        accountRepository: gh<_i1067.AccountRepository>(),
        billReminderRepository: gh<_i998.BillReminderRepository>(),
        transactionRepository: gh<_i1022.TransactionRepository>(),
      ),
    );
    gh.factory<_i1062.GenerateAnnualReportUseCase>(
      () => _i1062.GenerateAnnualReportUseCase(
        transactionRepository: gh<_i1022.TransactionRepository>(),
        savingsGoalRepository: gh<_i555.SavingsGoalRepository>(),
        pdfReportBuilder: gh<_i826.PdfReportBuilder>(),
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
    gh.factory<_i341.DebtPayoffRepository>(
      () =>
          _i103.DebtPayoffRepositoryImpl(gh<_i262.DebtPayoffLocalDatasource>()),
    );
    gh.factory<_i421.SplitTransactionRepository>(
      () => _i475.SplitTransactionRepositoryImpl(
        gh<_i175.SplitTransactionLocalDatasource>(),
      ),
    );
    gh.factory<_i585.AiInsightsBloc>(
      () => _i585.AiInsightsBloc(
        analyzeSpendingPatternsUseCase:
            gh<_i829.AnalyzeSpendingPatternsUseCase>(),
        detectAnomaliesUseCase: gh<_i595.DetectAnomaliesUseCase>(),
      ),
    );
    gh.factory<_i438.BudgetRepository>(
      () => _i74.BudgetRepositoryImpl(gh<_i441.BudgetLocalDatasource>()),
    );
    gh.factory<_i946.DebtPayoffBloc>(
      () => _i946.DebtPayoffBloc(
        repository: gh<_i341.DebtPayoffRepository>(),
        calculatePayoffPlan: gh<_i822.CalculatePayoffPlanUseCase>(),
      ),
    );
    gh.factory<_i444.CategoryRuleBloc>(
      () => _i444.CategoryRuleBloc(
        repository: gh<_i870.CategoryRuleRepository>(),
      ),
    );
    gh.factory<_i70.AnalyticsBloc>(
      () => _i70.AnalyticsBloc(
        transactionRepository: gh<_i1022.TransactionRepository>(),
        categoryRepository: gh<_i869.CategoryRepository>(),
      ),
    );
    gh.factory<_i817.CalculateWellnessScoreUseCase>(
      () => _i817.CalculateWellnessScoreUseCase(
        transactionRepository: gh<_i1022.TransactionRepository>(),
        budgetRepository: gh<_i438.BudgetRepository>(),
        debtPayoffRepository: gh<_i341.DebtPayoffRepository>(),
      ),
    );
    gh.factory<_i798.CheckAchievementsUseCase>(
      () => _i798.CheckAchievementsUseCase(gh<_i282.AchievementRepository>()),
    );
    gh.factory<_i411.AchievementsBloc>(
      () => _i411.AchievementsBloc(
        repository: gh<_i282.AchievementRepository>(),
        checkAchievementsUseCase: gh<_i798.CheckAchievementsUseCase>(),
      ),
    );
    gh.factory<_i145.GetChecklistUseCase>(
      () => _i145.GetChecklistUseCase(
        transactionRepository: gh<_i1022.TransactionRepository>(),
        budgetRepository: gh<_i438.BudgetRepository>(),
        savingsGoalRepository: gh<_i555.SavingsGoalRepository>(),
        accountRepository: gh<_i1067.AccountRepository>(),
      ),
    );
    gh.factory<_i897.RecurringDetectionBloc>(
      () => _i897.RecurringDetectionBloc(
        detectRecurring: gh<_i579.DetectRecurringUseCase>(),
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
    gh.factory<_i405.CashFlowBloc>(
      () => _i405.CashFlowBloc(
        generateForecastUseCase: gh<_i851.GenerateForecastUseCase>(),
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
    gh.factory<_i641.ChecklistBloc>(
      () => _i641.ChecklistBloc(
        getChecklistUseCase: gh<_i145.GetChecklistUseCase>(),
      ),
    );
    gh.factory<_i851.GenerateMonthlyReportUseCase>(
      () => _i851.GenerateMonthlyReportUseCase(
        transactionRepository: gh<_i1022.TransactionRepository>(),
        budgetRepository: gh<_i438.BudgetRepository>(),
        pdfReportBuilder: gh<_i826.PdfReportBuilder>(),
      ),
    );
    gh.factory<_i652.DashboardBloc>(
      () => _i652.DashboardBloc(
        accountRepository: gh<_i1067.AccountRepository>(),
        transactionRepository: gh<_i1022.TransactionRepository>(),
        budgetRepository: gh<_i438.BudgetRepository>(),
        savingsGoalRepository: gh<_i555.SavingsGoalRepository>(),
        billReminderRepository: gh<_i998.BillReminderRepository>(),
        generateInsightsUseCase: gh<_i228.GenerateInsightsUseCase>(),
      ),
    );
    gh.factory<_i554.ReportsBloc>(
      () => _i554.ReportsBloc(
        generateMonthlyReport: gh<_i851.GenerateMonthlyReportUseCase>(),
        generateAnnualReport: gh<_i1062.GenerateAnnualReportUseCase>(),
      ),
    );
    gh.factory<_i998.WellnessScoreBloc>(
      () => _i998.WellnessScoreBloc(
        calculateWellnessScoreUseCase:
            gh<_i817.CalculateWellnessScoreUseCase>(),
      ),
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
