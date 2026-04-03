class AchievementDefinition {
  const AchievementDefinition({
    required this.type,
    required this.title,
    required this.description,
    required this.iconName,
    required this.condition,
  });

  final String type;
  final String title;
  final String description;
  final String iconName;
  final bool Function(Map<String, double> stats) condition;
}

final achievementDefinitions = [
  AchievementDefinition(
    type: 'first_transaction',
    title: 'First Step',
    description: 'Record your first transaction',
    iconName: 'receipt',
    condition: (stats) => (stats['total_transactions'] ?? 0) >= 1,
  ),
  AchievementDefinition(
    type: 'transaction_10',
    title: 'Getting Started',
    description: 'Record 10 transactions',
    iconName: 'list',
    condition: (stats) => (stats['total_transactions'] ?? 0) >= 10,
  ),
  AchievementDefinition(
    type: 'transaction_50',
    title: 'Consistent Tracker',
    description: 'Record 50 transactions',
    iconName: 'trending_up',
    condition: (stats) => (stats['total_transactions'] ?? 0) >= 50,
  ),
  AchievementDefinition(
    type: 'transaction_100',
    title: 'Transaction Master',
    description: 'Record 100 transactions',
    iconName: 'star',
    condition: (stats) => (stats['total_transactions'] ?? 0) >= 100,
  ),
  AchievementDefinition(
    type: 'first_budget',
    title: 'Budget Beginner',
    description: 'Create your first budget',
    iconName: 'pie_chart',
    condition: (stats) => (stats['total_budgets'] ?? 0) >= 1,
  ),
  AchievementDefinition(
    type: 'budget_5',
    title: 'Budget Pro',
    description: 'Create 5 budgets',
    iconName: 'dashboard',
    condition: (stats) => (stats['total_budgets'] ?? 0) >= 5,
  ),
  AchievementDefinition(
    type: 'first_goal',
    title: 'Goal Setter',
    description: 'Create your first savings goal',
    iconName: 'flag',
    condition: (stats) => (stats['total_goals'] ?? 0) >= 1,
  ),
  AchievementDefinition(
    type: 'goal_completed',
    title: 'Goal Crusher',
    description: 'Complete a savings goal',
    iconName: 'trophy',
    condition: (stats) => (stats['goals_completed'] ?? 0) >= 1,
  ),
  AchievementDefinition(
    type: 'saved_100',
    title: 'First Hundred',
    description: 'Save \$100 total in goals',
    iconName: 'savings',
    condition: (stats) => (stats['total_saved'] ?? 0) >= 100,
  ),
  AchievementDefinition(
    type: 'saved_1000',
    title: 'Thousand Club',
    description: 'Save \$1,000 total in goals',
    iconName: 'diamond',
    condition: (stats) => (stats['total_saved'] ?? 0) >= 1000,
  ),
  AchievementDefinition(
    type: 'streak_7',
    title: 'Week Warrior',
    description: 'Log transactions 7 days in a row',
    iconName: 'local_fire_department',
    condition: (stats) => (stats['current_streak'] ?? 0) >= 7,
  ),
  AchievementDefinition(
    type: 'streak_30',
    title: 'Monthly Master',
    description: 'Log transactions 30 days in a row',
    iconName: 'whatshot',
    condition: (stats) => (stats['current_streak'] ?? 0) >= 30,
  ),
  AchievementDefinition(
    type: 'under_budget',
    title: 'Budget Keeper',
    description: 'Stay under budget for a full month',
    iconName: 'verified',
    condition: (stats) => (stats['months_under_budget'] ?? 0) >= 1,
  ),
  AchievementDefinition(
    type: 'multi_account',
    title: 'Diversified',
    description: 'Set up 3 or more accounts',
    iconName: 'account_balance',
    condition: (stats) => (stats['total_accounts'] ?? 0) >= 3,
  ),
  AchievementDefinition(
    type: 'net_worth_positive',
    title: 'In The Green',
    description: 'Achieve a positive net worth',
    iconName: 'trending_up',
    condition: (stats) => (stats['net_worth'] ?? 0) > 0,
  ),
];
