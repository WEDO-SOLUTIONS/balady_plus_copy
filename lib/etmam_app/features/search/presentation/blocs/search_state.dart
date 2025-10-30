part of 'search_bloc.dart';

class SearchState extends Equatable {
  BlocStatus status;
  int? totalPageCount;
  int? totalItemCount;
  int nextPageIndex;
  String? text;
  List<SearchItem>? items;
  String? errorMessage;

  SearchState(
      {this.status = BlocStatus.initial,
      this.totalItemCount,
      this.totalPageCount,
      this.nextPageIndex = 1,
      this.text,
      this.items,
      this.errorMessage});

  SearchState copyWith(
      {BlocStatus? status,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      String? text,
      List<SearchItem>? items,
      String? errorMessage}) {
    return SearchState(
        status: status ?? this.status,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        totalPageCount: totalPageCount ?? this.totalPageCount,
        nextPageIndex: nextPageIndex ?? this.nextPageIndex,
        text: text ?? this.text,
        items: items ?? this.items,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status];
}
