import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/profile_image_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthorizedWidget extends ConsumerWidget {
  const AuthorizedWidget({required this.userData, super.key});

  final SsoUserInfo userData;

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$4x, bottom: Spacing.$4x + Spacing.$0_5x),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
              child: Text(
                userData.getFirstAndLastName(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.heading1.copyWith(color: context.color.textAndIconsBasePrimary),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showBottomSheet(context, ref),
            child: Stack(
              children: [
                const ProfileImageWidget(
                  dimension: Spacing.$10x + Spacing.$10x,
                ),
                PositionedDirectional(
                    start: Spacing.none,
                    bottom: Spacing.none,
                    child: Container(
                      width: Spacing.$8x,
                      height: Spacing.$8x,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Container(
                          width: Spacing.$6x,
                          height: Spacing.$6x,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff000000).withOpacity(.08),
                                blurRadius: 4,
                                offset: const Offset(Spacing.none, Spacing.px),
                              ),
                              BoxShadow(
                                color: const Color(0xff000000).withOpacity(.04),
                                spreadRadius: .5,
                                offset: const Offset(Spacing.none, Spacing.px),
                              ),
                            ],
                            color: context.color.surfaceBasePrimary,
                          ),
                          child:
                              Icon(SystemIcons.edit, size: Spacing.$4x, color: context.color.textAndIconsBaseTertiary),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBottomSheet(BuildContext context, WidgetRef ref) async {
    // Result of the bottom sheet is "Should we open sheet with text 'Open settings to give permission'?"
    final res = await context.router.push<bool>(const ChangeProfilePhotoRoute());

    if (res == true) {
      await Future.delayed(Durations.medium2);
      await _showDialog(context);
    }
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
