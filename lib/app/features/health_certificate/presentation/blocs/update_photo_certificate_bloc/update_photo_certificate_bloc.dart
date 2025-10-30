import 'dart:io';

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:formz/formz.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sms_user_consent/sms_user_consent.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../core/models/send_otp_sertificate.dart';
import '../../core/models/update_photo_response.dart';
import '../../core/services/repository/health_license_repository.dart';
import '../../pages/health_otp_screen.dart';
import '../new_health_certificate_bloc/new_health_certificate_bloc.dart';

part 'update_photo_certificate_state.dart';

class UpdatePhotoCertificateCubit extends Cubit<UpdatePhotoCertificateState> {
  final Function onUpdate;
  UpdatePhotoCertificateCubit(
      {required int requestId,
      required String certificateUUID,
      required this.onUpdate})
      : super(UpdatePhotoCertificateState(
            requestId: requestId, certificateUUID: certificateUUID)) {}
  SmsUserConsent? smsUserConsent;
  TextEditingController otpCode = TextEditingController();
  final _rpository = locator<HealthLicenseRepository>();

  Future<void> _goToNextPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    hideKeyboard();
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void updateDate(String date) {
    emit(state.copyWith(birthDate: date, errorMessage: ""));
  }

  void updateVersionNo(String versionNo) {
    emit(state.copyWith(versionNo: versionNo, errorMessage: ""));
  }

  void sendOTP({bool resend = false}) async {
    if (state.verifyOTPCertificate == true) {
      UpdatePhoto();
      return;
    }
    emit(state.copyWith(status: BlocStatus.loading));
    Tuple3<bool?, String?, SendOtpCertificateResult?> result =
        await _rpository.sendOTPCertificate(state.certificateUUID!);

    if (result.item1 == true) {
      emit(state.copyWith(
          status: BlocStatus.success, sendOtpCertificateResult: result.item3));
      if (!resend) {
        otpCode = TextEditingController();
        NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (ctx) => HealthOtpScreen(
                  bloc: this,
                )));
      }
    } else {
      emit(state.copyWith(
          status: BlocStatus.failure, errorMessage: result.item2));
    }
  }

  void verifyOTP(String otp) async {
    emit(state.copyWith(otpStatus: BlocStatus.loading));
    Tuple3<bool?, String?, bool?> result =
        await _rpository.verifyOTPCertificate(
            requestId: state.certificateUUID!,
            otp: otp,
            otpKey: state.sendOtpCertificateResult!.otpTokenKey!);

    if (result.item1 == true) {
      emit(state.copyWith(
          otpStatus: BlocStatus.success, verifyOTPCertificate: result.item3));

      NavigationService.navigatorKey.currentState?.pop(true);

      UpdatePhoto();
    } else {
      emit(state.copyWith(
          otpStatus: BlocStatus.failure, errorMessage: result.item2));
    }
  }

  void UpdatePhoto() async {
    emit(state.copyWith(status: BlocStatus.loading));
    Tuple3<bool?, String?, UpdatePhotoResponse?> result =
        await _rpository.updatePhoto(
            licenseNo: state.certificateUUID!,
            birthDate: toHijriFormattedDate(state.birthDate!),
            otpToken: state.sendOtpCertificateResult!.otpTokenKey!,
            versionNo: int.tryParse(state.versionNo!)!);

    if (result.item1 == true) {
      emit(state.copyWith(
          status: BlocStatus.success, updatePhotoResponse: result.item3));
      onUpdate();
      NavigationService.navigatorKey.currentState?.pop(true);
    } else {
      emit(state.copyWith(
          status: BlocStatus.failure, errorMessage: result.item2));
    }
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

  String toHijriFormattedDate(String date) {
    List<String> data = date.split("/");

    return "${data[0]}/${data[1].padLeft(2, "0")}/${data[2].padLeft(2, "0")}";
  }
}
