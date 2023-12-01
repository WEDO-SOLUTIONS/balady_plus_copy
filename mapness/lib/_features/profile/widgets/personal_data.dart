import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';


import 'package:mapness/shared/extensions/build_context_ext.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PersonalDataRow(
          title: "Ahmed",
          subtitle: context.l10n.firstName,
        ),
        PersonalDataRow(
          title: "El Usman",
          subtitle: context.l10n.lastName,
        ),
        PersonalDataRow(
          title: "Ahmed.Usman@gmail.com",
          subtitle: context.l10n.email,
        ),
        PersonalDataRow(
          title: "05.04.1978",
          subtitle: context.l10n.dateOfBirth,
        ),
        PersonalDataRow(
          title: "أحمد عبده أحمد أفه العثمان",
          subtitle: context.l10n.arabicFullName,
          isArabic: true,
        ),
        PersonalDataRow(
          title: "Ahmed Abdu Ahmed Avh El Usman",
          subtitle: context.l10n.englishFullName,
        ),
        PersonalDataRow(
          title: "Saudi Arabia",
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
                ? Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: const Color(0xFF1E2A36))
                : Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: const Color(0xFF1E2A36)),
          ),
          Text(
            subtitle,
            style: Theme.of(context).extension<ThemeTextStyles>()!.textXS.copyWith(color: const Color(0xB21E2A36)),
          ),
        ],
      ),
    );
  }
}
