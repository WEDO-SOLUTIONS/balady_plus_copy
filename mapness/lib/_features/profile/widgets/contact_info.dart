import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ContactRow(
            contact: 'Balady_CS@',
            subtitle: context.l10n.twitterAccount,
            border: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              color: context.color.surface_base_secondary,
              child: Padding(
                padding: const EdgeInsets.only(right: 52),
                child: Divider(
                  height: 1,
                  color: context.color.text_and_icons_base_primary
                      .withOpacity(0.2),
                ),
              ),
            ),
          ),
          ContactRow(
            contact: '199040',
            subtitle: context.l10n.profileContactInformation,
            border: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              color: context.color.surface_base_secondary,
              child: Padding(
                padding: const EdgeInsets.only(right: 52),
                child: Divider(
                  height: 1,
                  color: context.color.text_and_icons_base_primary
                      .withOpacity(0.2),
                ),
              ),
            ),
          ),
          ContactRow(
            contact: 'infoCS@momrah.gov.sa',
            subtitle: context.l10n.email,
            border: true,
          ),
        ],
      );
}

class ContactRow extends StatelessWidget {
  const ContactRow({
    required this.contact,
    required this.subtitle,
    required this.border,
    super.key,
  });

  final String contact;
  final String subtitle;
  final bool border;

  @override
  Widget build(BuildContext context) => Material(
        color: context.color.surface_base_secondary,
        borderRadius: BorderRadius.only(
            bottomLeft:
                border ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: (border
                ? const Radius.circular(12)
                : const Radius.circular(0)),),
        child: InkWell(
          borderRadius: BorderRadius.only(
              bottomLeft:
                  border ? const Radius.circular(12) : const Radius.circular(0),
              bottomRight: (border
                  ? const Radius.circular(12)
                  : const Radius.circular(0)),),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textM
                          .copyWith(
                              color: context.color.text_and_icons_base_primary,),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(
                              color: context.color.text_and_icons_base_primary
                                  .withOpacity(0.36),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
