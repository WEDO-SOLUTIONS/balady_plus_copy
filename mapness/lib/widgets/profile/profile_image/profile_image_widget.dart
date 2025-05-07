import 'dart:convert';

import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/ui/picture/picture.dart' as picture;
part 'default_profile_image.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    this.color,
    this.dimension = 96,
    super.key,
  });

  final Color? color;
  final double dimension;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);
    final value = profileImage.valueOrNull;
    if (value != null && value.imageBase64.isNotEmpty) {
      final imageBytes = base64Decode(value.imageBase64);
      return picture.Picture.large(
        key: ValueKey(profileImage.valueOrNull!.imageBase64),
        size: dimension,
        imgBytes: imageBytes,
      );
    }
    return DefaultProfileImage(dimension: dimension, color: color);
  }
}
