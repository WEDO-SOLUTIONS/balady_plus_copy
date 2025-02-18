import 'dart:convert';

import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/profile/providers/profile_image_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';

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

    final Widget defaultImage = DefaultProfileImage(
      dimension: dimension,
      color: color,
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

class DefaultProfileImage extends ConsumerWidget {
  final double dimension;
  final Color? color;
  const DefaultProfileImage({
    required this.dimension,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dimension < 40) {
      return Icon(
        GeneralIcons.userCircle,
        size: dimension,
        color: color ?? context.colorsV3.foregroundSoft,
      );
    }
    final userData = ref.read(authProvider);
    final name = getFirstLetters(userData.valueOrNull);

    return Container(
      width: dimension,
      height: dimension,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            context.colorsV3.accentSecondarySoft,
            context.colorsV2.accentSecondaryActive,
          ],
        ),
      ),
      child: name != null
          ? Text(
              name,
              style: context.textStyleV3.h1SemiBold.copyWith(
                color: context.colorsV3.backgroundSurface1,
              ),
            )
          : SvgPicture.asset(
              'packages/mapness/assets/icons/svg/ic_profile.svg',
              height: 36,
              width: 36,
              colorFilter: ColorFilter.mode(
                context.colorsV3.backgroundSurface1,
                BlendMode.srcIn,
              ),
            ),
    );
  }

  String? getFirstLetters(SsoUserInfo? userInfo) {
    final names = userInfo?.getFirstAndLastName().split(' ');
    if (names == null) {
      return null;
    }
    if (names.isEmpty) {
      return null;
    }
    if (names.length == 1 && names.first.isNotEmpty) {
      return names.first.characters.first.toUpperCase();
    }
    final firstLetter = names.first.isNotEmpty ? names.first[0].toUpperCase() : '';
    final secondLetter = names.last.isNotEmpty ? names.last[0].toUpperCase() : '';
    return '$firstLetter$secondLetter';
  }
}
