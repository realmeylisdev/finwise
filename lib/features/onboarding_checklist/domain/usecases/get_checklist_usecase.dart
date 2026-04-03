import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:finwise/features/onboarding_checklist/domain/entities/checklist_item_entity.dart';
import 'package:finwise/features/onboarding_checklist/domain/entities/checklist_result_entity.dart';
import 'package:finwise/features/savings_goal/domain/repositories/savings_goal_repository.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetChecklistUseCase {
  GetChecklistUseCase({
    required TransactionRepository transactionRepository,
    required BudgetRepository budgetRepository,
    required SavingsGoalRepository savingsGoalRepository,
    required AccountRepository accountRepository,
  })  : _transactionRepo = transactionRepository,
        _budgetRepo = budgetRepository,
        _savingsGoalRepo = savingsGoalRepository,
        _accountRepo = accountRepository;

  final TransactionRepository _transactionRepo;
  final BudgetRepository _budgetRepo;
  final SavingsGoalRepository _savingsGoalRepo;
  final AccountRepository _accountRepo;

  Future<ChecklistResultEntity> call() async {
    // Fetch data from repositories
    final transactionsResult = await _transactionRepo.getTransactions();
    final transactions = transactionsResult.getOrElse((_) => []);
    final totalTransactions = transactions.length;

    final now = DateTime.now();
    final budgetsResult = await _budgetRepo.getBudgetsForMonth(
      now.year,
      now.month,
    );
    final budgets = budgetsResult.getOrElse((_) => []);

    final goalsResult = await _savingsGoalRepo.getGoals();
    final goals = goalsResult.getOrElse((_) => []);

    final accountsResult = await _accountRepo.getAccounts();
    final accounts = accountsResult.getOrElse((_) => []);

    // Build checklist items
    final items = <ChecklistItemEntity>[
      ChecklistItemEntity(
        id: 'first_transaction',
        title: 'Add your first transaction',
        description: 'Record your first income or expense',
        isCompleted: totalTransactions >= 1,
        route: '${AppRoutes.transactions}/new',
        iconName: 'add',
      ),
      ChecklistItemEntity(
        id: 'three_transactions',
        title: 'Record 3 transactions',
        description: 'Build the habit of tracking your finances',
        isCompleted: totalTransactions >= 3,
        route: '${AppRoutes.transactions}/new',
        iconName: 'list',
      ),
      ChecklistItemEntity(
        id: 'setup_budget',
        title: 'Set up a budget',
        description: 'Control your spending with category budgets',
        isCompleted: budgets.isNotEmpty,
        route: '${AppRoutes.budgets}/new',
        iconName: 'budget',
      ),
      ChecklistItemEntity(
        id: 'create_goal',
        title: 'Create a savings goal',
        description: 'Start saving towards something meaningful',
        isCompleted: goals.isNotEmpty,
        route: '${AppRoutes.goals}/new',
        iconName: 'goal',
      ),
      ChecklistItemEntity(
        id: 'second_account',
        title: 'Add a second account',
        description: 'Track multiple accounts for full visibility',
        isCompleted: accounts.length >= 2,
        route: AppRoutes.settingsAccountForm,
        iconName: 'account',
      ),
      ChecklistItemEntity(
        id: 'explore_analytics',
        title: 'Explore Analytics',
        description: 'Discover insights about your spending patterns',
        isCompleted: totalTransactions >= 1,
        route: AppRoutes.analytics,
        iconName: 'analytics',
      ),
    ];

    final completedCount = items.where((item) => item.isCompleted).length;

    return ChecklistResultEntity(
      items: items,
      completedCount: completedCount,
      totalCount: items.length,
    );
  }
}
