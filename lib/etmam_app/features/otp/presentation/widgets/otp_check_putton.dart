import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart' show trans;
import 'package:flutter/material.dart';

import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomPrimaryButton;

class OtpCheckButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String code;

  const OtpCheckButton({Key? key, required this.code, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPrimaryButton(
      onPressed: onPressed,
      btnText: trans('otp_send'),
      isBtnDisabled: code.length != 4,
    );
  }
}
