import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permit_poster_types_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
import '../../data/models/validate_hotel_license.dart';
import '../../domain/entities/permit_tobacco_caclualte_request.dart';
import '../../domain/entities/submit_tobacco_request.dart';
import '../../domain/entities/validate_hotel_license_request.dart';
import '../../domain/use_case/calculate_tobacco_permit_cost.dart';
import '../../domain/use_case/delete_tobacco_permit_request.dart';
import '../../domain/use_case/get_allowed_actions.dart';
import '../../domain/use_case/get_permit_alerts.dart';
import '../../domain/use_case/get_permit_request_details.dart';
import '../../domain/use_case/submit_tobacco_permit.dart';
import '../../domain/use_case/validate_before_apply.dart';
import '../../domain/use_case/validate_hotel.dart';
import '../pages/steps/step1_page.dart';
import '../pages/steps/step2_page.dart';

import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';

part 'permit_tobacco_event.dart';
part 'permit_tobacco_state.dart';

class PermitTobaccoLicenseBloc
    extends Bloc<PermitTobaccoLicenseEvent, PermitTobaccoLicenseState> {
  PageController controller = PageController();
  TextEditingController hotelLicenseContrller = TextEditingController();
  CalculatePermitTobaccoHourCost _calculatePermit24HourCost;
  DeletePermitTobaccoHourCost _deletePermit24HourCost;
  GetAllowedActions _getAllowedActions;
  GetPermitsAlerts _getPermitsAlerts;
  GetPermitRequestDetails _getPermitRequestDetails;
  SubmitPermitTobacco _submitPermit24;
  ValidateBeforeApply _validateBeforeApply;
  ValidateTobaccoHotel _validateTobaccoHotel;

  PermitTobaccoLicenseBloc(
      {int? licenseId,
      int? requestId,
      CommercialLicenceDetails? commercialLicenceDetails})
      : _calculatePermit24HourCost =
            CalculatePermitTobaccoHourCost(repository: sl()),
        _deletePermit24HourCost = DeletePermitTobaccoHourCost(repository: sl()),
        _getAllowedActions = GetAllowedActions(repository: sl()),
        _getPermitsAlerts = GetPermitsAlerts(repository: sl()),
        _getPermitRequestDetails = GetPermitRequestDetails(repository: sl()),
        _submitPermit24 = SubmitPermitTobacco(repository: sl()),
        _validateBeforeApply = ValidateBeforeApply(repository: sl()),
        _validateTobaccoHotel = ValidateTobaccoHotel(repository: sl()),
        super(PermitTobaccoLicenseState(
            requestId: requestId,
            licenseId: licenseId,
            commercialLicenceDetails: commercialLicenceDetails)) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<ValidatePermitEvent>(_validatePermitHandler);
    on<SubmitPermitEvent>(_submitPosterHandler);

    on<GetPermitRequestDetailsEvent>(_getRequestDetails);
    on<GetPermitAlertsEvent>(_getPostersAlertsHandler);

    on<DeletePermitRequestEvent>(_deleteRequestsHandler);
    on<CalculatePermitCostEvent>(_calculateRequestsHandler);
    on<ToggleAgreementEvent>(_toggleAgreementHandler);
    on<ValidateTobaccoHotelEvent>(_validateTobaccoHotelHandler);
    on<ChangeIsIndieHotelEvent>(_changeIsIndieHotellHandler);
    on<ChangeHotelLicenseNumber>(_changeHotelLicenseNumberHandler);
    add(const GetPermitAlertsEvent());
  }

  Future<void> _changeHotelLicenseNumberHandler(
      ChangeHotelLicenseNumber e, Emitter emitter) async {
    emitter(state.copyWith(
        hotelLicenseNumber: e.value ?? "",
        error: "",
        permitTobaccoValidateHotelLicenseResponse: Nullable(null)));
  }

  Future<void> _changeIsIndieHotellHandler(
      ChangeIsIndieHotelEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        isInsideHotel: e.value,
        error: "",
        permitTobaccoValidateHotelLicenseResponse: Nullable(null)));
  }

  Future<void> _validateTobaccoHotelHandler(
      ValidateTobaccoHotelEvent e, Emitter emitter) async {
    if (state.hotelLicenseNumber == null) {
      CommonFunctions.showError("permit_tobacco_no_hotel_license_msg"
          .tr()
          .replaceAll("{}", state.licenseId.toString()));
      return;
    }

    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess =
        await _validateTobaccoHotel(ValidateHotelLicenseRequest(
      licenseNumber: state.licenseId!,
      hotelLicense: int.tryParse(state.hotelLicenseNumber!)!,
    ));

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          permitTobaccoValidateHotelLicenseResponse: Nullable(r)));
    });
  }

  Future<void> _toggleAgreementHandler(
      ToggleAgreementEvent e, Emitter emitter) async {
    emitter(state.copyWith(agreement: e.agreement));
  }

  Future<void> _calculateRequestsHandler(
      CalculatePermitCostEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _calculatePermit24HourCost(
        PermitTobaccoCalculateRequest(
            licenseNumber: state.licenseId!,
            hotelLicenseNumber: state.hotelLicenseNumber != null
                ? int.tryParse(state.hotelLicenseNumber ?? "")
                : null,
            insideHotel: state.isInsideHotel!));

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
          UXCamEvents.My_Requests_Tobaco_Permit_Details_Delete_Request_Event);

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
    final failOrSuccess = await _getPermitsAlerts(NoParams());

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

  Future<void> _validatePermitHandler(
      ValidatePermitEvent e, Emitter emitter) async {
    //  NavigationService.navigatorKey.currentState!
    //   .pushNamed(CommercialRouteName.permitsTobaccoDetailsPage, arguments: this);

    // return;
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
          .pushNamed(CommercialRouteName.permitsTobaccoDetailsPage, arguments: this);
    });
  }

  Future<void> _submitPosterHandler(
      SubmitPermitEvent e, Emitter emitter) async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Permit_Tobaco_Send_Request_Event);

    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _submitPermit24(SubmitTobaccoRequest(
        requestId: state.requestDetails?.requestInfo?.requestId,
        licenseNumber: state.licenseId!,
        insideHotel: state.isInsideHotel ?? false,
        hotelLicenseNumber: state.isInsideHotel == true
            ? int.tryParse(state.hotelLicenseNumber ?? "")
            : null));

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));

      NavigationService.navigatorKey.currentState!.popAndPushNamed(
        CommercialRouteName.submitApplicationSuccessfullyTobaccoPermits,
        arguments: r,
      );
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Permit_Tobaco_Open_Success_Page_Event);
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
      emitter(state.copyWith(
          licenseId: r.licenseInfo?.licenseNumber,
          hotelLicenseNumber: r.requestInfo?.hotelInfo?.licenseNumber != null
              ? r.requestInfo?.hotelInfo?.licenseNumber.toString()
              : null,
          isInsideHotel: r.requestInfo?.hotelInfo != null,
          permitTobaccoValidateHotelLicenseResponse:
              r.requestInfo?.hotelInfo != null
                  ? Nullable(PermitTobaccoValidateHotelLicense(
                      hotelClass: HotelClass(
                          id: r.requestInfo?.hotelInfo?.hotelClassCode,
                          name: r.requestInfo?.hotelInfo?.hotelName),
                      hotelName: r.requestInfo?.hotelInfo?.hotelName))
                  : null,
          detailsStatus: BlocStatus.success,
          requestDetails: r));

      hotelLicenseContrller.text =
          r.requestInfo?.hotelInfo?.licenseNumber != null
              ? r.requestInfo!.hotelInfo!.licenseNumber.toString()
              : "";
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
      sendEventSteps(nextPage);
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
      sendEventSteps(prvoiusPage);
    }
    hideKeyboard();
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  void sendEventSteps(int page) {
    if (page == 0) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Permit_Tobaco_Open_Hotel_Step_Event);
    } else if (page == 1) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Permit_Tobaco_Open_Review_Step_Event);
    }
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
