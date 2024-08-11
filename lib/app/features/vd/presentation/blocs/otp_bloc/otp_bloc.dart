import 'dart:async';
import 'dart:io';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import 'package:balady_plus/app/features/vd/vd_exports.dart' show CreateVDBloc;
import 'package:balady_plus/app/core/errors/errors_exports.dart'
    show ServerFailure;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OTPBloc extends Bloc<OTPEvent, OTPState> {
  CreateVDBloc createBloc;
  SmsUserConsent? smsUserConsent;
  FocusNode otpFocusNode = new FocusNode();
  TextEditingController otpCode = TextEditingController();

  OTPBloc({required String mobileNumber, required this.createBloc})
      : super(OTPState(mobileNumber: mobileNumber)) {
    on<OTPEvent>((event, emit) {});

    on<StartSMSListnerEvent>(_startSMSListnerHandler);
    //on<StartTimerEvent>(_startTimerHandler);

    ///on<ShowTimerCounterEvent>(_showCounterHandler);
    add(StartSMSListnerEvent());
    add(StartTimerEvent());
  }

  Future<void> _startSMSListnerHandler(
      StartSMSListnerEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
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
    emitter(state.copyWith(status: BlocStatus.success));
  }
}
