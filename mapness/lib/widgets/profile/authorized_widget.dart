import 'dart:typed_data';

import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/profile/providers/profile_image_provider.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/profile_image_widget.dart';

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
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final bytes = await image.readAsBytes();
    final Uint8List? croppedBytes = await ref.read(goRouterProvider).push(
          const ImageEditorRoute().location,
          extra: bytes,
        );
    if (croppedBytes != null) {
      await ref.read(profileImageProvider.notifier).changeUserProfileImageByBytes(croppedBytes);
    }
  }

  Future<void> _showBottomSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
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
                      innerPadding: const EdgeInsets.all(Spacing.verticalGapBetweenStories),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ContentWrapper(color: context.color.surfaceBasePrimary, children: [
                    ContentRow(
                      onTap: () {
                        context.pop();
                        _updateAvatar(ref);
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
            ));
  }
}
