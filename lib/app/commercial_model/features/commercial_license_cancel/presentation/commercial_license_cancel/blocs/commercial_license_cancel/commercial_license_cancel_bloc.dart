import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/save_cancellation_reason_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/submit_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'commercial_license_cancel_event.dart';

part 'commercial_license_cancel_state.dart';

class CommercialLicenseCancelBloc
    extends Bloc<CommercialLicenseEvent, CommercialLicenseCancelState> {
  final WebService webService;

  final String crNumber, crType;
  final String from;
  final bool availableCloseDate;
  final int requestId;
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
    required this.crType,
    required this.requestId,
    required this.availableCloseDate,
    required this.reasonCancel,
    this.from = 'licenses',
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
    Response? response;
    try {
      Map<String, dynamic> data = {
        "notes": reasonCancel!.text,
        "reasonId": reasonCancel!.id,
      };
      if (availableCloseDate && hijriCalendar != null) {
        String year = hijriCalendar!.hYear.toString();
        String month = hijriCalendar!.hMonth.toString().padLeft(2, '0');
        String day = hijriCalendar!.hDay.toString().padLeft(2, '0');
        data['activityCancellationDate'] = "$year/$month/$day";
      }
      response = await webService.dio.post(
        CommercialModelEndPoints.commercialLicenseCancelSaveCancellationReason(requestId),
        data: data,
      );
      final result = ResponseBodyModel.fromMap(response.data).data?.result;
      saveCancellationReasonResponse =
          SaveCancellationReasonResponse.fromJson(result);
      emitter(const CommercialLicenseCancelSucceededState());
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      emitter(CommercialLicenseCancelFailureState(error.toString()));
      return;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      emitter(CommercialLicenseCancelFailureState(error.toString()));
      return;
    }
  }

  Future<void> _submitCancelRequestPage(
      SubmitCancelRequestPage e, Emitter emitter) async {
    emitter(const CommercialLicenseCancelLoadingState());
    Response? response;

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CancelCommercialLicense_Send_Request_Event);
    try {
      response = await webService.dio.post(
        CommercialModelEndPoints.commercialLicenseCancelSubmit(requestId),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      submitResponse = SubmitResponse.fromJson(result);
      submitResponse!.crNumber = crNumber;
      submitResponse!.crType = crType;
      emitter(
        SubmitCancelRequestSucceededState(
          submitResponse: submitResponse!,
          totalCost:
              saveCancellationReasonResponse!.calculatorResponse.totalCost,
        ),
      );

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.CancelCommercialLicense_Open_Success_Page_Event);
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      emitter(CommercialLicenseCancelFailureState(error.toString()));
      return;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      emitter(CommercialLicenseCancelFailureState(error.toString()));
      return;
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
    controller.text = hijriCalendar?.toString() ?? '';
    emitter(SelectedHijriCalendar(hijriCalendar: hijriCalendar!));
  }

  Future<void> _showCostInfo(ShowCostInfo e, Emitter emitter) async {
    showCostInfo = e.showCostInfo;
    emitter(ShowedCostInfo(showCostInfo: showCostInfo));
  }
}
