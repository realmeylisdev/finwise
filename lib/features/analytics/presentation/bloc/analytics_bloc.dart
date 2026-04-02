import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/category/domain/repositories/category_repository.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:finwise/shared/extensions/date_extensions.dart';
import 'package:injectable/injectable.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

@injectable
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({
    required TransactionRepository transactionRepository,
    required CategoryRepository categoryRepository,
  })  : _transactionRepo = transactionRepository,
        _categoryRepo = categoryRepository,
        super(const AnalyticsState()) {
    on<AnalyticsLoaded>(_onLoaded, transformer: droppable());
    on<AnalyticsPeriodChanged>(_onPeriodChanged, transformer: droppable());
  }

  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;

  Future<void> _onLoaded(
    AnalyticsLoaded event,
    Emitter<AnalyticsState> emit,
  ) async {
    await _loadData(emit, state.period);
  }

  Future<void> _onPeriodChanged(
    AnalyticsPeriodChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    await _loadData(emit, event.period);
  }

  Future<void> _loadData(
    Emitter<AnalyticsState> emit,
    AnalyticsPeriod period,
  ) async {
    emit(state.copyWith(status: AnalyticsStatus.loading, period: period));

    try {
      final now = DateTime.now();
      final range = _getDateRange(period, now);

      // Get totals
      final incomeResult = await _transactionRepo.getTotalByType(
        'income',
        range.$1,
        range.$2,
      );
      final expenseResult = await _transactionRepo.getTotalByType(
        'expense',
        range.$1,
        range.$2,
      );
      final spendingResult = await _transactionRepo.getSpendingByCategory(
        range.$1,
        range.$2,
      );

      final income = incomeResult.getOrElse((_) => 0.0);
      final expense = expenseResult.getOrElse((_) => 0.0);
      final spendingMap =
          spendingResult.getOrElse((_) => <String, double>{});

      // Get category details
      final categoriesResult = await _categoryRepo.getCategories();
      final categories = categoriesResult.getOrElse((_) => []);
      final categoryMap = {for (final c in categories) c.id: c};

      // Build category spending list
      final totalSpending =
          spendingMap.values.fold<double>(0, (s, v) => s + v);
      final categorySpending = spendingMap.entries
          .map((e) {
            final cat = categoryMap[e.key];
            return CategorySpending(
              categoryId: e.key,
              categoryName: cat?.name ?? 'Unknown',
              categoryIcon: cat?.icon ?? 'category',
              categoryColor: cat?.color ?? 0xFF9E9E9E,
              amount: e.value,
              percent: totalSpending > 0 ? e.value / totalSpending : 0,
            );
          })
          .toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

      // Monthly totals (last 6 months)
      final monthlyTotals = <MonthlyTotal>[];
      for (var i = 5; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i);
        final mStart = month.startOfMonth;
        final mEnd = month.endOfMonth;

        final mIncome = await _transactionRepo.getTotalByType(
          'income',
          mStart,
          mEnd,
        );
        final mExpense = await _transactionRepo.getTotalByType(
          'expense',
          mStart,
          mEnd,
        );

        monthlyTotals.add(
          MonthlyTotal(
            month: month.month,
            year: month.year,
            income: mIncome.getOrElse((_) => 0.0),
            expense: mExpense.getOrElse((_) => 0.0),
          ),
        );
      }

      // Average daily spending
      final days = range.$2.difference(range.$1).inDays.clamp(1, 365);
      final avgDaily = expense / days;

      emit(
        state.copyWith(
          status: AnalyticsStatus.success,
          totalIncome: income,
          totalExpense: expense,
          categorySpending: categorySpending,
          monthlyTotals: monthlyTotals,
          averageDailySpending: avgDaily,
          topCategory:
              categorySpending.isNotEmpty ? categorySpending.first : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AnalyticsStatus.failure,
          failureMessage: e.toString(),
        ),
      );
    }
  }

  (DateTime, DateTime) _getDateRange(AnalyticsPeriod period, DateTime now) {
    switch (period) {
      case AnalyticsPeriod.thisMonth:
        return (now.startOfMonth, now.endOfMonth);
      case AnalyticsPeriod.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1);
        return (lastMonth.startOfMonth, lastMonth.endOfMonth);
      case AnalyticsPeriod.last3Months:
        final start = DateTime(now.year, now.month - 2);
        return (start.startOfMonth, now.endOfMonth);
      case AnalyticsPeriod.last6Months:
        final start = DateTime(now.year, now.month - 5);
        return (start.startOfMonth, now.endOfMonth);
    }
  }
}
