import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/save_cancellation_reason_response.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/submit_response.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/services/global/web_service.dart';

part 'commercial_license_cancel_event.dart';

part 'commercial_license_cancel_state.dart';

class CommercialLicenseCancelBloc
    extends Bloc<CommercialLicenseEvent, CommercialLicenseCancelState> {
  final WebService webService;

  // final SubmitterInfo submitterInfo;
  final String crNumber ;
  final CancellationRequestResponse cancellationRequestResponse;
  ReasonCancel? reasonCancel;
  HijriCalendar? hijriCalendar;
  final TextEditingController controller = TextEditingController();
  bool acknowledgePledge = false;
  bool showCostInfo = false;

  SaveCancellationReasonResponse? saveCancellationReasonResponse;
  SubmitResponse? submitResponse;

  CommercialLicenseCancelBloc({
    required this.webService,
    required this.crNumber,
    required this.cancellationRequestResponse,
    // required this.submitterInfo,
    required this.reasonCancel,
  }) : super(const CommercialLicenseCancelState()) {
    on<SubmitFirstPage>(_submitFirstPage);

    on<SubmitCancelRequestPage>(_submitCancelRequestPage);

    on<SelectReasonCancel>(_selectReasonCancel);

    on<SelectAcknowledgePledge>(_selectAcknowledgePledge);

    on<SelectHijriCalendar>(_selectHijriCalendar);

    on<ShowCostInfo>(_showCostInfo);
  }

  Future<void> _submitFirstPage(SubmitFirstPage e, Emitter emitter) async {
    emitter(const CommercialLicenseCancelLoadingState());
    try {
      Map<String, dynamic> data = {
        "notes": reasonCancel!.text,
        "reasonId": reasonCancel!.id,
      };
      if (cancellationRequestResponse.availableCloseDate) {
        String year = hijriCalendar!.hYear.toString();
        String month = hijriCalendar!.hMonth.toString().padLeft(2, '0');
        String day = hijriCalendar!.hDay.toString().padLeft(2, '0');
        data['activityCancellationDate'] = "$year/$month/$day";
      }
      var response = await webService.dio.post(
          ApiUrl.commercialLicenseCancelSaveCancellationReason(
              cancellationRequestResponse.requestId),
          data: data);
      final result = ResponseBodyModel.fromMap(response.data).data?.result;
      saveCancellationReasonResponse =
          SaveCancellationReasonResponse.fromJson(result);
      emitter(const CommercialLicenseCancelSucceededState());
    } catch (e) {
      emitter(CommercialLicenseCancelFailureState(e.toString()));
      return;
    }
  }

  Future<void> _submitCancelRequestPage(
      SubmitCancelRequestPage e, Emitter emitter) async {
    emitter(const CommercialLicenseCancelLoadingState());
    try {
      var response = await webService.dio.post(
          ApiUrl.commercialLicenseCancelSubmit(
              cancellationRequestResponse.requestId),
          data: {
            // "sadadPeriod": 0,
          });
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      submitResponse = SubmitResponse.fromJson(result);
      submitResponse!.crNumber = crNumber;
      emitter(
          SubmitCancelRequestSucceededState(submitResponse: submitResponse!));
    } catch (e) {
      emitter(CommercialLicenseCancelFailureState(e.toString()));
    }
  }

  Future<void> _selectReasonCancel(
      SelectReasonCancel e, Emitter emitter) async {
    reasonCancel = e.reasonCancel;
    emitter(SelectedReasonCancel(reasonCancel: e.reasonCancel));
  }

  Future<void> _selectAcknowledgePledge(
      SelectAcknowledgePledge e, Emitter emitter) async {
    acknowledgePledge = e.acknowledgePledge;
    emitter(SelectedAcknowledgePledge(acknowledgePledge: acknowledgePledge));
  }

  Future<void> _selectHijriCalendar(
      SelectHijriCalendar e, Emitter emitter) async {
    hijriCalendar = e.hijriCalendar;
    controller.text = hijriCalendar.toString();
    emitter(SelectedHijriCalendar(hijriCalendar: hijriCalendar!));
  }

  Future<void> _showCostInfo(ShowCostInfo e, Emitter emitter) async {
    showCostInfo = e.showCostInfo;
    emitter(ShowedCostInfo(showCostInfo: showCostInfo));
  }

// Future<void> getCommercialLicenseCancelRequestDetails(int id) async {
//   try {
//     var response = await webService.dio.get(
//         ApiUrl.commercialLicenseCancelGetDetailsRequest(
//             cancellationRequestResponse.requestId));
//     final data = response.data;
//     final result = ResponseBodyModel.fromMap(data).data?.result;
//     // actions = result
//     //     .map<AllowedActions>(
//     //         (e) => AllowedActions.fromJson(e as Map<String, dynamic>)
//     // ).toList();
//     // actions = actions.where((element) => element.id == 1008).toList();
//   } catch (e) {
//     print(e);
//   }
// }
}
