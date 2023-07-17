import 'dart:convert';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/upload/upload_file_params.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../data/models/quran_aya_model.dart';

part 'quran_event.dart';

part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  PageController controller = PageController();

  QuranBloc() : super(QuranState()) {
    on<QuranEvent>((event, emit) {});

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<initQuranEvent>(_initQuran);
    on<ChangePageEvent>(_getTitle);
    add(initQuranEvent());
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

    pagesStr = pages.map((key, value) {
      return MapEntry(
          key,
          value.map((e) {
            if (e.ayaNo == 1)
              return "\n\n ${e.suraNameAr} \n\n" + e.ayaText;
            else
              return e.ayaText;
          }).join());
    });

    emitter(state.copyWith(
        pages: pages,
        pagesStr: pagesStr,
        quranAyat: quranAyat,
        suraIndex: sura));
    add(ChangePageEvent(page: 0));
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
      print(currentPage);
      String suraName = "";
      state.pages?[currentPage + 1]?.forEachIndexed((index, element) {
        QuranAyaModel? m = state.pages?[currentPage + 1]?[0];
        suraName = m?.suraNameAr ?? "";

        if (element.suraNameAr != suraName) suraName = element.suraNameAr;
        emitter(state.copyWith(currentTitle: suraName));
      });
    } catch (ex) {}
  }

  int getSuraPageNumber(int suraNumber) {
    print(suraNumber);
    int pageNo = -1;
    state.pages?.forEach((key, value) {
      QuranAyaModel? model =
          value.firstWhereOrNull((element) => element.suraNo == suraNumber);
      if (model != null && pageNo == -1) {
        print(model.page);
        pageNo = model.page;
      }
    });
    return pageNo - 1;
  }
}
