import 'dart:io';

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../ekram/domain/use_cases/get_nationalities.dart';
import '../../../../ekram/domain/use_cases/get_nationality_types.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/find_grave_request.dart';
import '../../../domain/entities/send_otp_params.dart';
import '../../../domain/entities/verify_otp_params.dart';
import '../../../domain/use_cases/get_ekram_cities.dart';
import '../../../domain/use_cases/get_ekram_districts.dart';
import '../../../domain/use_cases/get_ekram_identity_types.dart';
import '../../../domain/use_cases/send_otp_for_print.dart';
import '../../../domain/use_cases/verify_otp_for_print.dart';
import '../../pages/inquiry_print/print_otp_screen.dart';
import 'ekram_inquiry_print_event.dart';
import 'ekram_inquiry_print_state.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class EkramInquiryPrintBloc
    extends Bloc<EkramInquiryPrintEvent, EkramInquiryPrintState> {
  final GetEkramIdentityTypes _getEkramIdentityTypes;
  final SendOTPForPrint _sendOTPForPrint;
  final VerifyOTPForPrint _verifyOTPForPrint;

  SmsUserConsent? smsUserConsent;
  TextEditingController otpCode = TextEditingController();
  EkramInquiryPrintBloc()
      : _sendOTPForPrint = SendOTPForPrint(repository: sl()),
        _verifyOTPForPrint = VerifyOTPForPrint(repository: sl()),
        _getEkramIdentityTypes = GetEkramIdentityTypes(repository: sl()),
        super(EkramInquiryPrintState()) {
    on<UpdatePrintFieldsEvent>(_updateFieldsEvent);

    getEkramNationalIdTypesEventHandler();

    on<PrintSendOTPEvent>(_printSendOTPEvent);
    on<VerifySendOTPEvent>(_printVerifyOTPEvent);
  }

  static String Print_Burial_Certificate_Page_Event =
      "Print_Burial_Certificate_Page_Event";
  static String Print_Burial_Certificate_Send_OTP_Event =
      "Print_Burial_Certificate_Send_OTP_Event";
  static String Print_Burial_Certificate_Verify_OTP_Event =
      "Print_Burial_Certificate_Verify_OTP_Event";
  static String Print_Burial_Certificate_Print_OTP_Event =
      "Print_Burial_Certificate_Print_OTP_Event";

  Future<void> _printVerifyOTPEvent(
      VerifySendOTPEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failureOrSuccess = await _verifyOTPForPrint(VerifyOTPParams(
        guid: state.sendOtpResponse?.certificateCode ?? "", otp: e.otp ?? ""));

    failureOrSuccess.fold((l) {
      print("LLL $l");
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMsg: (l as ServerFailure).errorMessage));
    }, (r) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Print_Burial_Certificate_Verify_OTP_Event);
      emitter(state.copyWith(status: BlocStatus.success, errorMsg: ""));
      NavigationService.navigatorKey.currentState?.pop(true);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Print_Burial_Certificate_Print_Event);

      CommonFunctions.showApigeeFile(
          "${RemoteConfig.apigeeURL}/v2/ekram-mobile-services/reports/licenses/${r.certificateCode}",
          DateTime.now().millisecond.toString());

      CommonFunctions.sendUXCamEvent(UXCamEvents.finishPrintBurialCertificate);

      /*CommonFunctions.showApigeeFile(
          "https://apiservicesstg.balady.gov.sa/v2/ekram-mobile-services/reports/licenses/E09055EB-228C-466E-97B9-57A3EAA66D8E",
          DateTime.now().millisecond.toString());*/
    });
  }

  Future<void> _printSendOTPEvent(PrintSendOTPEvent e, Emitter emitter) async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Print_Burial_Certificate_Request_OTP_Event);
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failureOrSuccess = await _sendOTPForPrint(SendOTPParams(
        bodyRecipientIdNo: state.nationalIdForReceiver ?? "",
        bodyRecipientIdType: state.selectedNationalIdTypeForReceiver?.id ?? 0,
        deceasedIdentityId: state.nationalIdForDecassed ?? "",
        deceasedIdentityType:
            state.selectedNationalIdTypeForDecassed?.id ?? 0));

    failureOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMsg: (l as ServerFailure).errorMessage));
    }, (r) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Print_Burial_Certificate_Send_OTP_Event);

      emitter(state.copyWith(
          status: BlocStatus.success, errorMsg: "", sendOtpResponse: r));

      if (!e.resend) {
        otpCode = TextEditingController();
        NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (ctx) => EkrimPrintOtpScreen(
                  bloc: this,
                )));
      }
    });
  }

  Future<void> _updateFieldsEvent(
      UpdatePrintFieldsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      nationalIdForDecassed: e.nationalIdForDecassed,
      nationalIdForReceiver: e.nationalIdForReceiver,
      selectedNationalIdTypeForDecassed: e.selectedNationalIdTypeForDecassed,
      selectedNationalIdTypeForReceiver: e.selectedNationalIdTypeForReceiver,
      errorMsg: "",
    ));
  }

  Future<List<LookUpItem>?> getEkramNationalIdTypesEventHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramIdentityTypes(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMsg: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nationalIdTypes: success,
        errorMsg: "",
      ));
      return success;
    });
  }

  Future<void> startSMSListner() async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      if (Platform.isAndroid) {
        smsUserConsent = SmsUserConsent(smsListener: () {
          if (smsUserConsent?.receivedSms != null) {
            String otp = smsUserConsent!.receivedSms!
                .replaceAll(new RegExp(r'[^0-9]'), '');

            otpCode.text = otp;
          }
        });
        smsUserConsent?.requestSms();
      }
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    emit(state.copyWith(status: BlocStatus.success));
  }
}
