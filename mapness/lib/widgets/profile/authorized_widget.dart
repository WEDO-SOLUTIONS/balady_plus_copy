import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/profile/providers/profile_image_provider.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/config/package_config.dart';
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
      padding: const EdgeInsets.only(top: 16, bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16.0),
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
                  dimension: 80,
                ),
                PositionedDirectional(
                    start: 0,
                    bottom: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff000000).withOpacity(.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                              BoxShadow(
                                color: const Color(0xff000000).withOpacity(.04),
                                spreadRadius: .5,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: context.color.surfaceBasePrimary,
                          ),
                          child: Icon(SystemIcons.edit, size: 16, color: context.color.textAndIconsBaseTertiary),
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

  Future<void> _updateAvatar(WidgetRef ref) async {
    final picker = ImagePicker();
    XFile? image;
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      log(e.toString());
    }

    if (image == null) {
      return;
    }
    final bytes = await image.readAsBytes();
    final Uint8List? croppedBytes = await ref.read(appRouterProvider).push(ImageEditorRoute(image: bytes));
    if (croppedBytes != null) {
      await ref.read(profileImageProvider.notifier).changeUserProfileImageByBytes(croppedBytes);
    }
  }

  Future<void> _showBottomSheet(BuildContext context, WidgetRef ref) async {
    final isPermanentlyDenied = ref.read(profileImageProvider.notifier).status == PermissionStatus.permanentlyDenied;

    // Result of the bottom sheet is "Should we open sheet with text 'Open settings to give permission'?"
    final res = await showModalBottomSheet<bool>(
      backgroundColor: context.color.surfaceBaseSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          const SheetDragger(),
          const SizedBox(height: 6),
          ContentRow(
            options: ContentRowOptions(
              title: context.l10n.profilePhoto,
              titleStyle: context.textStyle.heading2.copyWith(color: context.color.textAndIconsBasePrimary),
              customActionWidget: AppButton.close(
                color: context.color.surfaceContrastLow,
                onTap: context.pop,
                innerPadding: const EdgeInsets.all(Spacing.$2x),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ContentWrapper(color: context.color.surfaceBasePrimary, children: [
              ContentRow(
                onTap: () {
                  if (isPermanentlyDenied) {
                    // If status is [isPermanentlyDenied] we have to return "Yes, I want to open new sheet and ask about
                    // permissions"
                    context.pop(true);
                  } else {
                    context.pop();
                    _updateAvatar(ref);
                  }
                },
                options: ContentRowOptions(
                  leadingIcon: SvgPicture.asset(
                    'assets/icons/svg/photo_gallery.svg',
                    colorFilter: ColorFilter.mode(context.color.textAndIconsStatusAccent, BlendMode.srcIn),
                    package: PackageConfig.packageName,
                  ),
                  title: context.l10n.change_avatar,
                  titleStyle: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
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
