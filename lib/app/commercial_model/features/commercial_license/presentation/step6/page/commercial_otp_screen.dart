import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/dialog_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../bloc/cr_step6_establishment_data_cubit.dart';
import '../bloc/otp_bloc/otp_bloc.dart';

class CommercialOtpScreen extends StatefulWidget {
  CommercialOtpScreen({Key? key}) : super(key: key);

  @override
  _CommercialOtpScreen createState() => _CommercialOtpScreen();
}

class _CommercialOtpScreen extends State<CommercialOtpScreen> {
  @override
  void initState() {
    super.initState();
    //MM  Helpers.sendEventToAnalytics(AppEvents.VD_Open_OTP);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CommercialLicense_Check_QR_OTP_Page_Event);
  }

  @override
  Widget build(BuildContext context) {
    CRStep6EstablishmentCubit bloc =
        ModalRoute.of(context)?.settings.arguments as CRStep6EstablishmentCubit;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CommercialOtpBloc(mobileNumber: "", createBloc: bloc),
        ),
        BlocProvider.value(
          value: bloc,
        ),
      ],
      child: BlocConsumer<CommercialOtpBloc, CommercialOTPState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CustomVerticalSpace(
                      height: MediaQuery.of(context).padding.top),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DialogHeader(title: "lbl_verify_code".tr()),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            IconPath.otpLogo,
                            height: 100,
                            width: 91,
                          ),
                          const CustomVerticalSpace(height: 25),
                          CustomTextWidget(("lbl_verify_code").tr(),
                              fontColor: AppColor.black, fontSize: 22),
                          const CustomVerticalSpace(height: 15),
                          CustomTextWidget(
                            ("lbl_mobile_otp_hint").tr() +
                                " " +
                                (context
                                        .read<CommercialOtpBloc>()
                                        .createBloc
                                        .state
                                        .managerMobileNumber ??
                                    ""),
                            fontColor: AppColor.black500,
                            fontWeight: AppFontWeight.medium,
                            height: 2,
                            maxLines: 3,
                          ),
                          const CustomVerticalSpace(height: 20),
                          CustomTextWidget(
                            ("lbl_enter_verify_code").tr(),
                            fontColor: AppColor.baladyDarkGreen2,
                            fontSize: 13,
                          ),
                          OTPCode(),
                          const CustomVerticalSpace(height: 20),
                          CounterWidget()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void dispose() {
    super.dispose();
/*
    if (Platform.isAndroid && smsUserConsent != null) smsUserConsent?.dispose();

    if (_timer != null) {
      _timer?.cancel();
    }*/
  }
}

class OTPCode extends StatefulWidget {
  const OTPCode({super.key});

  @override
  State<OTPCode> createState() => _OTPCodeState();
}

class _OTPCodeState extends State<OTPCode> {
  var otpLength = 4;

  double otpPadding = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommercialOtpBloc, CommercialOTPState>(
      builder: (context, state) {
        return Stack(
          children: [
            Directionality(
              textDirection: (TextDirection.ltr),
              child: Container(
                padding: EdgeInsets.only(left: otpPadding, right: otpPadding),
                child: PinCodeTextField(
                  appContext: context,
                  length: otpLength,
                  autoFocus: true,
                  focusNode: context.read<CommercialOtpBloc>().otpFocusNode,
                  controller: context.read<CommercialOtpBloc>().otpCode,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                    //   FilteringTextInputFormatter.deny(RegExp(
                    //      '[\-|\ |\.|\, |\{ |\}  |\!  |\@   |\#   |\%   |\^  |\& |\[ |\] |\: |\; |\< |\> |\? |\( |\) |\+ |\- |\* |\~ ]'))
                  ],
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    inactiveColor: AppColor.warmGrey2,
                    activeColor: AppColor.baladyDarkGreen2,
                    inactiveFillColor: Colors.transparent,
                    activeFillColor: Colors.transparent,
                    selectedColor: AppColor.baladyDarkGreen2,
                    selectedFillColor: Colors.transparent,
                  ),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    //_code = v;
                    context
                        .read<CommercialOtpBloc>()
                        .createBloc
                        .verifyOTPHandler(v);
                    // validateOtp(v);
                  },
                  onChanged: (String value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            BlocBuilder<CRStep6EstablishmentCubit, CRStep6EstablishmentState>(
              builder: (context, state) {
                if (state.status == BlocStatus.loading)
                  return CustomCircularLoadingWidget();
                return Container();
              },
            )
          ],
        );
      },
    );
  }
}

class CounterWidget extends StatefulWidget {
  CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  Timer? timer;
  int start = 60;
  bool showCounter = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimerHandler();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return showCounter
        ? ResendCounter(
            start: start,
          )
        : ResendCodeWidget(
            onRetry: () {
              startTimerHandler();
            },
          );
  }

  void startTimerHandler() async {
    setState(() {
      showCounter = true;
      start = 60;
    });
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (start < 1) {
            timer.cancel();
            showCounter = false;
          } else {
            setState(() {
              start = start - 1;
            });
          }
        },
      ),
    );
  }
}

class ResendCounter extends StatelessWidget {
  int start;
  ResendCounter({super.key, required this.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 10.0,
            height: 10,
            child: CircularProgressIndicator(
                strokeWidth: 1.5,
                value: (60 - (start)) / 60,
                color: AppColor.baladyDarkGreen2,
                backgroundColor: AppColor.black300)),
        const CustomHorizontalSpace(width: 16),
        CustomTextWidget(
          start.toString() + " : 00",
          fontColor: AppColor.warmGrey,
          fontSize: 13,
          fontFamily: Constants.lucidaGrandFontType,
        ),
      ],
    );
  }
}

class ResendCodeWidget extends StatelessWidget {
  final Function onRetry;
  ResendCodeWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Platform.isAndroid &&
            context.read<CommercialOtpBloc>().smsUserConsent != null) {
          context.read<CommercialOtpBloc>().smsUserConsent?.requestSms();
        }

        context
            .read<CommercialOtpBloc>()
            .createBloc
            .sendOTPHandler(showOTPPage: false);

        onRetry();
        context.read<CommercialOtpBloc>().otpCode.clear();
        // startTimerHandler();
      },
      child: CustomTextWidget(
        ("lbl_resend_verify_code").tr(),
        fontColor: AppColor.primary900Light,
        fontWeight: AppFontWeight.medium,
      ),
    );
  }
}
