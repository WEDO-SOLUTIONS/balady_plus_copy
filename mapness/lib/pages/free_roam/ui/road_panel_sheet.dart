import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/navigator_settings.dart';
import 'package:mapness/app/routes/road_panel.dart';
import 'package:mapness/app/routes/sound_settings.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';

class RoadPanelSheet extends ConsumerStatefulWidget {
  const RoadPanelSheet({super.key});

  @override
  ConsumerState<RoadPanelSheet> createState() => RoadPanelSheetState();
}

class RoadPanelSheetState extends ConsumerState<RoadPanelSheet> with SingleTickerProviderStateMixin {
  static const sheetPanelMaxHeight = 0.45;

  static const duration = Duration(milliseconds: 250);
  static const showHideDuration = Duration(milliseconds: 150);

  static const curve = Curves.easeIn;

  late final DraggableScrollableController sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showBottomSheet());
  }

  @override
  void dispose() {
    super.dispose();
    sheetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = ref.watch(uiDirectionProvider);
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);

    return Scaffold(
      body: DraggableScrollableSheet(
        controller: sheetController,
        minChildSize: .0,
        initialChildSize: .0,
        maxChildSize: sheetPanelMaxHeight,
        snapSizes: const [.0, sheetPanelMaxHeight],
        snap: true,
        builder: (context, scrollController) {
          final l10n = context.l10n;
          final colorsV2 = context.colorsV2;
          final textStyleV3 = context.textStyleV3;
          final color = context.color;

          return Directionality(
            textDirection: direction,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(RadiusBorder.xl),
              ),
              child: ColoredBox(
                color: colorsV2.backgroundSurface4,
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: ColoredBox(
                        color: colorsV2.backgroundSurface1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: ButtonSize.small.height),
                              const SheetDragger(),
                              AppButton.close(
                                primaryIcon: SystemIcons.arrowCornerDownLarge,
                                onTap: () {
                                  Metrics.logEventAdvanced(
                                    MetricsConstants.layersKeys.exitIcon,
                                    group: MetricsConstants.layersTag,
                                    action: MetricAction.tap.toString(),
                                  );
                                  _hideLayersPanel();
                                },
                                padding: EdgeInsets.zero,
                                innerPadding: const EdgeInsets.all(Spacing.$2x),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const SizedBox(height: Spacing.$4x),
                            ContentWrapper(
                              color: color.surfaceBaseTertiary,
                              children: [
                                ContentRow(
                                  onTap: () {
                                    const SoundSettingsRoute().push(context);
                                  },
                                  options: ContentRowOptions(
                                    subtitleStyle: textStyleV3.bodySmallRegular.copyWith(
                                      color: color.textAndIconsBaseSecondary,
                                    ),
                                    titleStyle: textStyleV3.bodyLargeMedium.copyWith(
                                      color: colorsV2.foregroundDefault,
                                    ),
                                    actionWidget: ContentRowActionOptions(
                                      actionIcon: AppIcons(
                                        iconData: SystemIcons.arrowCornerRightLarge,
                                        color: context.staticColor.textAndIconsBaseTertiary,
                                      ),
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
                                  const NavigatorSettingsRoute().push(context);
                                },
                                options: ContentRowOptions(
                                  leadingIcon: Icon(
                                    SystemIcons.settings,
                                    size: Spacing.$6x,
                                    color: colorsV2.foregroundMuted,
                                  ),
                                  title: l10n.navigatorSettings,
                                  actionWidget: ContentRowActionOptions(
                                    actionIcon: AppIcons(
                                      iconData: SystemIcons.arrowCornerRightLarge,
                                      color: context.staticColor.textAndIconsBaseTertiary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.$5x),
                            AppButton(
                              buttonColorScheme: ButtonColorScheme.warning,
                              color: colorsV2.errorDefault,
                              primaryLabel: l10n.endTrip,
                              onTap: _endTripAndShowHome,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _endTrip(VoidCallback action) async {
    await ref.read(dgisControllerProvider).value?.freeRoamController.stop();
    action();
  }

  Future<void> _endTripAndShowHome() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

    await _endTrip(() {
      if (context.mounted) {
        const LandingRoute().go(context);
      }
    });
  }

  void _hideLayersPanel() {
    sheetController.animateTo(
      .0,
      duration: showHideDuration,
      curve: curve,
    );
  }

  void _showBottomSheet() {
    sheetController
        .animateTo(
      sheetPanelMaxHeight,
      duration: showHideDuration,
      curve: curve,
    )
        .then((_) {
      sheetController.addListener(() {
        final navigator = ref.read(goRouterProvider);
        if (sheetController.isAttached &&
            sheetController.size < .1 &&
            RoadPanelRoute.isCurrent(context) &&
            navigator.canPop()) {
          navigator.pop();
        }
      });
    });
  }
}

class ContentContainer extends StatelessWidget {
  final Widget child;

  const ContentContainer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
            color: context.colorsV2.backgroundSurface1, borderRadius: BorderRadius.circular(RadiusBorder.xl)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: child,
        ),
      );
}
