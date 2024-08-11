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

class EtmamOtpScreen extends StatefulWidget {
  const EtmamOtpScreen({Key? key}) : super(key: key);

  @override
  _EtmamOtpScreenState createState() => _EtmamOtpScreenState();
}

class _EtmamOtpScreenState extends State<EtmamOtpScreen> {
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
    OTPPageParams? args =
        ModalRoute.of(context)!.settings.arguments as OTPPageParams;

    return Directionality(
      textDirection: (TextDirection.rtl),
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0),
        body: BlocProvider(
          create: (context) => OtpBloc(
              sendOTP: sl(),
              verifyOTP: sl(),
              serviceId: args?.serviceId,
              sendOTPResponse: args?.otpResponse),
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
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const OtpHeaderWidget(),
                              OtpPinCodeWidget(
                                contrtoller: _otpCode,
                                onCompleteCode: (String code) {
                                  _code = code;
                                  setState(() {});
                                  context.read<OtpBloc>().add(VerifyOTPEvent(
                                      params: OTPVerifyParamas(
                                          otpId: state.sendOTPResponse?.otpId ??
                                              "",
                                          serviceId: args?.serviceId ?? "",
                                          token: _code)));
                                },
                              ),
                              const CustomVerticalSpace(height: 16),
                              const TimerAndResendCode(),
                              const CustomVerticalSpace(height: 16),
                            ],
                          ),
                        ),
                        /* OtpCheckButton(
                          code: _code,
                          onPressed: () {
                            context.read<OtpBloc>().add(VerifyOTPEvent(
                                params: OTPVerifyParamas(
                                    otpId: state.sendOTPResponse?.otpId ?? "",
                                    serviceId: widget.args?.serviceId ?? "",
                                    token: _code)));
                          },
                        ),*/
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
