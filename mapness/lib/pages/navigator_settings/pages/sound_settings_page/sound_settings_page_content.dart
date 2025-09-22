import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/pages/navigator_settings/utils/sound_type_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/utils/text_utils/voice_settings_utils.dart';
import 'package:urbi_utils/urbi_utils.dart';

class SoundSettingsPageContent extends ConsumerWidget {
  const SoundSettingsPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final colors = context.colors;
    final l10n = context.l10n;
    final textStyles = context.textStyles;
    final voiceInstructionSubtitle = soundSettingsNotifier.currentSoundToggleType.mapVoiceInstructionsToTitle(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContentWrapper(
              color: colors.backgroundSurface4,
              children: [
                ContentRow(
                  options: ContentRowOptions(
                    subtitleStyle: textStyles.bodySmallRegular.copyWith(
                      color: colors.foregroundSoft,
                    ),
                    titleStyle: textStyles.bodyLargeMedium.copyWith(
                      color: colors.foregroundDefault,
                    ),
                    padding: const EdgeInsets.only(
                      top: Spacing.$4x,
                      bottom: Spacing.$3x,
                      right: Spacing.$4x,
                      left: Spacing.$4x,
                    ),
                    title: l10n.voiceInstruction,
                    subtitle: voiceInstructionSubtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  child: SegmentTabsButton(
                    tabsContent: [
                      TabsRowV2Content(title: l10n.segmentButtonOffTitle),
                      TabsRowV2Content(title: l10n.segmentButtonImportantTitle),
                      TabsRowV2Content(title: l10n.segmentButtonAllTitle),
                    ],
                    onIndexChanged: (value) {
                      if (value != null) {
                        soundSettingsNotifier.toggleVoiceInstruction(currentVoiceInstruction: value);
                      }
                    },
                    initialIndex: soundSettingsModel.voiceInstructionIndex,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Spacing.$3x,
                    left: Spacing.$4x,
                  ),
                  child: Divider(
                    height: 0.5,
                    color: colors.borderSoft,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                ContentRow(
                  onTap: () => context.router.push(const VoiceSettingsRoute()),
                  options: ContentRowOptions(
                    wrapperColor: colors.backgroundSurface4,
                    wrapperEnabled: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.$3x,
                      horizontal: Spacing.$4x,
                    ),
                    title: l10n.voice,
                    titleStyle: context.textStyle.text.copyWith(color: colors.foregroundDefault),
                    actionWidget: ContentRowActionOptions(
                        actionIcon: AppIcons(
                          iconData: SystemIcons.arrowCornerRightLarge,
                          color: colors.foregroundSoft,
                        ),
                        actionText: localizeVoicePackageName(context, soundSettingsModel.voiceName),
                        actionTextStyle: textStyles.bodySmallMedium.copyWith(
                          color: colors.foregroundSoft,
                        )),
                  ),
                ),
              ],
            ),
            ContentRow(
              options: ContentRowOptions(
                titleStyle: textStyles.bodyLargeRegular.copyWith(
                  color: colors.foregroundDefault,
                ),
                wrapperColor: colors.backgroundSurface4,
                wrapperEnabled: true,
                title: l10n.promptsVolume,
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.$3x,
                  horizontal: Spacing.$4x,
                ),
                bottomWidget: SegmentTabsButton(
                  tabsContent: [
                    TabsRowV2Content(title: l10n.segmentButtonMinimumTitle),
                    TabsRowV2Content(title: l10n.segmentButtonQuietTitle),
                    TabsRowV2Content(title: l10n.segmentButtonStandardTitle),
                  ],
                  onIndexChanged: (value) {
                    if (value != null) {
                      soundSettingsNotifier.toggleNavigatorVolume(currentPromptVolumeIndex: value);
                    }
                  },
                  initialIndex: soundSettingsModel.promptsVolumeIndex,
                ),
              ),
            ),
            ContentColumn(
              headerTitle: l10n.eventAlert,
              content: [
                ContentWrapper(
                  color: colors.backgroundSurface4,
                  children: [
                    ContentRow(
                      onToggle: (value) {
                        soundSettingsNotifier.toggleRoadCameras(roadCameras: value);
                      },
                      options: ContentRowOptions(
                        actionWidget: ContentRowActionOptions(
                          enabledToggle: true,
                          toggleInitialValue: soundSettingsModel.roadCameras,
                        ),
                        titleStyle: textStyles.bodyLargeRegular.copyWith(
                          color: colors.foregroundDefault,
                        ),
                        padding: const EdgeInsets.only(
                          top: Spacing.$4x,
                          bottom: Spacing.$3x,
                          right: Spacing.$4x,
                          left: Spacing.$4x,
                        ),
                        title: l10n.roadCameras,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.$4x,
                      ),
                      child: Divider(
                        height: 0.5,
                        color: colors.borderSoft,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                    ),
                    ContentRow(
                      onToggle: (value) {
                        soundSettingsNotifier.toggleOverSpeeding(overSpeeding: value);
                      },
                      options: ContentRowOptions(
                        actionWidget: ContentRowActionOptions(
                          enabledToggle: true,
                          toggleInitialValue: soundSettingsModel.overSpeeding,
                        ),
                        titleStyle: textStyles.bodyLargeRegular.copyWith(
                          color: colors.foregroundDefault,
                        ),
                        subtitleStyle: textStyles.bodySmallRegular.copyWith(
                          color: colors.foregroundSoft,
                        ),
                        subtitleMaxlines: 2,
                        subtitle: l10n.overSpeedingSubtitle,
                        padding: const EdgeInsets.only(
                          top: Spacing.$3x,
                          bottom: Spacing.$3x,
                          right: Spacing.$4x,
                          left: Spacing.$4x,
                        ),
                        title: l10n.overSpeeding,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ].insertBetween(Spacing.$4x.heightBox).toList(),
        ),
      ),
    );
  }
}
