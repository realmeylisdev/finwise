part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class SearchFilterChanged extends SearchEvent {
  const SearchFilterChanged({this.type, this.categoryId, this.accountId});
  final String? type;
  final String? categoryId;
  final String? accountId;
  @override
  List<Object?> get props => [type, categoryId, accountId];
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}
