import 'package:flutter/material.dart' show Color, IconData, Icons;

import '../utils_exports.dart' show AppColor;

enum MessageType {
  //? First solution,
  // but when you access message, you need to translate it
  success(
    message: "popUpSuccessMessageTitle",
    icon: Icons.check_circle_outline_rounded,
    color: AppColor.success,
  ),
  confirm(
    message: "popUpConfirmMessageTitle",
    icon: Icons.check_circle_outline_rounded,
    color: AppColor.success,
  ),
  warning(
    message: "popUpWarningMessageTitle",
    icon: Icons.warning,
    color: AppColor.warning,
  ),
  error(
    message: "popUpErrorMessageTitle",
    icon: Icons.error_outline_rounded,
    color: AppColor.error,
  ),
  none(message: "popUpNoTitle"),
  ;

  const MessageType({required this.message, this.icon, this.color});
  final String message;
  final IconData? icon;
  final Color? color;
}
