part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, empty }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.filterType,
    this.filterCategoryId,
    this.filterAccountId,
  });

  final SearchStatus status;
  final String query;
  final List<TransactionEntity> results;
  final String? filterType;
  final String? filterCategoryId;
  final String? filterAccountId;

  bool get hasFilters =>
      filterType != null ||
      filterCategoryId != null ||
      filterAccountId != null;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<TransactionEntity>? results,
    String? filterType,
    String? filterCategoryId,
    String? filterAccountId,
    bool clearFilters = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      filterType: clearFilters ? null : (filterType ?? this.filterType),
      filterCategoryId:
          clearFilters ? null : (filterCategoryId ?? this.filterCategoryId),
      filterAccountId:
          clearFilters ? null : (filterAccountId ?? this.filterAccountId),
    );
  }

  @override
  List<Object?> get props => [
        status, query, results, filterType,
        filterCategoryId, filterAccountId,
      ];
}
