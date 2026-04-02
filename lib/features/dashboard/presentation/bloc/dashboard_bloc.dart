import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:finwise/features/bill_reminder/domain/repositories/bill_reminder_repository.dart';
import 'package:finwise/features/budget/domain/repositories/budget_repository.dart';
import 'package:finwise/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:finwise/features/savings_goal/domain/repositories/savings_goal_repository.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:finwise/shared/extensions/date_extensions.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required AccountRepository accountRepository,
    required TransactionRepository transactionRepository,
    required BudgetRepository budgetRepository,
    required SavingsGoalRepository savingsGoalRepository,
    required BillReminderRepository billReminderRepository,
  })  : _accountRepo = accountRepository,
        _transactionRepo = transactionRepository,
        _budgetRepo = budgetRepository,
        _savingsGoalRepo = savingsGoalRepository,
        _billReminderRepo = billReminderRepository,
        super(const DashboardState()) {
    on<DashboardLoaded>(_onLoaded, transformer: droppable());
  }

  final AccountRepository _accountRepo;
  final TransactionRepository _transactionRepo;
  final BudgetRepository _budgetRepo;
  final SavingsGoalRepository _savingsGoalRepo;
  final BillReminderRepository _billReminderRepo;

  Future<void> _onLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      final now = DateTime.now();
      final monthStart = now.startOfMonth;
      final monthEnd = now.endOfMonth;

      final accountsResult = await _accountRepo.getAccounts();
      final balanceResult = await _accountRepo.getTotalBalance();
      final recentResult =
          await _transactionRepo.getTransactions(limit: 5);
      final incomeResult =
          await _transactionRepo.getTotalByType('income', monthStart, monthEnd);
      final expenseResult =
          await _transactionRepo.getTotalByType('expense', monthStart, monthEnd);
      final spendingResult =
          await _transactionRepo.getSpendingByCategory(monthStart, monthEnd);
      final budgetsResult =
          await _budgetRepo.getBudgetsForMonth(now.year, now.month);
      final goalsResult = await _savingsGoalRepo.getGoals();
      final billsResult =
          await _billReminderRepo.getUpcomingBills(now.day, 7);

      final accounts = accountsResult.getOrElse((_) => []);
      final totalBalance = balanceResult.getOrElse((_) => 0.0);
      final recentTxns = recentResult.getOrElse((_) => []);
      final totalIncome = incomeResult.getOrElse((_) => 0.0);
      final totalExpense = expenseResult.getOrElse((_) => 0.0);
      final spendingMap =
          spendingResult.getOrElse((_) => <String, double>{});
      final budgets = budgetsResult.getOrElse((_) => []);
      final goals = goalsResult.getOrElse((_) => []);
      final bills = billsResult.getOrElse((_) => []);

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          summary: DashboardSummaryEntity(
            totalBalance: totalBalance,
            totalIncome: totalIncome,
            totalExpense: totalExpense,
            accounts: accounts,
            recentTransactions: recentTxns,
            budgets: budgets,
            activeGoals: goals.where((g) => !g.isCompleted).toList(),
            upcomingBills: bills,
            spendingByCategory: spendingMap,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          failureMessage: e.toString(),
        ),
      );
    }
  }
}
