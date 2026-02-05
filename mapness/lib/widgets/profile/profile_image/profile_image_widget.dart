import 'dart:convert';

import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';

part 'default_profile_image.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    this.dimension = AvatarSize.$96,
    this.abbreviatedName,
    this.isSelected = true,
    this.style = AvatarEmptyStyle.accent,
    super.key,
  });

  final AvatarSize dimension;
  final String? abbreviatedName;
  final bool isSelected;
  final AvatarEmptyStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);
    final value = profileImage.value;
    if (value != null && value.imageBase64.isNotEmpty) {
      final imageBytes = base64Decode(value.imageBase64);
      return Avatar(key: ValueKey(profileImage.value!.imageBase64), size: dimension, data: AvatarBytes(imageBytes));
    }
    if (abbreviatedName != null && abbreviatedName!.isNotEmpty) {
      return Avatar(
        key: ValueKey(abbreviatedName!),
        size: dimension,
        data: AvatarDataEmpty(value: abbreviatedName, style: style),
      );
    }
    return Assets.icons.svg.icProfile2.svg(
      colorFilter: ColorFilter.mode(
        isSelected ? context.colors.accentSecondarySoft : context.colors.neutralSoft,
        BlendMode.srcIn,
      ),
    );
  }
}
