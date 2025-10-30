part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class initSearchEvent extends SearchEvent {
  const initSearchEvent();
}

class SearchAyaEvent extends SearchEvent {
  final String? text;
  const SearchAyaEvent({this.text});
}
