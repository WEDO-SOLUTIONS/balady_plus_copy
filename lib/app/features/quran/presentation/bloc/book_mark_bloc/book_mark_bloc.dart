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

part 'book_mark_event.dart';

part 'book_mark_state.dart';

class BookMarkBloc extends Bloc<BookMarkEvent, BookMarkState> {
  BookMarkBloc() : super(BookMarkState()) {
    on<BookMarkEvent>((event, emit) {});
    on<initBookMarkEvent>(_initBookMark);
    on<ToggleDetailsEvent>(_toggleDetailsEvent);
    add(initBookMarkEvent());
  }

  Future<void> _toggleDetailsEvent(
      ToggleDetailsEvent e, Emitter emitter) async {}

  Future<void> _initBookMark(initBookMarkEvent e, Emitter emitter) async {
    QuranBookMarkModel items = await sharedPrefs.getQuranBookMark();

    emitter(state.copyWith(items: items));
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
