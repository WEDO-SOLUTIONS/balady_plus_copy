// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'book_mark_bloc.dart';

class BookMarkState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final QuranBookMarkModel? items;

  BookMarkState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.items});

  @override
  List<Object?> get props => [status, currentPageValue, items];

  BookMarkState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      int? currentPageValue,
      Map<int, String>? pagesStr,
      String? currentTitle,
      int? currentJozz,
      Map<int, String>? suraIndex,
      Map<int, Map<int, QuranSuraModel>>? suras,
      bool? showDetails,
      QuranBookMarkModel? items}) {
    return BookMarkState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        items: items ?? this.items);
  }
}
