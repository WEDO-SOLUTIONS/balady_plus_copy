import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) => const Column(
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

class LanguageRow extends ConsumerWidget {
  const LanguageRow({
    required this.language, required this.border, super.key,
  });

  final Language language;
  final bool border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
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
                      ? 'assets/icons/svg/ic_radio_on.svg'
                      : 'assets/icons/svg/ic_radio_off.svg',
                  height: 24,
                  width: 24,
                  package: PackageConfig.packageName,
                  color: context.color.text_and_icons_status_accent,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  language.title,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .copyWith(color: context.color.text_and_icons_base_primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
