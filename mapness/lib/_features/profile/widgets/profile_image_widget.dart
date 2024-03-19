import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/profile/providers/_index.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/shared/config/package_config.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    this.editable = false,
    this.color,
    this.dimension = 96,
    super.key,
  });

  final bool editable;
  final Color? color;
  final double dimension;

  Future<void> _onEdit(WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();

    final croppedBytes = await ref
        .read(goRouterProvider)
        .push(const ImageEditorRoute().location, extra: bytes);

    if (croppedBytes != null) {
      await ref
          .read(profileImageProvider.notifier)
          .changeUserProfileImageByBytes(croppedBytes as Uint8List);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);

    return GestureDetector(
      onTap: editable ? () => _onEdit(ref) : null,
      child: Builder(
        builder: (context) {
          final defaultImage = SvgPicture.asset(
            'assets/icons/svg/ic_nav_profile.svg',
            height: dimension,
            width: dimension,
            package: PackageConfig.packageName,
            colorFilter: ColorFilter.mode(
              color ?? NonThemeColor.color40,
              BlendMode.srcIn,
            ),
          );

          final imageWidget = profileImage.when(
            data: (data) {
              if (data.imageBase64.isEmpty) {
                return defaultImage;
              }

              return SizedBox.square(
                dimension: dimension,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: Image.memory(
                    base64Decode(data.imageBase64),
                    height: dimension,
                    width: dimension,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            error: (error, trace) => defaultImage,
            loading: () => defaultImage,
          );

          return Stack(
            children: [
              imageWidget,

              /// remove profile image edit button for a while
              // if (editable) ...[
              //   Positioned(
              //     right: 0,
              //     bottom: 0,
              //     child: FloatingActionButton(
              //       mini: true,
              //       backgroundColor: AppColor.white,
              //       onPressed: () => _onEdit(ref),
              //       elevation: 0,
              //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //       child: const Icon(
              //         Icons.edit,
              //         color: context.color.text_and_icons_status_accent,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          );
        },
      ),
    );
  }
}
