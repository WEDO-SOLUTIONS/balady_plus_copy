import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/config/package_config.dart';
import '../../../shared/providers/app_language.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LanguageRow(
          language: Language.arabic,
          border: false,
        ),
        LanguageRow(
          language: Language.english,
          border: true,
        ),
      ],
    );
  }
}

class LanguageRow extends ConsumerWidget {
  const LanguageRow({
    super.key,
    required this.language,
    required this.border,
  });

  final Language language;
  final bool border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    return Material(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.only(
          bottomLeft: border ? Radius.circular(12) : Radius.circular(0),
          bottomRight: (border ? Radius.circular(12) : Radius.circular(0))),
      child: InkWell(
        borderRadius: BorderRadius.only(
            bottomLeft: border ? Radius.circular(12) : Radius.circular(0),
            bottomRight: (border ? Radius.circular(12) : Radius.circular(0))),
        onTap: () {
          ref.read(appLanguageProvider.notifier).update(language);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                currentLanguage == language
                    ? "assets/icons/svg/ic_radio_on.svg"
                    : "assets/icons/svg/ic_radio_off.svg",
                height: 24,
                width: 24,
                package: PackageConfig.packageName,
              ),
              const Spacer(),
              Text(
                language.title,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(color: const Color(0xFF1E2A36)),
              ),
              const SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                language.icon,
                height: 24,
                width: 24,
                package: PackageConfig.packageName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
