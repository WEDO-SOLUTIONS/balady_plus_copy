import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/native_overlay_controller.dart';

/// in this dialog functions we show native overlay controller above the web view, that rendered natively
/// only in iOS, to prevent the web view from being interactive
/// so at the end the order of layers in iOS UI will be:
/// [ Native WebView -> Native Overlay -> Native CupertinoAlertDialog]
/// in Android, the dialog will be shown above the web view without any overlay [WebView -> AlertDialog]
/// use using [showAlertDialog] function to show the dialog
class ShowDialogOnWebView {
  const ShowDialogOnWebView();

  static Future<T?> showAlertDialog<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    List<Widget>? Function(BuildContext context)? actions,
  }) async {
    bool isIOS = Platform.isIOS;

    if (isIOS) await NativeOverlayController.showOverlay();

    if (!context.mounted) {
      if (isIOS) await NativeOverlayController.hideOverlay();
      return null;
    }

    final res = await showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => isIOS
          ? CupertinoAlertDialog(title: title, content: content, actions: actions?.call(ctx) ?? [])
          : AlertDialog(title: title, content: content, actions: actions?.call(ctx) ?? []),
    );

    if (isIOS) await NativeOverlayController.hideOverlay();

    return res;
  }
}
