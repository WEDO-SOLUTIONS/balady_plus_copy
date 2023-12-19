import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PersonalData extends StatelessWidget {
  final SsoUserInfo userInfo;

  const PersonalData({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PersonalDataRow(
              title: userInfo.getFirstName(),
              subtitle: context.l10n.firstName,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color: const Color(0xFF1E2A36).withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.getLastName(),
              subtitle: context.l10n.lastName,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color: const Color(0xFF1E2A36).withOpacity(0.2),
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
                color: const Color(0xFF1E2A36).withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.getFormattedBirthDate(),
              subtitle: context.l10n.dateOfBirth,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color: const Color(0xFF1E2A36).withOpacity(0.2),
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
                color: const Color(0xFF1E2A36).withOpacity(0.2),
              ),
            ),
            PersonalDataRow(
              title: userInfo.getFirstAndLastName(),
              subtitle: context.l10n.englishFullName,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Divider(
                height: 1,
                color: const Color(0xFF1E2A36).withOpacity(0.2),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 12, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textM
                  .copyWith(color: const Color(0xFF1E2A36))),
          Text(
            subtitle,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textS
                .copyWith(color: const Color(0x5C1E2A36)),
          ),
        ],
      ),
    );
  }
}
