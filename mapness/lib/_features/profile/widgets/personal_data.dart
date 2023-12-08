import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_user_info_model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PersonalData extends StatelessWidget {
  final SsoUserInfoModel userInfo;

  const PersonalData({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PersonalDataRow(
          title: userInfo.givenName ?? "",
          subtitle: context.l10n.firstName,
        ),
        PersonalDataRow(
          title: userInfo.familyName ?? "",
          subtitle: context.l10n.lastName,
        ),
        PersonalDataRow(
          title: userInfo.mail ?? "",
          subtitle: context.l10n.email,
        ),
        PersonalDataRow(
          title: userInfo.getFormattedBirthDate(),
          subtitle: context.l10n.dateOfBirth,
        ),
        PersonalDataRow(
          title: userInfo.arName ?? "",
          subtitle: context.l10n.arabicFullName,
          isArabic: true,
        ),
        PersonalDataRow(
          title: userInfo.getFirstAndLastName(),
          subtitle: context.l10n.englishFullName,
        ),
        PersonalDataRow(
          title: userInfo.nationality ?? "",
          subtitle: context.l10n.nationality,
        ),
      ],
    );
  }
}

class PersonalDataRow extends StatelessWidget {
  const PersonalDataRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.isArabic = false,
  });

  final String title;
  final String subtitle;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 12, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: isArabic
                ? Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(color: const Color(0xFF1E2A36))
                : Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(color: const Color(0xFF1E2A36)),
          ),
          Text(
            subtitle,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textXS
                .copyWith(color: const Color(0xB21E2A36)),
          ),
        ],
      ),
    );
  }
}
