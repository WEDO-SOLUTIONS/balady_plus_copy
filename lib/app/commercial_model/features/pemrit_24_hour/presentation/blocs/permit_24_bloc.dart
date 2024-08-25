import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permit_poster_types_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/nullable.dart';
import 'package:collection/collection.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';
import '../../data/models/allowed_actions_response.dart';
import '../../data/models/calculate_cost_response_model.dart';
import '../../data/models/permit_request_details_model.dart';
import '../../data/models/permits_alerts_response.dart';
import '../../domain/use_case/calculate_permit24Hour_cost.dart';
import '../../domain/use_case/delete_permit_request.dart';
import '../../domain/use_case/get_allowed_actions.dart';
import '../../domain/use_case/get_permit_alerts.dart';
import '../../domain/use_case/get_permit_request_details.dart';
import '../../domain/use_case/submit_permit_24.dart';
import '../../domain/use_case/validate_before_apply.dart';
import '../pages/steps/step1_page.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';

part 'permit_24_event.dart';
part 'permit_24_state.dart';

class Permit24LicenseBloc
    extends Bloc<Permit24LicenseEvent, Permit24LicenseState> {
  PageController controller = PageController();
  CalculatePermit24HourCost _calculatePermit24HourCost;
  DeletePermit24HourCost _deletePermit24HourCost;
  GetAllowedActions _getAllowedActions;

  GetPermitsAlerts _getPermitsAlerts;

  GetPermitRequestDetails _getPermitRequestDetails;
  SubmitPermit24 _submitPermit24;

  ValidateBeforeApply _validateBeforeApply;

  Permit24LicenseBloc(
      {int? licenseId,
      int? requestId,
      CommercialLicenceDetails? commercialLicenceDetails})
      : _calculatePermit24HourCost =
            CalculatePermit24HourCost(repository: sl()),
        _deletePermit24HourCost = DeletePermit24HourCost(repository: sl()),
        _getAllowedActions = GetAllowedActions(repository: sl()),
        _getPermitsAlerts = GetPermitsAlerts(repository: sl()),
        _getPermitRequestDetails = GetPermitRequestDetails(repository: sl()),
        _submitPermit24 = SubmitPermit24(repository: sl()),
        _validateBeforeApply = ValidateBeforeApply(repository: sl()),
        super(Permit24LicenseState(
            requestId: requestId,
            licenseId: licenseId,
            commercialLicenceDetails: commercialLicenceDetails)) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<ValidatePermitEvent>(_validatePermitHandler);
    on<SubmitPermitEvent>(_submitPosterHandler);

    on<GetPermitRequestDetailsEvent>(_getRequestDetails);
    on<GetPermitAlertsEvent>(_getPostersAlertsHandler);
    on<GetPermitEndorsmentsEvent>(_getPostersEndorsmentHandler);

    on<DeletePermitRequestEvent>(_deleteRequestsHandler);
    on<CalculatePermitCostEvent>(_calculateRequestsHandler);
    on<ToggleAgreementEvent>(_toggleAgreementHandler);

    add(const GetPermitAlertsEvent());
    add(const GetPermitEndorsmentsEvent());
  }

  Future<void> _toggleAgreementHandler(
      ToggleAgreementEvent e, Emitter emitter) async {
    emitter(state.copyWith(agreement: e.agreement));
  }

  Future<void> _calculateRequestsHandler(
      CalculatePermitCostEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _calculatePermit24HourCost(state.licenseId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, calculateCost24PermitResponse: r));
    });
  }

  Future<void> _deleteRequestsHandler(
      DeletePermitRequestEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _deletePermit24HourCost(state.requestId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.My_Requests_24_Permit_Details_Delete_Request_Event);

      emitter(state.copyWith(status: BlocStatus.success));
      add(GetPermitRequestDetailsEvent());
    });
  }

  Future<List<AllowedActionItem>?> getAllowedActions() async {
    emit(state.copyWith(status: BlocStatus.loading, error: ""));

    return (await _getAllowedActions(state.requestId!)).fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) async {
      emit(state.copyWith(status: BlocStatus.success, error: ""));

      return r.result ?? [];
    });
  }

  Future<void> _getPostersAlertsHandler(
      GetPermitAlertsEvent e, Emitter emitter) async {
    emitter(state.copyWith(alertsStatus: BlocStatus.loading));
    final failOrSuccess = await _getPermitsAlerts("ALERTS");

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          alertsStatus: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(
          state.copyWith(alertsStatus: BlocStatus.success, alerts: r.result));
    });
  }

  Future<void> _getPostersEndorsmentHandler(
      GetPermitEndorsmentsEvent e, Emitter emitter) async {
    emitter(state.copyWith(alertsStatus: BlocStatus.loading));
    final failOrSuccess = await _getPermitsAlerts("ENDORSEMENT");

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          endormentsStatus: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          endormentsStatus: BlocStatus.success, endorsments: r.result));
    });
  }

  Future<void> _validatePermitHandler(
      ValidatePermitEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _validateBeforeApply(state.licenseId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));

      NavigationService.navigatorKey.currentState!
          .pushNamed(CommercialRouteName.permitsDetailsPage, arguments: this);
    });
  }

  Future<void> _submitPosterHandler(
      SubmitPermitEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _submitPermit24(state.licenseId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));

      NavigationService.navigatorKey.currentState!.popAndPushNamed(
        CommercialRouteName.submitApplicationSuccessfullyPermits,
        arguments: r,
      );

      CommonFunctions.sendUXCamEvent(UXCamEvents.Permit_24_Send_Request_Event);
    });
  }

  Future<void> _getRequestDetails(
      GetPermitRequestDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(detailsStatus: BlocStatus.loading));
    final failOrSuccess = await _getPermitRequestDetails(state.requestId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          detailsStatus: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(
          state.copyWith(detailsStatus: BlocStatus.success, requestDetails: r));
    });
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    int nextPage = state.currentPageValue + 1;

    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;

      emitter(state.copyWith(status: BlocStatus.performing, error: ""));

      controller.jumpToPage(nextPage);

      emitter(state.copyWith(
          error: "", status: BlocStatus.success, currentPageValue: nextPage));

      if (nextPage == 0) {
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.Permit_24_Open_Review_Step_Event);
      }
    }

    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    int prvoiusPage = state.currentPageValue - 1;

    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      emitter(state.copyWith(status: BlocStatus.performing, error: ""));
      controller.jumpToPage(prvoiusPage);

      emitter(state.copyWith(
          error: "",
          status: BlocStatus.success,
          currentPageValue: prvoiusPage));

      if (prvoiusPage == 0) {
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.Permit_24_Open_Review_Step_Event);
      }
    }
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
