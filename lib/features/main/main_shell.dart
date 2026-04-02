import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finwise/shared/widgets/app_icon.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: AppIcon(icon: HugeIcons.strokeRoundedHome09),
            label: 'Home',
          ),
          NavigationDestination(
            icon: AppIcon(icon: HugeIcons.strokeRoundedTransaction),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: AppIcon(icon: HugeIcons.strokeRoundedPieChart01),
            label: 'Budgets',
          ),
          NavigationDestination(
            icon: AppIcon(icon: HugeIcons.strokeRoundedTarget02),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: AppIcon(icon: HugeIcons.strokeRoundedSettings02),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
