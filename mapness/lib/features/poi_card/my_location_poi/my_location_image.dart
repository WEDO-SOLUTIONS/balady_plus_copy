import 'dart:convert';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/profile/user_profile_data.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';

class MyLocationImageWidget extends ConsumerWidget {
  const MyLocationImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);
    final userData = ref.read(authProvider).requireValue;
    final language = ref.read(appLanguageProvider);
    final imageText = userData?.getLocalizedAbbreviatedName(language) ?? '';

    final data = profileImage.maybeWhen(
      data: (data) {
        if (data.imageBase64.isEmpty) {
          return AvatarDataEmpty(value: imageText);
        }
        return AvatarBytes(base64Decode(data.imageBase64));
      },
      orElse: () => const AvatarDataEmpty(value: ''),
    );
    return Avatar(
      key: ValueKey(profileImage.valueOrNull?.imageBase64 ?? ''),
      size: AvatarSize.$48,
      data: data,
    );
  }
}
