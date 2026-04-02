part of 'analytics_bloc.dart';

enum AnalyticsStatus { initial, loading, success, failure }

enum AnalyticsPeriod { thisMonth, lastMonth, last3Months, last6Months }

class CategorySpending extends Equatable {
  const CategorySpending({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.amount,
    required this.percent,
  });

  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final int categoryColor;
  final double amount;
  final double percent;

  @override
  List<Object?> get props => [categoryId, amount, percent];
}

class MonthlyTotal extends Equatable {
  const MonthlyTotal({
    required this.month,
    required this.year,
    required this.income,
    required this.expense,
  });

  final int month;
  final int year;
  final double income;
  final double expense;

  @override
  List<Object?> get props => [month, year, income, expense];
}

class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.period = AnalyticsPeriod.thisMonth,
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.categorySpending = const [],
    this.monthlyTotals = const [],
    this.averageDailySpending = 0,
    this.topCategory,
    this.failureMessage,
  });

  final AnalyticsStatus status;
  final AnalyticsPeriod period;
  final double totalIncome;
  final double totalExpense;
  final List<CategorySpending> categorySpending;
  final List<MonthlyTotal> monthlyTotals;
  final double averageDailySpending;
  final CategorySpending? topCategory;
  final String? failureMessage;

  double get savings => totalIncome - totalExpense;

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsPeriod? period,
    double? totalIncome,
    double? totalExpense,
    List<CategorySpending>? categorySpending,
    List<MonthlyTotal>? monthlyTotals,
    double? averageDailySpending,
    CategorySpending? topCategory,
    String? failureMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      period: period ?? this.period,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      categorySpending: categorySpending ?? this.categorySpending,
      monthlyTotals: monthlyTotals ?? this.monthlyTotals,
      averageDailySpending:
          averageDailySpending ?? this.averageDailySpending,
      topCategory: topCategory ?? this.topCategory,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, period, totalIncome, totalExpense,
        categorySpending, monthlyTotals, averageDailySpending,
        topCategory, failureMessage,
      ];
}
