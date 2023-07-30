part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetSearchDataEvent extends SearchEvent {
  SearchParams? params;
  bool loadMore;
  GetSearchDataEvent({this.params, this.loadMore = false});
}

class GetSubServiceEvent extends SearchEvent {
  SubServiceParams params;
  GetSubServiceEvent({required this.params});
}

class GetProvidersEvent extends SearchEvent {
  ServiceParams params;
  GetProvidersEvent({required this.params});
}

class LoadMoreSearchDataEvent extends SearchEvent {
  LoadMoreSearchDataEvent();
}
