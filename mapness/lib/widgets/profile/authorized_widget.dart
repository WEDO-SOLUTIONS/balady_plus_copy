import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/widgets/profile/profile_edited_photo.dart';

class AuthorizedWidget extends ConsumerWidget {
  const AuthorizedWidget({required this.userData, super.key});

  final SsoUserInfo userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var name = userData.getFirstAndLastName().trim();
    if (name.isEmpty) {
      name = userData.getPhone().trim();
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.$4x,
        left: Spacing.$4x,
        right: Spacing.$4x,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
              child: Text(
                name,
                maxLines: 3,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.h3Medium.copyWith(
                  color: context.colors.foregroundDefault,
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
