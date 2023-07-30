import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/utils_exports.dart';

class OtpPinCodeWidget extends StatefulWidget {
  final Function(String code)? onCompleteCode;
  final TextEditingController contrtoller;
  const OtpPinCodeWidget(
      {Key? key, required this.onCompleteCode, required this.contrtoller})
      : super(key: key);

  @override
  State<OtpPinCodeWidget> createState() => _OtpPinCodeWidgetState();
}

class _OtpPinCodeWidgetState extends State<OtpPinCodeWidget> {
  String _code = "";
  var otpLength = 4;
  final FocusNode _otpFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: (TextDirection.ltr),
      child: Center(
          child: PinCodeTextField(
        appContext: context,
        length: otpLength,
        autoFocus: true,
        focusNode: _otpFocusNode,
        controller: widget.contrtoller,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          _code = v;
          widget.onCompleteCode!(_code);
        },
        onChanged: (String value) {
          _code = value;
        },
      )),
    );
  }
}
