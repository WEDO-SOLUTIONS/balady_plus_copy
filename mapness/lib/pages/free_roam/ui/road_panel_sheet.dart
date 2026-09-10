import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class RoadPanelSheetPage extends HookConsumerWidget {
  const RoadPanelSheetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);

    final sheetController = useToggleSheetController(
      onClose: (c) {
        context.router.pop();
      },
    );

    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final color = context.colors;

    return Directionality(
      textDirection: direction,
      child: ToggleSheet(
        dragger: SheetDragger(backgroundColor: colors.backgroundSurface1),
        backgroundColor: colors.backgroundSurface4,
        safeAreaColor: context.colors.backgroundSurface4,
        scrollController: sheetController,
        header: ColoredBox(
          color: colors.backgroundSurface1,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: Spacing.$4x, end: Spacing.$4x, bottom: Spacing.$3x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.close(
                  primaryIcon: SystemIcons.search,
                  onTap: () {
                    sheetController.close();
                    context.router.push(NaviSearchRoute());
                  },
                  padding: EdgeInsets.zero,
                ),
                Text(
                  context.l10n.freeRoam,
                  style: context.textStyles.h3SemiBold.copyWith(color: color.foregroundDefault),
                ),
                AppButton.close(
                  primaryIcon: SystemIcons.arrowCornerDownLarge,
                  onTap: () {
                    Metrics.logEventAdvanced(
                      MetricsConstants.layersKeys.exitIcon,
                      group: MetricsConstants.layersTag,
                      action: MetricAction.tap.toString(),
                    );
                    sheetController.close();
                  },
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        content: [
          const SizedBox(height: Spacing.$4x),
          ContentWrapper(
            color: color.backgroundSurface1,
            children: [
              ContentRow(
                onTap: () => context.router.push(const SoundSettingsRoute()),
                options: ContentRowOptions(
                  subtitleStyle: textStyles.bodySmallRegular.copyWith(color: color.foregroundSoft),
                  titleStyle: textStyles.bodyLargeMedium.copyWith(color: colors.foregroundDefault),
                  actionWidget: ContentRowActionOptions(
                    actionIcon: AppIcons(iconData: SystemIcons.arrowCornerRightSmall, color: color.foregroundMuted),
                  ),
                  padding: const EdgeInsets.only(
                    top: Spacing.$4x,
                    bottom: Spacing.$3x,
                    right: Spacing.$4x,
                    left: Spacing.$4x,
                  ),
                  title: l10n.voiceInstruction,
                  subtitle: l10n.announcedEvents,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                child: SegmentTabsButton(
                  key: ValueKey('voice_instruction_${soundSettingsModel.voiceInstructionIndex}'),
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
              Spacing.$3x.heightBox,
            ],
          ),
          const SizedBox(height: Spacing.$3x),
          ContentContainer(
            child: ContentRow(
              onTap: () {
                context.router.push(NavigatorSettingsRoute(showDarkModeSection: false));
              },
              options: ContentRowOptions(
                leadingIcon: Icon(SystemIcons.settings, size: Spacing.$6x, color: colors.foregroundSoft),
                title: l10n.navigatorSettings,
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(iconData: SystemIcons.arrowCornerRightSmall, color: color.foregroundMuted),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.$5x),
          // AppButton(
          //   buttonColorScheme: ButtonColorScheme.error,
          //   size: ButtonSize.large,
          //   color: colors.errorDefault,
          //   primaryLabel: l10n.endTrip,
          //   onTap: () => ref.read(freeRoamManagerProvider.notifier).endTripAndShowHome(context: context),
          // ),
          // const SizedBox(height: Spacing.$2x),
        ],
      ),
    );
  }
}

class ContentContainer extends StatelessWidget {
  final Widget child;

  const ContentContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.backgroundSurface1,
      borderRadius: BorderRadius.circular(RadiusBorder.xl),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
      child: child,
    ),
  );
}
