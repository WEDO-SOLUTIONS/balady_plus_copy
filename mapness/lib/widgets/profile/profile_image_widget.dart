import 'dart:convert';
import 'dart:typed_data';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/profile/providers/profile_image_provider.dart';
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

    final Uint8List? croppedBytes =
        await ref.read(goRouterProvider).push(const ImageEditorRoute().location, extra: bytes);

    if (croppedBytes != null) {
      await ref.read(profileImageProvider.notifier).changeUserProfileImageByBytes(croppedBytes);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);

    return Builder(builder: (context) {
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
      final Widget imageWidget = profileImage.when(
        data: (data) {
          if (data.imageBase64.isEmpty) {
            return defaultImage;
          }
          return Picture.large(
            size: dimension,
            imgBytes: base64Decode(data.imageBase64),
          );
        },
        error: (error, trace) => defaultImage,
        loading: () => defaultImage,
      );
      return imageWidget;
    });
  }
}
