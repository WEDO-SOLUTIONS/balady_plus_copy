import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/app/auto_route/app_routes.dart';

/// [text] is the text to be copied to the clipboard.
/// [toastText] is the text to be shown in the toast.
/// [afterCopy] is a callback to be called after the text is copied to the clipboard.
///
/// If the [toastText] is null, the toast will not be shown.
Future<void> onCopyToClipboard(
  String text, {
  String? toastText,
  Future<void> Function()? afterCopy,
}) async {
  await Clipboard.setData(ClipboardData(text: text));

  await afterCopy?.call();

  if (toastText == null) {
    return;
  }
  final context = rootNavigatorKey.currentContext;
  if (context == null) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    ToastMessageFactory.toastWithIconAction(
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      icon: SystemIcons.close,
      text: toastText,
      context: context,
    ),
  );
}
