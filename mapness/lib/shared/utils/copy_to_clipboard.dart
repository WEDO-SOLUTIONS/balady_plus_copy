import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/services.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

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
  ToastOverlay.of(context).show(
    title: toastText,
    icon: const ToastIconData(SystemIcons.close),
  );
}
