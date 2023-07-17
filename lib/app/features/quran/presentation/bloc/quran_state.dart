// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quran_bloc.dart';

class QuranState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<QuranAyaModel>? quranAyat;
  final Map<int, List<QuranAyaModel>>? pages;
  final Map<int, String>? pagesStr;
  final String? currentTitle;
  final Map<int, String>? suraIndex;
  QuranState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.pages,
      this.pagesStr,
      this.quranAyat,
      this.suraIndex,
      this.currentTitle});

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        quranAyat,
        pages,
        pagesStr,
        currentTitle,
        suraIndex
      ];

  QuranState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      int? currentPageValue,
      List<QuranAyaModel>? quranAyat,
      Map<int, List<QuranAyaModel>>? pages,
      Map<int, String>? pagesStr,
      String? currentTitle,
      Map<int, String>? suraIndex}) {
    return QuranState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        quranAyat: quranAyat ?? this.quranAyat,
        pages: pages ?? this.pages,
        pagesStr: pagesStr ?? this.pagesStr,
        suraIndex: suraIndex ?? this.suraIndex,
        currentTitle: currentTitle ?? this.currentTitle);
  }
}
