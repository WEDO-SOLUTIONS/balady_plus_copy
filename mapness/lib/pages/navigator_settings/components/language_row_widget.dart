import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';

class LanguageRowWidget extends ConsumerWidget {
  final Language currentLanguage;

  const LanguageRowWidget({
    required this.currentLanguage,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundSettings = ref.watch(soundSettingsProvider);
    final languageCode = currentLanguage.languageCode; // 'ar_SA' or 'en_SA'

    return ContentRow(
      onTap: () {
        ref.read(soundSettingsProvider.notifier).switchLanguage(currentVoiceLanguage: languageCode);
        context.router.pop();
      },
      options: ContentRowOptions(
        title: _getTitle(context, currentLanguage),
        subtitle: _getSubtitle(context, currentLanguage),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.$4x,
          vertical: Spacing.$2x,
        ),
        actionWidget: languageCode == soundSettings.voicesLanguage
            ? ContentRowActionOptions(
                actionIcon: AppIcons(
                  iconData: SystemIcons.checkmark,
                  color: context.colors.successDefault,
                ),
              )
            : null,
      ),
    );
  }

  String _getTitle(BuildContext context, Language language) => switch (language) {
        Language.arabic => context.l10n.arabicTitle,
        Language.english => context.l10n.englishTitle,
      };

  String _getSubtitle(BuildContext context, Language language) => switch (language) {
        Language.arabic => context.l10n.arabicRevertSubtitle,
        Language.english => context.l10n.englishRevertSubtitle,
      };
}
