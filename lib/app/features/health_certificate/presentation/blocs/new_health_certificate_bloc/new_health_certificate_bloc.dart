import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:formz/formz.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../core/services/view_models/new_details_health_license_view_model.dart';
import '../../pages/add_new_license/certificate_info_step_screen.dart';
import '../../pages/add_new_license/pledges_step_screen.dart';

part 'new_health_certificate_event.dart';

part 'new_health_certificate_state.dart';

class NewHealthCertificateBloc
    extends Bloc<NewHealthCertificateEvent, NewHealthCertificateState> {
  PageController controller = PageController();
  final model = locator<NewDetailsHealthLicenseViewModel>();

  late List pagesList = [CertificateInfoStepScreen(), PledgesStepScreen()];

  NewHealthCertificateBloc({bool? renew})
      : super(NewHealthCertificateState(renew: renew)) {
    on<NewHealthCertificateEvent>((event, emit) {
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
    //print("next page");
    print("DataLog ${state}");
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      await controller.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);

      emitter(state.copyWith(
          status: BlocStatus.success,
          currentPageValue: nextPage,
          errorMessage: ""));
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
