import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart' show BotToast;

import '../../../../core/utils/utils_exports.dart' show MessageType;
import '../../shared_feature_exports.dart' show CustomAlertDialogWidget, ToastNotification;

class MessageDialog {
  //! --------- BotToast -----------
  static void showSuccessNotification({required String msg}) =>
      BotToast.showCustomNotification(toastBuilder: (_) => ToastNotification.success(msg));
  static void showErrorNotification({required String msg}) =>
      BotToast.showCustomNotification(toastBuilder: (_) => ToastNotification.error(msg));

  static Future<bool> showSuccess(BuildContext context, String msg) async => await _showDialog(
    context,
    child: CustomAlertDialogWidget(titleMessageType: MessageType.success, contentText: msg),
  );

  static Future<bool> showWarning(BuildContext context, String warningText) async => await _showDialog(
    context,
    child: CustomAlertDialogWidget(titleMessageType: MessageType.warning, contentText: warningText),
  );

  static Future<bool> showError(BuildContext context, String errorText) async => await _showDialog(
    context,
    child: CustomAlertDialogWidget(titleMessageType: MessageType.error, contentText: errorText),
  );

  static Future<bool> _showDialog(BuildContext context, {required Widget child}) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(opacity: a1.value, child: child),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        // barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;
}
