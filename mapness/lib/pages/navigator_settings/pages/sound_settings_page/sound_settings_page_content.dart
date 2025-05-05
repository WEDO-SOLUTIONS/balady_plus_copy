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
    final colorsV2 = context.colorsV2;
    final l10n = context.l10n;
    final textStyleV3 = context.textStyleV3;
    final color = context.color;
    final voiceInstructionSubtitle = soundSettingsNotifier.currentSoundToggleType.mapVoiceInstructionsToTitle(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContentWrapper(
              color: color.surfaceBaseTertiary,
              children: [
                ContentRow(
                  options: ContentRowOptions(
                    subtitleStyle: textStyleV3.bodySmallRegular.copyWith(
                      color: color.textAndIconsBaseSecondary,
                    ),
                    titleStyle: textStyleV3.bodyLargeMedium.copyWith(
                      color: colorsV2.foregroundDefault,
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
                    color: colorsV2.borderSoft,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                ContentRow(
                  onTap: () => context.router.push(const VoiceSettingsRoute()),
                  options: ContentRowOptions(
                    wrapperColor: color.surfaceBaseTertiary,
                    wrapperEnabled: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.$3x,
                      horizontal: Spacing.$4x,
                    ),
                    title: l10n.voice,
                    titleStyle: context.textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                    actionWidget: ContentRowActionOptions(
                        actionIcon: AppIcons(
                          iconData: SystemIcons.arrowCornerRightLarge,
                          color: colorsV2.foregroundSoft,
                        ),
                        actionText: localizeVoicePackageName(context, soundSettingsModel.voiceName),
                        actionTextStyle: textStyleV3.bodySmallMedium.copyWith(
                          color: colorsV2.foregroundSoft,
                        )),
                  ),
                ),
              ],
            ),
            ContentRow(
              options: ContentRowOptions(
                titleStyle: textStyleV3.bodyLargeRegular.copyWith(
                  color: colorsV2.foregroundDefault,
                ),
                wrapperColor: color.surfaceBaseTertiary,
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
                  color: color.surfaceBaseTertiary,
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
                        titleStyle: textStyleV3.bodyLargeRegular.copyWith(
                          color: colorsV2.foregroundDefault,
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
                        color: colorsV2.borderSoft,
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
                        titleStyle: textStyleV3.bodyLargeRegular.copyWith(
                          color: colorsV2.foregroundDefault,
                        ),
                        subtitleStyle: textStyleV3.bodySmallRegular.copyWith(
                          color: colorsV2.foregroundSoft,
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
