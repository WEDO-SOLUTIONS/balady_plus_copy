import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/zmzm_points/zmzm_points_exports.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
    emitter(
        state.copyWith(cities: ["makkah".tr(), "jeddah".tr(), "madina".tr()]));

    emitter(state.copyWith(items: [
      ZMZMItemModel(
          id: 1,
          city: "makkah".tr(),
          name: "zmzm_project".tr(),
          mapUrl: "https://goo.gl/maps/pPLWJ4hYTarbkQ8f6?coh=178571&entry=tt"),
      ZMZMItemModel(
          id: 2,
          city: "jeddah".tr(),
          name: "zmzm_project".tr(),
          mapUrl: "https://maps.app.goo.gl/ebC9zj1HnHDbV25c6"),
      ZMZMItemModel(
          id: 3,
          city: "jeddah".tr(),
          name: "zmzm_project".tr(),
          mapUrl: "https://maps.app.goo.gl/odha4UTAFZD2rcxH6"),
      ZMZMItemModel(
          id: 4,
          city: "madina".tr(),
          name: "zmzm_project".tr(),
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
