import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _showIOSDialog(BuildContext context, String title, String cancel, String settings) async {
  await showCupertinoDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CupertinoAlertDialog(
      content: Text(title),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(cancel),
        ),
        CupertinoDialogAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as deletion, and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
          child: Text(settings),
        ),
      ],
    ),
  );
}

Future<void> _showAndroidDialog(BuildContext context, String title, String cancel, String settings) async {
  final Widget cancelButton = TextButton(
    child: Text(cancel),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  final Widget continueButton = TextButton(
    onPressed: () {
      openAppSettings();
      Navigator.pop(context);
    },
    child: Text(settings),
  );

  // set up the AlertDialog
  final AlertDialog alert = AlertDialog(
    content: Text(title),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  await showDialog(
    context: context,
    builder: (context) => alert,
  );
}

/// Special dialog form for the case when the user denies the permission to access photos
/// but didn't switched it on later. We need to show the dialog with the explanation how to do it.
///
/// Duplication in [mapness/lib/widgets/profile/authorized_widget.dart]. Please remove it from there.
Future<void> showPermissionDeniedDialog(BuildContext context) async {
  final title = context.l10n.permissionPhotos;
  final cancel = context.l10n.cancel;
  final settings = context.l10n.settings;
  if (Platform.isIOS) {
    await _showIOSDialog(context, title, cancel, settings);
  } else {
    await _showAndroidDialog(context, title, cancel, settings);
  }
}
