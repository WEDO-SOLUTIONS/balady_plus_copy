import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/routes/navigator_settings.dart';
import 'package:mapness/pages/navigator_settings/components/voice_row_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_packages.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:urbi_utils/urbi_utils.dart';

class VoiceSettingsPage extends ConsumerStatefulWidget {
  const VoiceSettingsPage({super.key});

  @override
  ConsumerState<VoiceSettingsPage> createState() => _VoiceSettingsPageState();
}

class _VoiceSettingsPageState extends ConsumerState<VoiceSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final voiceLanguage = ref.watch(soundSettingsProvider).voicesLanguage;

    final voicePackages = ref.watch(voicePackagesProvider);

    final language = Language.values.where((e) => e.locale.languageCode == voiceLanguage).first;

    final installedVoices = voicePackages
        .where((e) => e.language == voiceLanguage && e.packageMessage.info.installed)
        .map((e) => e.packageMessage)
        .toList();

    final unInstalledVoices = voicePackages
        .where((e) => e.language == voiceLanguage && !e.packageMessage.info.installed)
        .map((e) => e.packageMessage)
        .toList();

    final arrowIcon = context.isLTR ? SystemIcons.arrowCornerRightLarge : SystemIcons.arrowCornerLeftLarge;

    final colorsV2 = context.colorsV2;
    final l10n = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: Material(
          color: colorsV2.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: l10n.voice,
                textStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(
                  color: colorsV2.foregroundDefault,
                ),
                leading: ActionModel(
                  onPressed: () => context.pop(),
                  icon: context.isLTR ? SystemIcons.arrowCornerLeftLarge : SystemIcons.arrowCornerRightLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ContentColumn(
                      headerTitle: l10n.languageSelection,
                      content: [
                        ContentRow(
                          onTap: () => LanguagePickSheetRoute.open(context),
                          options: ContentRowOptions(
                            wrapperColor: colorsV2.backgroundSurface1,
                            wrapperEnabled: true,
                            title: l10n.language,
                            actionWidget: ContentRowActionOptions(
                              actionText: _getCurrentLanguageTitle(context, language),
                              actionTextStyle: context.textStyle.footNote.copyWith(
                                color: colorsV2.foregroundSoft,
                              ),
                              actionIcon: AppIcons(
                                iconData: arrowIcon,
                                color: colorsV2.foregroundSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (installedVoices.isNotEmpty)
                      ContentColumn(
                        headerTitle: l10n.downloadedTitle,
                        content: [
                          ContentWrapper(
                            color: colorsV2.backgroundSurface1,
                            children: installedVoices
                                .map((e) => VoiceRowWidget(package: e))
                                .cast<Widget>()
                                .insertBetween(
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: Spacing.$4x,
                                    ),
                                    child: Divider(
                                      height: 0.5,
                                      color: colorsV2.borderSoft,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    if (unInstalledVoices.isNotEmpty)
                      ContentColumn(
                        headerTitle: l10n.availableForDownloadingTitle,
                        content: [
                          ContentWrapper(
                            color: colorsV2.backgroundSurface1,
                            children: unInstalledVoices
                                .map(
                                  (e) => VoiceRowWidget(package: e),
                                )
                                .cast<Widget>()
                                .insertBetween(
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: Spacing.$4x,
                                    ),
                                    child: Divider(
                                      height: 0.5,
                                      color: colorsV2.borderSoft,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                  ].insertBetween(Spacing.$4x.heightBox).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentLanguageTitle(BuildContext context, Language language) => switch (language) {
        Language.arabic => context.l10n.arabicTitle,
        Language.english => context.l10n.englishTitle,
      };
}
