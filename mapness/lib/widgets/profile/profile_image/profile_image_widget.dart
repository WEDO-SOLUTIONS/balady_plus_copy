import 'dart:convert';

import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/ui/picture/picture.dart' as picture;
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
  final bool isSelected;
  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFoundingDay = ref.watch(activeCityEventProvider)?.isFoundingDay ?? false;

    if (isFoundingDay) {
      if (isSelected) {
        return Assets.icons.svg.foundingDayProfile.svg();
      }
      if (isEditing) {
        return FoundingDayAvatar(size: dimension);
      }
    }

    final profileImage = ref.watch(profileImageProvider);
    final value = profileImage.valueOrNull;
    if (value != null && value.imageBase64.isNotEmpty) {
      final imageBytes = base64Decode(value.imageBase64);
      // TODO: remove this after Adding Avatar widget to balady_uikit
      // ignore: deprecated_member_use_from_same_package
      return picture.Picture.large(
        key: ValueKey(profileImage.valueOrNull!.imageBase64),
        size: dimension,
        imgBytes: imageBytes,
      );
    }
    return DefaultProfileImage(dimension: dimension, color: color);
  }
}
