import 'package:flutter/material.dart' show Color, IconData, Icons;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../utils_exports.dart' show AppColor;

enum PopUpMessageType {
  //? First solution,
  // but when you access message, you need to translate it
  success(
    message: "popUpSuccessMessageTitleWord",
    icon: Icons.check_circle_outline_rounded,
    color: AppColor.success,
  ),
  confirm(
    message: "popUpConfirmMessageTitleWord",
    icon: Icons.check_circle_outline_rounded,
    color: AppColor.success,
  ),
  warning(
    message: "popUpWarningMessageTitleWord",
    icon: Icons.warning,
    color: AppColor.warning,
  ),
  error(
    message: "popUpErrorMessageTitleWord",
    icon: Icons.error_outline_rounded,
    color: AppColor.error,
  ),
  none(message: "popUpNoTitleWord");

  const PopUpMessageType({
    required this.message,
    this.icon,
    this.color,
  });
  final String message;
  final IconData? icon;
  final Color? color;

  //? Second solution
  String get toSuccessMessage => "popUpSuccessMessageTitleWord".tr();
  String get toConfirmMessage => "popUpConfirmMessageTitleWord".tr();
  String get toWarningMessage => "popUpWarningMessageTitleWord".tr();
  String get toErrorMessage => "popUpErrorMessageTitleWord".tr();
  String get toNoneMessage => "popUpNoTitleWord".tr();

  //? Third solution
  String get toMessage {
    switch (this) {
      case PopUpMessageType.success:
        return "popUpSuccessMessageTitleWord".tr();
      case PopUpMessageType.confirm:
        return "popUpConfirmMessageTitleWord".tr();
      case PopUpMessageType.warning:
        return "popUpWarningMessageTitleWord".tr();
      case PopUpMessageType.error:
        return "popUpErrorMessageTitleWord".tr();
      case PopUpMessageType.none:
        return "popUpNoTitleWord".tr();
    }
  }

  IconData? toIcon() {
    switch (this) {
      case PopUpMessageType.success:
        return Icons.check_circle_outline_rounded;
      case PopUpMessageType.confirm:
        return Icons.check_circle_outline_rounded;
      case PopUpMessageType.warning:
        return Icons.warning;
      case PopUpMessageType.error:
        return Icons.error_outline_rounded;
      case PopUpMessageType.none:
        return null;
    }
  }

  Color? toColor() {
    switch (this) {
      case PopUpMessageType.success:
        return AppColor.success;
      case PopUpMessageType.confirm:
        return AppColor.success;
      case PopUpMessageType.warning:
        return AppColor.warning;
      case PopUpMessageType.error:
        return AppColor.error;
      case PopUpMessageType.none:
        return null;
    }
  }
}
