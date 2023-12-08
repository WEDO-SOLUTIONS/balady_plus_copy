import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:formz/formz.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/local/navigation_services.dart';
import '../../../pages/inquiry/general_inquiry/new_general_inquiry.dart';

part 'general_inquiry_event.dart';

part 'general_inquiry_state.dart';

class GeneralInquiryBloc
    extends Bloc<GeneralInquiryEvent, GeneralInquiryState> {
  PageController controller = PageController();

  late List pagesList = [NewGeneralInquiryScreen()];

  GeneralInquiryBloc() : super(GeneralInquiryState()) {
    on<GeneralInquiryEvent>((event, emit) {
      controller.addListener(() {});
    });

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
  }

  void cancelIncident() {
    hideKeyboard(); //MM
    bool Function(Route<dynamic>) predicate =
        ModalRoute.withName(RouteName.bottomNavigation);
    NavigationService.navigatorKey.currentState!.popUntil((predicate));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      if (nextPage == 1) {
        hideKeyboard();
        bool isSuccess = false;
      } else if (nextPage == pagesList.length - 1) {
      } else {
        await controller.animateToPage(nextPage,
            duration: Duration(milliseconds: 400), curve: Curves.easeIn);

        emitter(state.copyWith(
            status: BlocStatus.success,
            currentPageValue: nextPage,
            errorMessage: ""));
      }
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      await controller.animateToPage(prvoiusPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      emitter(state.copyWith(
          status: BlocStatus.success,
          currentPageValue: prvoiusPage,
          errorMessage: ""));
    }
    hideKeyboard();
  }

  bool isLastPage() {
    return state.currentPageValue == (pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
