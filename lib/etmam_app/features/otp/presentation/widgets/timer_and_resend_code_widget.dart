import 'dart:async';

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomTextButtonWidget, CustomTextWidget;
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerAndResendCode extends StatefulWidget {
  const TimerAndResendCode({Key? key}) : super(key: key);

  @override
  State<TimerAndResendCode> createState() => _TimerAndResendCodeState();
}

class _TimerAndResendCodeState extends State<TimerAndResendCode> {
  Timer? _timer;

  int _start = 60;
  bool timerFinished = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpBloc, OtpState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (timerFinished)
              CustomTextButtonWidget(
                  btnTextColor: AppColor.darkTurquoise,
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.medium,
                  btnPressed: () {
                    startTimer();
                    context.read<OtpBloc>().add(SendOTPEvent(
                        params: SendOTPParamas(
                            expireSeconds: "60",
                            serviceId:
                                context.read<OtpBloc>().serviceId ?? "")));
                  },
                  btnText: trans('lbl_resend_verify_code')),
            if (!timerFinished) ...[
              SizedBox(
                  width: 10.0,
                  height: 10,
                  child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      value: (60 - _start) / 60,
                      color: AppColor.baladyDarkGreen2,
                      backgroundColor: AppColor.black300)),
              const CustomHorizontalSpace(width: 16),
              CustomTextWidget(
                "$_start : 00",
                fontColor: AppColor.greyText,
                fontSize: 14,
                fontWeight: AppFontWeight.regular,
              )
            ]
          ],
        );
      },
    );
  }

  void startTimer() {
    timerFinished = false;
    _start = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timerFinished = true;
            timer.cancel();
          } else {
            setState(() {
              _start = _start - 1;
            });
          }
        },
      ),
    );
  }
}
