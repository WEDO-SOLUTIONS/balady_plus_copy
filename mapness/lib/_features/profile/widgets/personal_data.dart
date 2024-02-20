import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class PersonalData extends ConsumerWidget {
  final SsoUserInfo userInfo;

  const PersonalData({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.read(appLanguageProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.color.surface_base_secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonalDataRow(
              title: userInfo.getLocalizedFirstName(language),
              subtitle: context.l10n.firstName,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color:
                    context.color.text_and_icons_base_primary.withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.getLocalizedLastName(language),
              subtitle: context.l10n.profileSettingsLastName,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color:
                    context.color.text_and_icons_base_primary.withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.mail ?? "",
              subtitle: context.l10n.email,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color:
                    context.color.text_and_icons_base_primary.withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.dob ?? "",
              subtitle: context.l10n.dateOfBirth,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color:
                    context.color.text_and_icons_base_primary.withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.arName ?? "",
              subtitle: context.l10n.arabicFullName,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color:
                    context.color.text_and_icons_base_primary.withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.enName ?? "",
              subtitle: context.l10n.englishFullName,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color:
                    context.color.text_and_icons_base_primary.withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.nationality ?? "",
              subtitle: context.l10n.nationality,
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalDataRow extends StatelessWidget {
  const PersonalDataRow({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 10, bottom: 12, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textM
                  .copyWith(color: context.color.text_and_icons_base_primary),
            ),
            Text(
              subtitle,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textS
                  .copyWith(
                    color: context.color.text_and_icons_base_tertiary,
                  ),
            ),
          ],
        ),
      );
}
