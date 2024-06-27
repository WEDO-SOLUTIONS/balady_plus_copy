import 'dart:convert';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/profile/providers/profile_image_provider.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);

    final Widget defaultImage = Icon(
      GeneralIcons.userCircle,
      size: dimension,
      color: color ?? NonThemeColor.color40,
    );

    return profileImage.maybeWhen(
      data: (data) => data.imageBase64.isEmpty
          ? defaultImage
          : Picture.large(
              key: ValueKey(data.imageBase64),
              size: dimension,
              imgBytes: base64Decode(data.imageBase64),
            ),
      orElse: () => defaultImage,
    );
  }
}
