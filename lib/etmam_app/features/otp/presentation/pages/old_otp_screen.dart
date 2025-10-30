import 'dart:io';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class OtpScreen extends StatefulWidget {
  final OTPPageParams? args;

  const OtpScreen({Key? key, this.args}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var _code = "";
  SmsUserConsent? smsUserConsent;
  final TextEditingController _otpCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.OtpPage);
    startSmsListner();
  }

  @override
  void dispose() {
    super.dispose();
    if (Platform.isAndroid && smsUserConsent != null) smsUserConsent?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: (TextDirection.rtl),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: BlocProvider(
          create: (context) => OtpBloc(
              sendOTP: sl(),
              verifyOTP: sl(),
              serviceId: widget.args?.serviceId,
              sendOTPResponse: widget.args?.otpResponse),
          child: BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state.status == BlocStatus.failure) {
                CommonFunctions.showError(state.errorMessage ?? "");
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const OtpHeaderWidget(),
                                  OtpPinCodeWidget(
                                    contrtoller: _otpCode,
                                    onCompleteCode: (String code) {
                                      _code = code;
                                      setState(() {});
                                    },
                                  ),
                                  const CustomVerticalSpace(height: 16),
                                  const TimerAndResendCode(),
                                  const CustomVerticalSpace(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        OtpCheckButton(
                          code: _code,
                          onPressed: () {
                            context.read<OtpBloc>().add(VerifyOTPEvent(
                                params: OTPVerifyParamas(
                                    otpId: state.sendOTPResponse?.otpId ?? "",
                                    serviceId: widget.args?.serviceId ?? "",
                                    token: _code)));
                          },
                        ),
                      ],
                    ),
                  ),
                  if (state.status == BlocStatus.loading)
                    const CustomLoadingWidget()
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void startSmsListner() async {
    try {
      if (Platform.isAndroid) {
        smsUserConsent = SmsUserConsent(smsListener: () {
          setState(() {
            if (smsUserConsent?.receivedSms != null) {
              String otp = smsUserConsent!.receivedSms!
                  .replaceAll(RegExp(r'[^0-9]'), '');
              _otpCode.text = otp;
            }
          });
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
      print(error);
    }
  }
}
