import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/free_roam/free_roam_manager.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';

@RoutePage()
class RoadPanelSheetPage extends ConsumerStatefulWidget {
  const RoadPanelSheetPage({super.key});

  @override
  ConsumerState<RoadPanelSheetPage> createState() => RoadPanelSheetState();
}

class RoadPanelSheetState extends ConsumerState<RoadPanelSheetPage> with SingleTickerProviderStateMixin {
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
                                  onTap: () => context.router.push(const SoundSettingsRoute()),
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
                                  context.router.push(const NavigatorSettingsRoute());
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
                              onTap: () =>
                                  ref.read(freeRoamManagerProvider.notifier).endTripAndShowHome(context: context),
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
        final isPopingSheet = context.router.current is RoadPanelSheetRoute;
        if (isPopingSheet && sheetController.isAttached && sheetController.size < .1) {
          context.router.popForced();
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
          padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
          child: child,
        ),
      );
}
