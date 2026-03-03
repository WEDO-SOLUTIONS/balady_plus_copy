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
// import 'package:mapness/shared/ui/picture/picture.dart' as picture; // File deleted
import 'package:mapness/widgets/profile/profile_image/founding_day_empty_avatar.dart';
part 'default_profile_image.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
this.color,
    this.dimension = 96,
    this.isSelected = false,
    this.isEditing = false,
    super.key,
  });

  final Color? color;
  final double dimension;
  final bool isEditing;
  final bool isSelected;

  AvatarSize _getAvatarSize(double dim) {
    if (dim <= 16) return AvatarSize.$16;
    if (dim <= 24) return AvatarSize.$24;
    if (dim <= 32) return AvatarSize.$32;
    if (dim <= 48) return AvatarSize.$48;
    if (dim <= 64) return AvatarSize.$64;
    if (dim <= 80) return AvatarSize.$80;
    return AvatarSize.$96;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFoundingDay = ref.watch(activeCityEventProvider)?.isFoundingDay ?? false;
    final userData = ref.watch(authProvider).value;
    final abbreviatedName = userData?.getAbbreviatedName();

    if (isFoundingDay) {
      if (isEditing) {
        return FoundingDayAvatar(size: dimension, abbreviatedName: abbreviatedName);
      }

      return Assets.icons.svg.foundingDayProfile.svg(
        colorFilter: ColorFilter.mode(
          color ?? context.colors.foregroundDefault,
          BlendMode.srcIn,
        ),
      );
    }

    final profileImage = ref.watch(profileImageProvider);
    final value = profileImage.value;
    if (value != null && value.imageBase64.isNotEmpty) {
      final imageBytes = base64Decode(value.imageBase64);
      return Avatar(key: ValueKey(profileImage.value!.imageBase64), size: _getAvatarSize(dimension), data: AvatarBytes(imageBytes));
    }
    if (abbreviatedName != null && abbreviatedName.isNotEmpty) {
      return Avatar(
        key: ValueKey(abbreviatedName),
        size: _getAvatarSize(dimension),
        data: AvatarDataEmpty(value: abbreviatedName),
      );
    }
    return Assets.icons.svg.icProfile2.svg(
      colorFilter: ColorFilter.mode(
        isSelected ? context.colors.accentDefault : context.colors.neutralDefault,
        BlendMode.srcIn,
      ),
    );
  }
}
