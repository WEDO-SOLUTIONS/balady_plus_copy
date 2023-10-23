import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/services_exports.dart';
import '../../../../../../core/utils/utils_exports.dart';
import '../../../../domain/use_cases/get_info_request.dart';
import '../../../../domain/use_cases/get_renew_years.dart';
import '../../../../renew_commercial_license_exports.dart';

part 'renew_commercial_license_event.dart';
part 'renew_commercial_license_state.dart';

class RenewCommercialLicenseBloc
    extends Bloc<RenewCommercialLicenseEvent, RenewCommercialLicenseState> {
  PageController controller = PageController();
  final CalculateRequestInfo _calculateRequestInfo;
  final GetRenewYears _getRenewYears;

  RenewCommercialLicenseBloc({required int requestId})
      : _getRenewYears = GetRenewYears(repository: sl()),
        _calculateRequestInfo = CalculateRequestInfo(repository: sl()),
        super(RenewCommercialLicenseState(requestId: requestId)) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<GetRenewYearsEvent>(_getRenewYearsHandler);
    on<GetRequestInfoEvent>(_getRequestInfoHandler);
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
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));
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
          status: BlocStatus.success, currentPageValue: prvoiusPage));
    }
    hideKeyboard();
  }

  Future<void> _getRenewYearsHandler(
      GetRenewYearsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _getRenewYears(state.requestId!);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, renewYears: r.data?.result));
    });
  }

  Future<void> _getRequestInfoHandler(
      GetRequestInfoEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _getRenewYears(state.requestId!);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, renewYears: r.data?.result));
    });
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
