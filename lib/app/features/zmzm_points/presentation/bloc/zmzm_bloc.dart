import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/zmzm_points/zmzm_points_exports.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'zmzm_event.dart';

part 'zmzm_state.dart';

class ZmZmBloc extends Bloc<ZmZmEvent, ZmZmState> {
  PageController controller = PageController();

  ZmZmBloc() : super(ZmZmState()) {
    on<ZmZmEvent>((event, emit) {});

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<initZmZmEvent>(_initZmZm);
    on<ChangeCityEvent>(_changeCityEventHandler);
    add(initZmZmEvent());
  }

  Future<void> _initZmZm(initZmZmEvent e, Emitter emitter) async {
    emitter(state.copyWith(cities: ["مكة المكرمة", "جدة", "المدينة"]));

    emitter(state.copyWith(items: [
      ZMZMItemModel(
          id: 1,
          city: "مكة المكرمة",
          name:
              "مشروع خادم الحرمين الشريفين لسقيا زمزم (جميع الأماكن تابعة للمشروع)",
          mapUrl: "https://goo.gl/maps/pPLWJ4hYTarbkQ8f6?coh=178571&entry=tt"),
      ZMZMItemModel(
          id: 2,
          city: "جدة",
          name:
              "مشروع خادم الحرمين الشريفين لسقيا زمزم (جميع الأماكن تابعة للمشروع)",
          mapUrl: "https://goo.gl/maps/V1ynEY6uWDgLT6fN6?coh=178571&entry=tt"),
      ZMZMItemModel(
          id: 3,
          city: "جدة",
          name:
              "مشروع خادم الحرمين الشريفين لسقيا زمزم (جميع الأماكن تابعة للمشروع)",
          mapUrl: "https://goo.gl/maps/mKaXsBGvwHuYQphw7?coh=178571&entry=tt"),
      ZMZMItemModel(
          id: 4,
          city: "المدينة",
          name:
              "مشروع خادم الحرمين الشريفين لسقيا زمزم (جميع الأماكن تابعة للمشروع)",
          mapUrl: "https://goo.gl/maps/2NCFyi2zv643aUh46?coh=178571&entry=tt"),
    ]));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
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

  Future<void> _changeCityEventHandler(
      ChangeCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCity: e.city));
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
