import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finwise/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<E> _debounce<E>() {
  return (events, mapper) =>
      events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper);
}

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required TransactionRepository transactionRepository,
  })  : _transactionRepo = transactionRepository,
        super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged, transformer: _debounce());
    on<SearchFilterChanged>(_onFilterChanged, transformer: droppable());
    on<SearchCleared>(_onCleared);
  }

  final TransactionRepository _transactionRepo;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty && !state.hasFilters) {
      emit(state.copyWith(
        status: SearchStatus.initial,
        query: '',
        results: [],
      ));
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: event.query));
    await _search(emit);
  }

  Future<void> _onFilterChanged(
    SearchFilterChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(
      status: SearchStatus.loading,
      filterType: event.type,
      filterCategoryId: event.categoryId,
      filterAccountId: event.accountId,
    ));
    await _search(emit);
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchState());
  }

  Future<void> _search(Emitter<SearchState> emit) async {
    final result = await _transactionRepo.getTransactions();

    result.fold(
      (_) => emit(state.copyWith(status: SearchStatus.empty)),
      (allTxns) {
        var filtered = allTxns;

        // Text search on notes
        if (state.query.isNotEmpty) {
          final q = state.query.toLowerCase();
          filtered = filtered
              .where(
                (t) =>
                    (t.note?.toLowerCase().contains(q) ?? false) ||
                    (t.categoryName?.toLowerCase().contains(q) ?? false) ||
                    (t.accountName?.toLowerCase().contains(q) ?? false),
              )
              .toList();
        }

        // Filter by type
        if (state.filterType != null) {
          filtered = filtered
              .where((t) => t.type.name == state.filterType)
              .toList();
        }

        // Filter by category
        if (state.filterCategoryId != null) {
          filtered = filtered
              .where((t) => t.categoryId == state.filterCategoryId)
              .toList();
        }

        // Filter by account
        if (state.filterAccountId != null) {
          filtered = filtered
              .where((t) => t.accountId == state.filterAccountId)
              .toList();
        }

        emit(state.copyWith(
          status:
              filtered.isEmpty ? SearchStatus.empty : SearchStatus.success,
          results: filtered,
        ));
      },
    );
  }
}
