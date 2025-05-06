import 'dart:convert';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
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

    return profileImage.maybeWhen(
      data: (data) => data.imageBase64.isEmpty
          ? _DefaultImage(text: imageText)
          : Picture.large(
              key: ValueKey(data.imageBase64),
              imgBytes: base64Decode(data.imageBase64),
            ),
      orElse: () => const _DefaultImage(text: ''),
    );
  }
}

class _DefaultImage extends StatelessWidget {
  final String text;
  const _DefaultImage({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        height: 48,
        width: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(157, 201, 108, 1),
              Color.fromRGBO(111, 160, 59, 1),
            ],
          ),
        ),
        child: Text(
          text,
          style: context.textStyleV3.h4SemiBold.copyWith(
            color: context.colorsV2.staticWhite,
            height: 1,
          ),
        ),
      );
}
