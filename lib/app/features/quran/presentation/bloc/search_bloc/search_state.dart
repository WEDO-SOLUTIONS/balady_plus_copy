// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

class SearchState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final Map<int, Map<int, QuranSuraModel>>? suras;
  List<QuranSearchSuraModel>? searchedData;
  SearchState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.suras,
      this.searchedData});

  @override
  List<Object?> get props => [status, currentPageValue];

  SearchState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      int? currentPageValue,
      Map<int, Map<int, QuranSuraModel>>? suras,
      List<QuranSearchSuraModel>? searchedData}) {
    return SearchState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        suras: suras ?? this.suras,
        searchedData: searchedData ?? this.searchedData);
  }
}
