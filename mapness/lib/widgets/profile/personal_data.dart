import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/profile/user_profile_data.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class PersonalData extends ConsumerWidget {
  final SsoUserInfo userInfo;

  const PersonalData({
    required this.userInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.read(appLanguageProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.surfaceBaseSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentWrapper(color: context.color.surfaceBaseSecondary, children: [
            ContentRow(
              options: ContentRowOptions(
                dividerEnabled: true,
                title: userInfo.getLocalizedFirstName(language),
                subtitle: context.l10n.firstName,
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                dividerEnabled: true,
                title: userInfo.getLocalizedLastName(language),
                subtitle: context.l10n.profileSettingsLastName,
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                dividerEnabled: true,
                title: userInfo.mail ?? '',
                subtitle: context.l10n.email,
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                dividerEnabled: true,
                title: userInfo.dob ?? '',
                subtitle: context.l10n.dateOfBirth,
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                dividerEnabled: true,
                title: userInfo.arName ?? '',
                subtitle: context.l10n.arabicFullName,
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                dividerEnabled: true,
                title: userInfo.enName ?? '',
                subtitle: context.l10n.englishFullName,
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                title: userInfo.nationality ?? '',
                subtitle: context.l10n.nationality,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
