import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/profile_image/profile_image_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileEditablePhoto extends StatelessWidget {
  const ProfileEditablePhoto({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _showBottomSheet(context),
        child: Stack(
          children: [
            const ProfileImageWidget(dimension: 2 * AppSizes.m),
            PositionedDirectional(
              start: Spacing.none,
              bottom: Spacing.none,
              child: Container(
                padding: const EdgeInsets.all(Spacing.$1x),
                width: AppSizes.xxs,
                height: AppSizes.xxs,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // TODO: Change to background screen
                  color: context.colorsV3.staticWhite,
                ),
                child: Center(
                  child: General16Icons.edit.icon(
                    color: context.colorsV3.foregroundMuted,
                    size: AppSizes.$4xs,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _showBottomSheet(BuildContext context) async {
    // Result of the bottom sheet is "Should we open sheet with text 'Open settings to give permission'?"
    final res = await context.router.push<bool>(const ChangeProfilePhotoRoute());

    if (res == true) {
      await Future.delayed(Durations.medium2);
      if (!context.mounted) {
        return;
      }
      await _showDialog(context);
    }
  }

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

  Future<void> _showDialog(BuildContext context) async {
    final title = context.l10n.permissionPhotos;
    final cancel = context.l10n.cancel;
    final settings = context.l10n.settings;
    if (Platform.isIOS) {
      await _showIOSDialog(context, title, cancel, settings);
    } else {
      await _showAndroidDialog(context, title, cancel, settings);
    }
  }
}
