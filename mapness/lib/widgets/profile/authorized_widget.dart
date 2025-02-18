import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/profile/widgets/profile_edited_photo.dart';

class AuthorizedWidget extends ConsumerWidget {
  const AuthorizedWidget({required this.userData, super.key});

  final SsoUserInfo userData;

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.$4x,
        left: Spacing.$8x,
        right: Spacing.$8x,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
              child: Text(
                userData.getFirstAndLastName(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.textStyleV3.h3Medium.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
              ),
            ),
          ),
          const ProfileEditablePhoto(),
        ],
      ),
    );
  }
}
