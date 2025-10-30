import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:formz/formz.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../core/models/appointment_details_model.dart';
import '../../core/services/view_models/new_appointment_view_model.dart';
import '../../pages/new_appointment_screens/book_new_appointment_date_time_screen.dart';
import '../../pages/new_appointment_screens/new_appointment_first_step_screen.dart';

part 'new_appointment_event.dart';

part 'new_appointment_state.dart';

class NewAppointmentBloc
    extends Bloc<NewAppointmentEvent, NewAppointmentState> {
  PageController controller = PageController();
  final dataModel = locator<NewAppointmentViewModel>();

  late List pagesList = [
    NewAppointmentFirstStepScreen(),
    const BookNewAppointmentDateTimeScreen(),
  ];

  NewAppointmentBloc(
      {bool? withPreviousTransaction, AppointmentItemInfo? editedItem})
      : super(NewAppointmentState(
            withPreviousTransaction: false, editedItemInfo: editedItem)) {
    locator<NewAppointmentViewModel>().init();

    on<NewAppointmentEvent>((event, emit) {
      controller.addListener(() {});
    });

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    dataModel.setUpDraft(item: editedItem);
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

        int? serviceId = dataModel.serviceConfigResponse?.getServiceId();
        if (serviceId != null) {
          isSuccess = await dataModel.getAvailableDates(serviceId);
        }
        if (isSuccess) {
          await controller.animateToPage(nextPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn);

          emitter(state.copyWith(
              status: BlocStatus.success,
              currentPageValue: nextPage,
              errorMessage: ""));
        } else {
          emitter(state.copyWith(
            status: BlocStatus.success,
          ));
        }
      } else if (nextPage == pagesList.length - 1) {
        dataModel.saveAppointment();
      } else {
        await controller.animateToPage(nextPage,
            duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

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
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
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
