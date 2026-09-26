import 'dart:convert';

import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/widgets/profile/profile_image/founding_day_empty_avatar.dart';

part 'default_profile_image.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    this.dimension = AvatarSize.$96,
    this.abbreviatedName,
    this.isSelected = true,
    this.isEditing = false,
    this.style = AvatarEmptyStyle.accent,
    super.key,
  });

  final AvatarSize dimension;
  final String? abbreviatedName;
  final bool isSelected;
  final AvatarEmptyStyle style;
  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFoundingDay = ref.watch(activeCityEventProvider)?.isFoundingDay ?? false;

    if (isFoundingDay) {
      if (isEditing) {
        return FoundingDayAvatar(size: dimension.size);
      }

      return Assets.icons.svg.foundingDayProfile.svg(
        colorFilter: ColorFilter.mode(
          isSelected ? context.colors.accentDefault : context.colors.foregroundSoft,
          BlendMode.srcIn,
        ),
      );
    }

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
    // No photo, no abbreviated name to fall back to — DefaultProfileImage
    // was already written for exactly this case (a circular placeholder,
    // matching Avatar's own circular shape above) but was never wired up
    // here; the bare icProfile2 SVG it replaces had no circular
    // background/clip at all, unlike every other branch above.
    return DefaultProfileImage(
      dimension: dimension.size,
      color: isSelected ? context.colors.accentDefault : context.colors.neutralDefault,
    );
  }
}
