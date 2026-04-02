import 'package:finwise/core/di/injection.dart';
import 'package:finwise/core/navigation/app_router.dart';
import 'package:finwise/core/theme/app_theme.dart';
import 'package:finwise/features/account/presentation/bloc/account_bloc.dart';
import 'package:finwise/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:finwise/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:finwise/features/bill_reminder/presentation/bloc/bill_reminder_bloc.dart';
import 'package:finwise/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:finwise/features/savings_goal/presentation/bloc/savings_goal_bloc.dart';
import 'package:finwise/features/search/presentation/bloc/search_bloc.dart';
import 'package:finwise/features/security/presentation/bloc/security_bloc.dart';
import 'package:finwise/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:finwise/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinWiseApp extends StatelessWidget {
  const FinWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SettingsBloc>()),
        BlocProvider(
          create: (_) =>
              getIt<CategoryBloc>()..add(const CategoriesLoaded()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<AccountBloc>()..add(const AccountsLoaded()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<TransactionBloc>()..add(const TransactionsLoaded()),
        ),
        BlocProvider(
          create: (_) => getIt<BudgetBloc>()
            ..add(BudgetsLoaded(year: now.year, month: now.month)),
        ),
        BlocProvider(
          create: (_) =>
              getIt<SavingsGoalBloc>()..add(const GoalsLoaded()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<BillReminderBloc>()..add(const BillsLoaded()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<DashboardBloc>()..add(const DashboardLoaded()),
        ),
        BlocProvider(create: (_) => getIt<AnalyticsBloc>()),
        BlocProvider(create: (_) => getIt<SearchBloc>()),
        BlocProvider(
          create: (_) => getIt<SecurityBloc>()
            ..add(const SecurityCheckRequested()),
        ),
        BlocProvider(create: (_) => getIt<BackupBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'FinWise',
                debugShowCheckedModeBanner: false,
                theme: AppTheme().lightTheme,
                darkTheme: AppTheme().darkTheme,
                themeMode: settingsState.themeMode,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
