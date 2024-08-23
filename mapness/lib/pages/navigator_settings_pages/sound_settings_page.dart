import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/routes/navigator_settings.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:urbi_utils/urbi_utils.dart';

class SoundSettingsPage extends ConsumerStatefulWidget {
  const SoundSettingsPage({super.key});

  @override
  ConsumerState<SoundSettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SoundSettingsPage> {
  bool muffleOtherSounds = false;

  @override
  Widget build(BuildContext context) {
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final arrowIcon = context.isLTR ? SystemIcons.arrowCornerRightLarge : SystemIcons.arrowCornerLeftLarge;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: Material(
          color: context.colorsV2.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: context.l10n.soundSettings,
                textStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(
                  color: context.colorsV2.foregroundDefault,
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
                    ContentWrapper(
                      color: context.color.surfaceBaseTertiary,
                      children: [
                        ContentRow(
                          options: ContentRowOptions(
                            subtitleStyle: context.textStyleV3.bodySmallRegular.copyWith(
                              color: context.color.textAndIconsBaseSecondary,
                            ),
                            titleStyle: context.textStyleV3.bodyLargeMedium.copyWith(
                              color: context.colorsV2.foregroundDefault,
                            ),
                            padding: const EdgeInsets.only(
                              top: Spacing.$4x,
                              bottom: Spacing.$3x,
                              right: Spacing.$4x,
                              left: Spacing.$4x,
                            ),
                            title: context.l10n.voiceInstruction,
                            subtitle: context.l10n.announcedEvents,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                          child: SegmentTabsButton(
                            tabsContent: [
                              TabsRowV2Content(title: context.l10n.segmentButtonOffTitle),
                              TabsRowV2Content(title: context.l10n.segmentButtonImportantTitle),
                              TabsRowV2Content(title: context.l10n.segmentButtonAllTitle),
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
                            color: context.colorsV2.borderSoft,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                          ),
                        ),
                        ContentRow(
                          onTap: () => const VoiceSettingsRoute().push(context),
                          options: ContentRowOptions(
                            wrapperColor: context.color.surfaceBaseTertiary,
                            wrapperEnabled: true,
                            padding: const EdgeInsets.symmetric(
                              vertical: Spacing.$3x,
                              horizontal: Spacing.$4x,
                            ),
                            title: context.l10n.voice,
                            titleStyle: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                            actionWidget: ContentRowActionOptions(
                              actionIcon: AppIcons(
                                iconData: arrowIcon,
                                color: context.colorsV2.foregroundSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ContentRow(
                      options: ContentRowOptions(
                        titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                          color: context.colorsV2.foregroundDefault,
                        ),
                        wrapperColor: context.color.surfaceBaseTertiary,
                        wrapperEnabled: true,
                        title: context.l10n.promptsVolume,
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.$3x,
                          horizontal: Spacing.$4x,
                        ),
                        bottomWidget: SegmentTabsButton(
                          tabsContent: [
                            TabsRowV2Content(title: context.l10n.segmentButtonMinimumTitle),
                            TabsRowV2Content(title: context.l10n.segmentButtonQuietTitle),
                            TabsRowV2Content(title: context.l10n.segmentButtonStandardTitle),
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
                      headerTitle: context.l10n.backgroundNavigation.toUpperCase(),
                      content: [
                        ContentRow(
                          onToggle: (value) {
                            soundSettingsNotifier.toggleBackgroundNavigation(backgroundNavigation: value);
                          },
                          options: ContentRowOptions(
                            wrapperColor: context.color.surfaceBaseTertiary,
                            wrapperEnabled: true,
                            title: context.l10n.backgroundNavigation,
                            titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                              color: context.color.textAndIconsBasePrimary,
                            ),
                            actionWidget: ContentRowActionOptions(
                              enabledToggle: true,
                              toggleInitialValue: soundSettingsModel.backgroundNavigation,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ContentColumn(
                      headerTitle: context.l10n.eventAlert,
                      content: [
                        ContentWrapper(
                          color: context.color.surfaceBaseTertiary,
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
                                titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                                  color: context.colorsV2.foregroundDefault,
                                ),
                                padding: const EdgeInsets.only(
                                  top: Spacing.$4x,
                                  bottom: Spacing.$3x,
                                  right: Spacing.$4x,
                                  left: Spacing.$4x,
                                ),
                                title: context.l10n.roadCameras,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: Spacing.$4x,
                              ),
                              child: Divider(
                                height: 0.5,
                                color: context.colorsV2.borderSoft,
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
                                titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                                  color: context.colorsV2.foregroundDefault,
                                ),
                                subtitleStyle: context.textStyleV3.bodySmallRegular.copyWith(
                                  color: context.colorsV2.foregroundSoft,
                                ),
                                subtitleMaxlines: 2,
                                subtitle: context.l10n.overSpeedingSubtitle,
                                padding: const EdgeInsets.only(
                                  top: Spacing.$3x,
                                  bottom: Spacing.$3x,
                                  right: Spacing.$4x,
                                  left: Spacing.$4x,
                                ),
                                title: context.l10n.overSpeeding,
                              ),
                            ),
                          ],
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
}
