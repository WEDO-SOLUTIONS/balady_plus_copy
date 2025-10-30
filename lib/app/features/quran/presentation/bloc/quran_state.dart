// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quran_bloc.dart';

class QuranState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final int progressDownload;
  final List<QuranAyaModel>? quranAyat;
  final Map<int, List<QuranAyaModel>>? pages;
  final Map<int, String>? pagesStr;
  final String? currentTitle;
  final int? currentJozz;
  final int? currentSuraNo;
  final Map<int, String>? suraIndex;
  final Map<int, Map<int, QuranSuraModel>>? suras;
  final bool? showDetails;
  final bool? showBookMark;

  QuranState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.progressDownload = 0,
      this.pages,
      this.pagesStr,
      this.quranAyat,
      this.suraIndex,
      this.currentTitle,
      this.currentJozz,
      this.currentSuraNo,
      this.suras,
      this.showDetails,
      this.showBookMark});

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        progressDownload,
        quranAyat,
        pages,
        pagesStr,
        currentTitle,
        suraIndex,
        suras,
        currentJozz,
        currentSuraNo,
        showDetails,
        showBookMark
      ];

  QuranState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      int? currentPageValue,
      int? progressDownload,
      List<QuranAyaModel>? quranAyat,
      Map<int, List<QuranAyaModel>>? pages,
      Map<int, String>? pagesStr,
      String? currentTitle,
      int? currentJozz,
      int? currentSuraNo,
      Map<int, String>? suraIndex,
      Map<int, Map<int, QuranSuraModel>>? suras,
      bool? showDetails,
      bool? showBookMark}) {
    return QuranState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        progressDownload: progressDownload ?? this.progressDownload,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        quranAyat: quranAyat ?? this.quranAyat,
        pages: pages ?? this.pages,
        pagesStr: pagesStr ?? this.pagesStr,
        suraIndex: suraIndex ?? this.suraIndex,
        currentTitle: currentTitle ?? this.currentTitle,
        suras: suras ?? this.suras,
        currentSuraNo: currentSuraNo ?? this.currentSuraNo,
        currentJozz: currentJozz ?? this.currentJozz,
        showDetails: showDetails ?? this.showDetails,
        showBookMark: showBookMark ?? this.showBookMark);
  }
}
