import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/road_events/helpers/road_event_type_label.dart';
import 'package:mapness/features/road_events/ui/widgets/report_road_event_lanes.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/widgets/path_nav/ui/navi_sheet_panel.dart';
import 'package:sheetify/sheetify.dart';

/// Stub screen for picking a map location for a new road event. The map stays
/// fully interactive; a fixed center marker indicates the point that will be
/// captured.
@RoutePage()
class ReportRoadEventMapSelectPage extends StatefulHookConsumerWidget {
  const ReportRoadEventMapSelectPage({super.key});

  @override
  ConsumerState<ReportRoadEventMapSelectPage> createState() => _ReportRoadEventMapSelectPageState();
}

class _ReportRoadEventMapSelectPageState extends ConsumerState<ReportRoadEventMapSelectPage> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final follow = ref.read(followStateProvider);
      if (follow.type != LocationFollowType.off) {
        ref.read(dgisControllerProvider).value?.stopFollowNavigation();
      }
    });
  }

  Future<void> _onSubmit(GeoPointMessage point, RoadEventType type, Set<RoadEventLane> lanes) async {
    if (_isSubmitting) {
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      final result = await controller.createRoadEvent(
        type: type,
        location: point,
        lanes: lanes,
        description: type.label(context.l10n),
      );
      if (result != AddRoadEventResultMessage.ok) {
        throw Exception('createRoadEvent failed: $result');
      }
      if (!mounted) {
        return;
      }
      context.router.pop();
    } catch (_) {
      if (mounted) {
        // TODO(claude): wire up retry — pop(true) here and re-invoke _onSubmit(point, type,
        // lanes) on true, matching the ErrorSheetDialogRoute pattern used elsewhere (see
        // map_search_history.dart). Right now "Try Again" just dismisses the error.
        await context.router.push(
          ErrorSheetDialogRoute(
            buttonLabel: context.l10n.tryAgain,
            onRetry: () => context.router.pop(),
            onClose: (_) => context.router.pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = ref.watch(cameraPositionProvider)?.point;
    final mediaQuery = ref.read(mediaQueryInfoProvider);
    final mediaQueryTop = mediaQuery?.viewPadding.top ?? 0;
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    final selectedType = useState(RoadEventType.accident);
    final selectedLanes = useState<Set<RoadEventLane>>(const {});

    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());

    // Keeps the native camera's bottom padding matched to the sheet height so
    // cameraPositionProvider's point tracks the center marker (the visible area
    // above the sheet), not the raw full-screen center. Self-adjusts to
    // whatever content height ends up in `content:` later.
    useEffect(() {
      void updateCameraPadding() {
        final sheetHeight = scrollController.sheetHeight.isNegative ? 0 : scrollController.sheetHeight;
        final padding =
            (sheetHeight + mediaQueryTop + (mediaQuery?.padding.bottom ?? 0)) * (mediaQuery?.devicePixelRatio ?? 1);

        ref.read(cameraPaddingProvider.notifier).setPadding(CameraSetPaddingMessage(bottomPadding: padding.toInt()));
      }

      scrollController.addListener(updateCameraPadding);
      updateCameraPadding();
      return () => scrollController.removeListener(updateCameraPadding);
    }, [scrollController]);

    const items = RoadEventType.values;

    final mediaQueryPadding = MediaQuery.paddingOf(context);
    final left = mediaQueryPadding.left;
    final right = mediaQueryPadding.right;
    final width = NaviSheetPanel.landscapeWidth + left + right;

    final pin = Stack(
      children: [
        Assets.icons.svg.icPinPlaceholderRed.svg(),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8, start: 10.5),
          child: switch (selectedType.value.icon()) {
            ToastIconAsset(:final asset) => SvgPicture.asset(
              asset,
              width: 32,
              height: 32,
              colorMapper: _CongestionColorMapper(context.colors),
            ),
            ToastIconData(:final data) => Icon(data, size: 32),
          },
        ),
      ],
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isLandscape)
          Positioned.fill(
            left: width,
            child: Center(child: pin),
          ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: isLandscape ? width : double.infinity,
            padding: isLandscape ? const EdgeInsets.only(top: Spacing.$3x) : null,
            child: ToggleSheet(
              scrollController: scrollController,
              backgroundColor: context.colors.backgroundSurface1,
              safeAreaColor: context.colors.backgroundSurface1,
              dragger: const SheetDragger(),
              outside: isLandscape ? null : Center(child: pin),
              topHeader: isLandscape
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.$2x),
                      child: Container(
                        height: 40,
                        alignment: AlignmentGeometry.bottomCenter,
                        child: Chips(
                          type: ChipsType.map,
                          options: ChipsLabelOptions(
                            labelFirst: context.l10n.roadEventMoveTheMap,
                            leadingIcon: ChipIconData(GeneralIcons.geoposition),
                          ),
                        ),
                      ),
                    ),
              header: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedType.value.label(context.l10n),
                        style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                      ),
                    ),
                    CustomCloseButton(onClose: () => context.router.pop(), padding: EdgeInsets.zero),
                  ],
                ),
              ),
              content: [
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const crossAxisCount = 3;
                      const hSpacing = Spacing.$4x;
                      const vSpacing = Spacing.$3x;
                      const childHeight = 94;
                      final childWidth = (constraints.maxWidth - (crossAxisCount - 1) * hSpacing) / crossAxisCount;

                      final childAspectRatio = childWidth / childHeight;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: vSpacing,
                          crossAxisSpacing: hSpacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return GestureDetector(
                            onTap: () {
                              selectedType.value = item;
                              selectedLanes.value = const {};
                            },
                            child: _ItemCard(
                              icon: item.icon(),
                              iconColor: item.color(context.colors),
                              label: item.label(context.l10n),
                              isSelected: selectedType.value == item,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (selectedType.value.supportsLanes) ...[
                  const SizedBox(height: Spacing.$4x),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReportRoadEventLanes(
                        key: ValueKey(selectedType.value),
                        onUpdate: (lanes) => selectedLanes.value = lanes,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: Spacing.$4x),
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x),
                  child: AppButton(
                    buttonColorScheme: ButtonColorScheme.accent,
                    primaryLabel: context.l10n.roadEventConfirm,
                    buttonState: point == null
                        ? ButtonState.disabled
                        : (_isSubmitting ? ButtonState.loading : ButtonState.defaultState),
                    onTap: (point == null || _isSubmitting)
                        ? null
                        : () => _onSubmit(point, selectedType.value, selectedLanes.value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ToastIcon icon;
  final Color iconColor;
  final String label;
  final bool isSelected;

  const _ItemCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) => Column(
    spacing: Spacing.$1_5x,
    children: [
      Container(
        height: 70,
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface4,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? context.colors.accentDefault : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          child: switch (icon) {
            ToastIconAsset(:final asset) => SvgPicture.asset(asset),
            ToastIconData(:final data) => Icon(
              data,
              color: context.colors.staticWhite,
              size: 38,
            ),
          },
        ),
      ),
      Text(
        label,
        style: context.textStyles.bodySmallMedium.copyWith(color: context.colors.foregroundDefault),
      ),
    ],
  );
}

class _CongestionColorMapper extends ColorMapper {
  final AppColorsThemeV3 colors;

  const _CongestionColorMapper(this.colors);

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (attributeName == 'fill') {
      switch (color) {
        case const Color(0xffF04438):
          return colors.staticBlack;
      }
    }

    return color;
  }
}
