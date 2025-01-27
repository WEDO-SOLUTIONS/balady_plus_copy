import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/save_location_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step1/page/cr_step1_applicant_data.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/page/step2_intial_approval__activity_data.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../data/models/calculate_fees_response_model.dart';
import '../../../../data/models/initialApproval/request_details_model.dart';
import '../../../../data/models/qr/submit_commercial_response_model.dart';
import '../../../../domain/use_cases/get_initial_approval_request_details.dart';
import '../../step3/bloc/step3_conclusion_cubit.dart';
import '../../step3/page/step3_conclusion.dart';

part 'commercial_license_initial_Arrpoval_event.dart';

part 'commercial_license_initial_Approval_state.dart';

class CommercialLicenseInitialAprrovalBloc
    extends Bloc<CommercialLicenseInitialApprovalEvent, CommercialLicenseInitialApprovalState> {
  PageController controller = PageController();
  final getInitialApprovalRequestDetails _getInitialApprovalRequestDetails;

  CommercialLicenseInitialAprrovalBloc()
      : _getInitialApprovalRequestDetails = getInitialApprovalRequestDetails(repository: sl()),
        super(const CommercialLicenseInitialApprovalState()) {
    on<NextPageEvent>(_goToNextPageHandler);
    on<PreviousPageEvent>(_goToPreviousPageHandler);

    on<UpdateFieldEvent>(_updateRequestIdHandler);
  }

  Future<void> goToCalucaltePage() async {
    if (state.status == BlocStatus.performing) return;
    int nextPage = 9;

    emit(state.copyWith(
      status: BlocStatus.performing,
    ));

    controller.jumpToPage(nextPage);

    emit(
      state.copyWith(
        status: BlocStatus.success,
        currentPageValue: nextPage,
      ),
    );
    sendEventBasedOnPage(nextPage);
    hideKeyboard();
  }

  Future<void> _goToNextPageHandler(
      NextPageEvent e, Emitter emitter) async {
    int nextPage = state.currentPageValue + 1;


    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      controller.jumpToPage(nextPage);

      emitter(
        state.copyWith(
          status: BlocStatus.success,
          currentPageValue: nextPage,
        ),
      );
      sendEventBasedOnPage(nextPage);
    }

    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      PreviousPageEvent e, Emitter emitter) async {
    int prvoiusPage = state.currentPageValue - 1;

    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      controller.jumpToPage(prvoiusPage);

      emitter(state.copyWith(
        status: BlocStatus.success,
        currentPageValue: prvoiusPage,
      ));

      sendEventBasedOnPage(prvoiusPage);
    }

    hideKeyboard();
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void sendEventBasedOnPage(int nextPage) {
    String eventName = "";
    if (nextPage == 0) {
      eventName = UXCamEvents.CommercialLicense_Open_Applicant_Info_Step_Event;
    } else if (nextPage == 1) {
      eventName = UXCamEvents.CommercialLicense_Open_Activity_Info_Step_Event;
    } else if (nextPage == 2) {
      eventName = UXCamEvents.CommercialLicense_Open_Location_Info_Step_Event;
    } else if (nextPage == 3) {
      eventName =
          UXCamEvents.CommercialLicense_Open_Shop_And_Board_Details_Step_Event;
    } else if (nextPage == 4) {
      eventName = UXCamEvents.CommercialLicense_Open_Attachment_Step_Event;
    } else if (nextPage == 5) {
      eventName =
          UXCamEvents.CommercialLicense_Open_QR_Establishment_Info_Event;
    } else if (nextPage == 6) {
      eventName =
          UXCamEvents.CommercialLicense_Open_QR_Working_Hours_Info_Event;
    } else if (nextPage == 7) {
      eventName = UXCamEvents.CommercialLicense_Open_QR_Addetional_Data_Event;
    } else if (nextPage == 8) {
      eventName = UXCamEvents.CommercialLicense_Open_QR_Attachment_Info_Event;
    } else if (nextPage == 9) {
      eventName = UXCamEvents.CommercialLicense_Open_Saddad_Years_Step_Event;
    } else if (nextPage == 10) {
      eventName = UXCamEvents.CommercialLicense_Open_Calculator_Step_Event;
    }

    CommonFunctions.sendUXCamEvent(eventName);
  }


  Future<void> _updateRequestIdHandler(
      UpdateFieldEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        requestId: e.requestId != null ? Nullable(e.requestId) : null,
        locationResponse: e.saveLocationResponse));
  }

  Future<void> updateQrData(
      {SubmitCommercialResponseModel? applyCommercialResponse}) async {
    print(applyCommercialResponse);
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(
        applyCommercialResponse: applyCommercialResponse,
        status: BlocStatus.success));
  }

  Future<void> updateCalculatorData(
      {CalculateFeesResponseModel? crCalculateFeesResponse,
      String? selectedPeriod}) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(
        crCalculateFeesResponse: crCalculateFeesResponse,
        selectedPeriod: selectedPeriod,
        status: BlocStatus.success));
  }

  Future<void> updateGISData({GISResponse? gis}) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(gisResponse: gis, status: BlocStatus.success));
  }

  Future<void> updateRequestDetails({RequestDetailsModel? info}) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(requestDetails: info, status: BlocStatus.success));
  }



  Future<void> getCommercialRequestData() async {
    emit(state.copyWith(
      detailsStatus: BlocStatus.loading,
    ));

    final response = await _getInitialApprovalRequestDetails(state.requestId!);
    response.fold(
            (failure) {

              emit(state.copyWith(detailsStatus: BlocStatus.failure,));

            }

        , (success) {


      emit(state.copyWith(requestDetails: success.data?.result));
    });


  }

  void initState({int? requestId,}) {
    emit(
      state.copyWith(
        status: BlocStatus.initial,
        isDraft: requestId != null ? true : false,

        currentPageValue: 0,
        requestId: Nullable(requestId),
       // requestData: Nullable(null),
        pagesList:  [
          CRStep1ApplicantData(),
          Step2IntialApprovalActivityData(),
          Step3ConclusionPage(),
        ],
      ),
    );

    // if (requestId != null && state.requestDetails == null) {
    //
    //   getCommercialRequestData();
    // }
  }
}
