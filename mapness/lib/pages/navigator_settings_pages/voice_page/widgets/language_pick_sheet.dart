import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:urbi_utils/urbi_utils.dart';

class LanguagePickSheet extends StatelessWidget {
  const LanguagePickSheet({super.key});

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        builder: (context, controller) => DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorsV2.backgroundSurface4,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusBorder.xl),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Column(
              children: [
                Spacing.$2x.heightBox,
                DrawLineWidget(
                  lineHeight: Spacing.$1x,
                  lineWidth: Spacing.$10x,
                  lineColor: context.colorsV2.neutralMuted,
                ),
                Spacing.$3x.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Voice language',
                      style: context.textStyle.heading2.copyWith(
                        color: context.colorsV2.foregroundDefault,
                      ),
                    ),
                    AppButton.close(
                      padding: EdgeInsets.zero,
                      onTap: () => context.pop(),
                      color: context.colorsV2.neutralDefault.withOpacity(0.12),
                      iconColor: context.colorsV2.foregroundSoft,
                      innerPadding: const EdgeInsets.all(Spacing.$2x),
                    ),
                  ],
                ),
                Spacing.$3x.heightBox,
                ContentWrapper(
                  color: context.color.surfaceBaseTertiary,
                  children: [
                    ...Language.values.map(
                      (e) => LanguageRowWidget(
                        currentLanguage: e,
                      ),
                    ),
                  ]
                      .cast<Widget>()
                      .insertBetween(
                        Padding(
                          padding: const EdgeInsets.only(left: Spacing.$4x),
                          child: Divider(color: context.colorsV2.borderSoft),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      );
}

class LanguageRowWidget extends ConsumerWidget {
  final Language currentLanguage;

  const LanguageRowWidget({
    required this.currentLanguage,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundSettings = ref.watch(soundSettingsProvider);
    final languageCode = currentLanguage.locale.languageCode;

    return ContentRow(
      onTap: () {
        ref.read(soundSettingsProvider.notifier).switchLanguage(currentVoiceLanguage: languageCode);
        context.pop();
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
                  color: context.colorsV2.successDefault,
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
