import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:finwise/shared/widgets/app_icon.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Appearance
              _SectionHeader(title: 'Appearance'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedPaintBoard,
                        color: Colors.purple,
                      ),
                      title: const Text('Theme'),
                      subtitle: Text(_themeName(state.themeMode)),
                      onTap: () => _showThemePicker(context, state),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const AppIcon(
                        icon: HugeIcons.strokeRoundedViewOff,
                        color: Colors.indigo,
                      ),
                      title: const Text('Privacy Mode'),
                      subtitle: const Text('Hide all balances'),
                      value: state.isPrivacyModeEnabled,
                      onChanged: (_) => context
                          .read<SettingsBloc>()
                          .add(const SettingsPrivacyToggled()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Data
              _SectionHeader(title: 'Data'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedDashboardSquare02,
                        color: Colors.orange,
                      ),
                      title: const Text('Categories'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.settingsCategories),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedWallet02,
                        color: Colors.blue,
                      ),
                      title: const Text('Accounts'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.settingsAccounts),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedNotification02,
                        color: Colors.red,
                      ),
                      title: const Text('Bill Reminders'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.settingsBills),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedSorting05,
                        color: Colors.deepPurple,
                      ),
                      title: const Text('Category Rules'),
                      subtitle:
                          const Text('Auto-categorize transactions'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context
                          .push(AppRoutes.settingsCategoryRules),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedChartLineData02,
                        color: Colors.green,
                      ),
                      title: const Text('Net Worth'),
                      subtitle:
                          const Text('Track assets & liabilities'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.netWorth),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedRepeat,
                        color: Colors.indigo,
                      ),
                      title: const Text('Subscriptions'),
                      subtitle:
                          const Text('Track recurring subscriptions'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.subscriptions),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedCreditCard,
                        color: Colors.red,
                      ),
                      title: const Text('Debt Payoff'),
                      subtitle:
                          const Text('Snowball & avalanche planner'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.debts),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Smart Features
              _SectionHeader(title: 'Smart Features'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedRepeat,
                        color: Colors.cyan,
                      ),
                      title: const Text('Recurring Transactions'),
                      subtitle:
                          const Text('Detect spending patterns'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.recurringPatterns),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedChartLineData01,
                        color: Colors.teal,
                      ),
                      title: const Text('Cash Flow Forecast'),
                      subtitle:
                          const Text('30-day balance projection'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.cashFlow),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Security
              _SectionHeader(title: 'Security'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedSquareLock02,
                        color: Colors.green,
                      ),
                      title: const Text('App Lock'),
                      subtitle:
                          const Text('PIN or biometric authentication'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.settingsSecurity),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // Backup
              _SectionHeader(title: 'Backup & Export'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedCloudDownload,
                        color: Colors.teal,
                      ),
                      title: const Text('Backup & Export'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.settingsBackup),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),

              // About
              _SectionHeader(title: 'About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const AppIcon(
                        icon: HugeIcons.strokeRoundedInformationCircle,
                        color: Colors.grey,
                      ),
                      title: const Text('About FinWise'),
                      subtitle: const Text('Version 1.0.0'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemePicker(BuildContext context, SettingsState state) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: ThemeMode.values
            .map(
              (mode) => RadioListTile<ThemeMode>(
                title: Text(_themeName(mode)),
                value: mode,
                groupValue: state.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<SettingsBloc>()
                        .add(SettingsThemeChanged(value));
                    Navigator.of(ctx).pop();
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingXS,
        bottom: AppDimensions.paddingS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
