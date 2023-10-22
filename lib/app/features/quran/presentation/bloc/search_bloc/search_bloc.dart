import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_sura_model.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/models/quran_book_mark_model.dart';
import '../../../data/models/quran_search_sura_model.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({Map<int, Map<int, QuranSuraModel>>? suras})
      : super(SearchState(suras: suras)) {
    on<SearchEvent>((event, emit) {});
    on<initSearchEvent>(_initBookMark);
    on<SearchAyaEvent>(_searchDataHandler);
    add(initSearchEvent());
  }

  Future<void> _searchDataHandler(SearchAyaEvent e, Emitter emitter) async {
    List<QuranSearchSuraModel> searchedData = [];
    emitter(state.copyWith(status: BlocStatus.loading));

    if (e.text?.isEmpty ?? true) {
    } else {
      state.suras?.forEach((key, suras) {
        suras.forEach((key2, ayat) {
          ayat.suraAyatNormal.forEach((element) {
            element.forEach((key3, ayah) {
              if (ayah.contains(e.text!)) {
                searchedData.add(QuranSearchSuraModel(
                    aya: ayah,
                    ayahNo: key3,
                    jozz: ayat.jozz,
                    pageNo: key,
                    suraName: ayat.suraName,
                    suraNo: ayat.suraNo));
              }
            });
          });
        });
      });
    }

    emitter(
        state.copyWith(searchedData: searchedData, status: BlocStatus.success));
  }

  Future<void> _initBookMark(initSearchEvent e, Emitter emitter) async {}

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
