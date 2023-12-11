import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/config/package_config.dart';
import '../../../shared/providers/app_language.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ContactRow(
          contact: "Balady_CS@",
          subtitle: "Twitter account",
          border: false,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            color: const Color(0xFFF5F7FA),
            child: Padding(
              padding: const EdgeInsets.only(right: 52),
              child: Divider(
                height: 1,
                color: const Color(0xFF1E2A36).withOpacity(0.2),
              ),
            ),
          ),
        ),
        const ContactRow(
          contact: "199040",
          subtitle: "Last name",
          border: false,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            color: const Color(0xFFF5F7FA),
            child: Padding(
              padding: const EdgeInsets.only(right: 52),
              child: Divider(
                height: 1,
                color: const Color(0xFF1E2A36).withOpacity(0.2),
              ),
            ),
          ),
        ),
        const ContactRow(
          contact: "infoCS@balady.gov.sa",
          subtitle: "Email",
          border: true,
        ),
      ],
    );
  }
}

class ContactRow extends ConsumerWidget {
  const ContactRow({
    super.key,
    required this.contact,
    required this.subtitle,
    required this.border,
  });

  final String contact;
  final String subtitle;
  final bool border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    return Material(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.only(
          bottomLeft:
              border ? const Radius.circular(12) : const Radius.circular(0),
          bottomRight:
              (border ? const Radius.circular(12) : const Radius.circular(0))),
      child: InkWell(
        borderRadius: BorderRadius.only(
            bottomLeft:
                border ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: (border
                ? const Radius.circular(12)
                : const Radius.circular(0))),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  Text(
                    contact,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .copyWith(color: const Color(0xFF1E2A36)),
                  ),
                  Text(
                    contact,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textS
                        .copyWith(
                            color: const Color(0xFF1E2A36).withOpacity(0.36)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
