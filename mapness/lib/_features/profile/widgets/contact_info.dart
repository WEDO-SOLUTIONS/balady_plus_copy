import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  static const _twitter = '@Balady_CS';
  static const _phone = '199040';
  static const _email = 'infoCS@momrah.gov.sa';

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ContactRow(
            contact: _twitter,
            subtitle: context.l10n.twitterAccount,
            border: false,
            onTap: () =>
                CommonFunctions.launch('https://twitter.com/Balady_CS'),
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
            contact: _phone,
            subtitle: context.l10n.profileContactInformation,
            border: false,
            onTap: () => CommonFunctions.call(_phone),
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
            contact: _email,
            subtitle: context.l10n.email,
            border: true,
            onTap: () => CommonFunctions.email(_email),
          ),
        ],
      );
}

class ContactRow extends StatelessWidget {
  const ContactRow({
    required this.contact,
    required this.subtitle,
    required this.border,
    this.onTap,
    super.key,
  });

  final String contact;
  final String subtitle;
  final bool border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: context.color.surface_base_secondary,
        borderRadius: BorderRadius.only(
          bottomLeft:
              border ? const Radius.circular(12) : const Radius.circular(0),
          bottomRight:
              (border ? const Radius.circular(12) : const Radius.circular(0)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.only(
            bottomLeft:
                border ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight:
                (border ? const Radius.circular(12) : const Radius.circular(0)),
          ),
          onTap: onTap,
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
                      textDirection: TextDirection.ltr,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textM
                          .copyWith(
                            color: context.color.text_and_icons_base_primary,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(
                            color: context.color.text_and_icons_base_primary
                                .withOpacity(0.36),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
