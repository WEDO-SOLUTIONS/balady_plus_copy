import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class ChangeProfilePhotoPage extends ConsumerWidget {
  const ChangeProfilePhotoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPermanentlyDenied = ref.read(profileImageProvider.notifier).status == PermissionStatus.permanentlyDenied;

    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(RadiusBorder.xl),
        topRight: Radius.circular(RadiusBorder.xl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Spacing.$1_5x),
            child: SheetDragger(),
          ),
          ContentRow(
            options: ContentRowOptions(
              title: context.l10n.profilePhoto,
              titleStyle: context.textStyle.heading2.copyWith(color: context.color.textAndIconsBasePrimary),
              customActionWidget: AppButton.close(
                color: context.color.surfaceContrastLow,
                onTap: context.router.popForced,
                innerPadding: const EdgeInsets.all(Spacing.$2x),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: ContentWrapper(color: context.color.surfaceBasePrimary, children: [
              ContentRow(
                onTap: () async {
                  if (isPermanentlyDenied) {
                    // If status is [isPermanentlyDenied] we have to return "Yes, I want to open new sheet and ask about
                    // permissions"
                    context.router.popForced(true);
                  } else {
                    await updateAvatar(ref, context);
                    context.router.popForced();
                  }
                },
                options: ContentRowOptions(
                  leadingIcon: SvgPicture.asset(
                    Assets.icons.svg.photoGallery.keyName,
                    colorFilter: ColorFilter.mode(context.color.textAndIconsStatusAccent, BlendMode.srcIn),
                  ),
                  title: context.l10n.change_avatar,
                  titleStyle: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                ),
              ),
            ]),
          ),
          const SizedBox(height: Spacing.$8x),
        ],
      ),
    );
  }

  Future<void> updateAvatar(WidgetRef ref, BuildContext context) async {
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
    if (!context.mounted) {
      return;
    }
    final Uint8List? croppedBytes = await context.pushRoute(
      ImageEditorRoute(image: bytes),
    );
    if (croppedBytes != null) {
      unawaited(ref.read(profileImageProvider.notifier).changeUserProfileImageByBytes(croppedBytes));
    }
  }
}
