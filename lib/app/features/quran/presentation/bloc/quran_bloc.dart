import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_sura_model.dart';
import 'package:balady_plus/app/features/vd/domain/entities/upload/upload_file_params.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/shared_prefs_manager.dart';
import '../../data/models/quran_aya_model.dart';
import '../../data/models/quran_book_mark_item_model.dart';

part 'quran_event.dart';

part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  PageController controller = PageController();

  QuranBloc({required int initialSuraNo})
      : super(QuranState(currentPageValue: initialSuraNo)) {
    on<QuranEvent>((event, emit) {});

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<initQuranEvent>(_initQuran);
    on<ChangePageEvent>(_getTitle);
    on<ToggleDetailsEvent>(_toggleDetailsEvent);
    on<MoveToPageEvent>(_moveToPageEvent);
    on<SaveBookMarkEvent>(_saveBookMarkEvent);

    add(initQuranEvent());
  }

  Future<void> _moveToPageEvent(MoveToPageEvent e, Emitter emitter) async {
    controller.jumpToPage(e.page - 1);
    ChangePageEvent(page: e.page - 1);
    add(ToggleDetailsEvent());
  }

  Future<void> _saveBookMarkEvent(SaveBookMarkEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    bool isAdded = await sharedPrefs.saveQuranBookMark(QuranBookMarkItemModel(
        pageNumber: state.currentPageValue + 1,
        suraName: state.currentTitle ?? "",
        suraNo: state.currentSuraNo ?? 0));

    emitter(state.copyWith(showBookMark: isAdded, status: BlocStatus.success));
  }

  Future<void> _toggleDetailsEvent(
      ToggleDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(showDetails: !(state.showDetails ?? false)));
  }

  Future<void> _initQuran(initQuranEvent e, Emitter emitter) async {
    String quran =
        await rootBundle.loadString("assets/quran/hafs_smart_v8.json");

    var r = json.decode(quran);
    //print(r);

    List<QuranAyaModel> quranAyat =
        List<QuranAyaModel>.from(r.map((x) => QuranAyaModel.fromMap(x)));

    Map<int, List<QuranAyaModel>> pages = {};
    Map<int, String> sura = {};

    Map<int, String>? pagesStr = {};

    Map<int, List<QuranSuraModel>>? suras = {};

    pages = {};
    quranAyat.forEach((element) {
      if (pages.containsKey(element.page)) {
        pages[element.page]!.add(element);
      } else {
        pages[element.page] = [element];
      }
    });

    quranAyat.forEach((element) {
      if (!sura.containsKey(element.suraNo)) {
        sura[element.suraNo] = element.suraNameAr;
      }
    });

    Map<int, Map<int, QuranSuraModel>>? pagesSuras = {};

    pages.forEach((key, value) {
      Map<int, QuranSuraModel> surasInPage = {};
      pagesSuras[key] = surasInPage;
      int i = 0;
      int oldI = i;
      value.forEachIndexed(
        (index, element) {
          if (element.ayaNo == 1 || element.lineStart == 1) i++;

          if (!surasInPage.containsKey(i)) {
            surasInPage[i] = QuranSuraModel(
                jozz: element.jozz,
                suraName: element.suraNameAr,
                suraNo: element.suraNo,
                suraAyat: [
                  {element.ayaNo: element.ayaText}
                ],
                suraAyatNormal: [
                  {element.ayaNo: element.ayaTextEmlaey}
                ]);
          } else {
            surasInPage[i]!.suraAyat.add({element.ayaNo: element.ayaText});
            surasInPage[i]!
                .suraAyatNormal
                .add({element.ayaNo: element.ayaTextEmlaey});
          }
        },
      );

      pagesSuras[key] = surasInPage;
    });

    emitter(state.copyWith(
        pages: pages,
        pagesStr: pagesStr,
        quranAyat: quranAyat,
        suraIndex: sura,
        suras: pagesSuras));
    print("ffgffgd ${state.currentPageValue.toDouble()}");

    print("Run ${state.currentPageValue}");
    controller.jumpToPage(getSuraPageNumber(state.currentPageValue + 1));

    add(ChangePageEvent(page: getSuraPageNumber(state.currentPageValue + 1)));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    //print("next page");

    if (state.status == BlocStatus.performing) return;
    int nextPage = state.currentPageValue + 1;

    emitter(state.copyWith(
      status: BlocStatus.performing,
    ));

    await controller.animateToPage(nextPage,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);

    emitter(
        state.copyWith(status: BlocStatus.success, currentPageValue: nextPage));

    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    int prvoiusPage = state.currentPageValue - 1;
    emitter(state.copyWith(
      status: BlocStatus.performing,
    ));
    await controller.animateToPage(prvoiusPage,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    emitter(state.copyWith(
        status: BlocStatus.success, currentPageValue: prvoiusPage));

    hideKeyboard();
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _getTitle(ChangePageEvent e, Emitter emitter) async {
    try {
      int currentPage = e.page ?? 0;
      print("element ${currentPage}");

      String suraName = "";
      state.suras?[currentPage + 1]?.values.forEachIndexed((index, element) {
        suraName =
            state.suras?[currentPage + 1]?.values.toList()[index].suraName ??
                "";
        print("element ${element.suraName}");

        if (element.suraName != suraName) suraName = element.suraName;
        emitter(state.copyWith(
            currentTitle: suraName,
            currentJozz: element.jozz,
            currentSuraNo: element.suraNo,
            currentPageValue: currentPage));
      });

      bool isMarked = await sharedPrefs.checkBookMark(QuranBookMarkItemModel(
          pageNumber: state.currentPageValue + 1,
          suraName: state.currentTitle ?? "",
          suraNo: state.currentSuraNo ?? 0));

      emitter(state.copyWith(showBookMark: isMarked));
    } catch (ex) {}
  }

  int getSuraPageNumber(int suraNumber) {
    int pageNo = -1;
    state.pages?.forEach((key, value) {
      QuranAyaModel? model =
          value.firstWhereOrNull((element) => element.suraNo == suraNumber);
      if (model != null && pageNo == -1) {
        pageNo = model.page;
      }
    });
    return pageNo - 1;
  }

  int getJozzPageNumber(int jozz) {
    int pageNo = -1;
    state.pages?.forEach((key, value) {
      QuranAyaModel? model =
          value.firstWhereOrNull((element) => element.jozz == jozz);
      if (model != null && pageNo == -1) {
        pageNo = model.page;
      }
    });
    return pageNo - 1;
  }
}
