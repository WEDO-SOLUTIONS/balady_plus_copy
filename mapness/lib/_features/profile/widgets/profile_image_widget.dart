import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

import '../providers/_index.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    this.editable = false,
    this.dimension = 96,
    super.key,
  });

  final bool editable;
  final double dimension;

  Future<void> _onEdit(WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    ref.read(profileImageProvider.notifier).changeUserProfileImageByBytes(bytes);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);

    return GestureDetector(
      onTap: editable ? () => _onEdit(ref) : null,
      child: Builder(builder: (context) {
        final defaultImage = SvgPicture.asset(
          'assets/icons/svg/ic_nav_profile.svg',
          height: dimension,
          width: dimension,
          package: PackageConfig.packageName,
          colorFilter: const ColorFilter.mode(
            Color(0xff898e96),
            BlendMode.srcIn,
          ),
        );

        final Widget imageWidget = profileImage.when(
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
                  alignment: Alignment.center,
                ),
              ),
            );
          },
          error: (error, trace) {
            return defaultImage;
          },
          loading: () {
            return defaultImage;
          },
        );

        return imageWidget;
      }),
    );
  }
}
