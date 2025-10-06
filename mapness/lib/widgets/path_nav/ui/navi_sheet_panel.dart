import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/share_eta/ui/share_eta_btn.dart';
import 'package:mapness/pages/navigator_settings/utils/sound_type_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/widgets/path_nav/ui/better_route_button.dart';
import 'package:mapness/widgets/path_nav/ui/header/navi_eta_header.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_banner.dart';
import 'package:sheetify/sheetify.dart';
import 'package:smooth_corner/smooth_corner.dart';

class NaviSheetPanel extends ConsumerStatefulWidget {
  static const landscapeWidth = 370.0;

  final ValueNotifier<PathNavState> navigationState;
  final RouteSearchOptionsMessage navType;

  final VoidCallback onShowRoutePressed;
  final Function(BuildContext context) acceptBetterRoute;
  final Function(BuildContext context) rejectBetterRoute;
  final Function(BuildContext context) onSearchPressed;
  final ValueNotifier<int?> betterRouteDurationProfit;

  final VoidCallback onContinuePressed;
  final VoidCallback endTripAndShowHome;
  final VoidCallback onTapRoute;
  final VoidCallback endTripAndBuildAnotherRoute;
  final VoidCallback onEndTripPressed;
  final ToggleSheetController sheetController;
  final bool isLandscape;
  final bool isHomeOrWork;

  const NaviSheetPanel({
    required this.navType,
    required this.navigationState,
    required this.onShowRoutePressed,
    required this.acceptBetterRoute,
    required this.rejectBetterRoute,
    required this.betterRouteDurationProfit,
    required this.onContinuePressed,
    required this.endTripAndShowHome,
    required this.endTripAndBuildAnotherRoute,
    required this.onSearchPressed,
    required this.onTapRoute,
    required this.onEndTripPressed,
    required this.sheetController,
    required this.isLandscape,
    required this.isHomeOrWork,
    super.key,
  });

  @override
  ConsumerState<NaviSheetPanel> createState() => _NaviPanelLandscapeState();
}

class _NaviPanelLandscapeState extends ConsumerState<NaviSheetPanel> {
  final sheetKey = GlobalKey();

  late final shapeDelegate = ToggleSheetDelegateFunction<ShapeBorder?>(
    function: (controller) => SmoothRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(RadiusBorder.xl),
        bottom: Radius.circular(RadiusBorder.xl * controller.interpolation),
      ),
    ),
  );
  late final paddingDelegate = ToggleSheetDelegateFunction<EdgeInsets?>(function: (controller) {
    final padding = MediaQuery.viewPaddingOf(context);
    return EdgeInsets.only(
      bottom: ((widget.isLandscape ? 0.0 : Spacing.$3x) + padding.bottom) * (controller.interpolation),
      left: Spacing.$4x * controller.interpolation,
      right: Spacing.$4x * controller.interpolation,
    );
  });
  late final barrierDelegate = ToggleSheetDelegateFunction<Color?>(
    function: (controller) {
      if (widget.isLandscape) {
        return null;
      }
      return AppColor.black.withOpacity(0.4 * (1 - controller.interpolation));
    },
  );

  @override
  void initState() {
    super.initState();
    if (ref.read(mediaQueryInfoProvider)?.orientation == Orientation.landscape) {
      ref.read(mapTapHandlerProvider.notifier).disableTapOnMap = true;
    }
  }

  @override
  void deactivate() {
    ref.read(mapTapHandlerProvider.notifier).disableTapOnMap = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    // final color = context.color;
    final textStyles = context.textStyles;

    final eta = ref.watch(pathNavEtaProvider);
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final voiceName = soundSettingsModel.voiceName;
    final _voiceInstructionTypeTitle =
        soundSettingsNotifier.currentSoundToggleType.mapVoiceInstructionsToTitle(context);
    final _subtitleVoiceInstruction =
        voiceName != null ? '$_voiceInstructionTypeTitle • $voiceName' : _voiceInstructionTypeTitle;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: MediaQuery.paddingOf(context).left),
      child: SizedBox(
        width: widget.isLandscape ? NaviSheetPanel.landscapeWidth : null,
        child: ToggleSheet(
          key: sheetKey,
          dragger: null,
          useSafeArea: false,
          shouldPop: (controller) {
            ref.read(pathNavMessageProvider.notifier).stopNavigation();
            ref.read(dgisControllerProvider).value?.stopNavigation();
            return false;
          },
          startConfig: ToggleSheetStart.closed,
          backgroundColor: colors.backgroundSurface4,
          scrollController: widget.sheetController,
          shapeBorderDelegate: shapeDelegate,
          paddingDelegate: paddingDelegate,
          barrierColorDelegate: barrierDelegate,
          topHeader: ValueListenableBuilder(
            valueListenable: widget.betterRouteDurationProfit,
            builder: (context, duration, child) => duration != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: Spacing.$4x,
                      right: Spacing.$4x,
                      bottom: Spacing.$3x,
                    ),
                    child: BetterRouteButton(
                      title: context.l10n.betterRouteFound(max((duration / 60).round(), 1)),
                      onTap: () => widget.acceptBetterRoute(context),
                      onCloseTap: () => widget.rejectBetterRoute(context),
                    ),
                  )
                : ParkingBanner(
                    navigatorType: widget.navType,
                    navigationState: widget.navigationState,
                    isHomeOrWork: widget.isHomeOrWork,
                    bottomSheetController: widget.sheetController,
                  ),
          ),
          header: ValueListenableBuilder<PathNavState>(
            valueListenable: widget.navigationState,
            builder: (context, state, child) => EtaHeader(
              sheetController: widget.sheetController,
              onEndTripPressed: widget.onEndTripPressed,
              onSearchPressed: () => widget.onSearchPressed(context),
              onContinuePressed: widget.onContinuePressed,
              onTapRoute: widget.onTapRoute,
              state: state,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.$3x, vertical: Spacing.$4x),
          content: [
            ShareEtaBtn(
              durationMinutes: int.tryParse(eta?.timeEta ?? '') ?? 0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.$3x,
              ),
              child: ContentRow(
                onTap: () => widget.onTapRoute.call(),
                options: ContentRowOptions(
                  wrapperColor: colors.staticWhite,
                  wrapperEnabled: true,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  title: l10n.route,
                  actionWidget: ContentRowActionOptions(
                    actionIcon: AppIcons(
                      iconData: GeneralIcons.routeStroke,
                      color: context.colors.foregroundMuted,
                    ),
                  ),
                ),
              ),
            ),
            Spacing.$3x.heightBox,
            ContentWrapper(
              color: colors.staticWhite,
              children: [
                ContentRow(
                  onTap: () => context.router.push(const SoundSettingsRoute()),
                  options: ContentRowOptions(
                    titleStyle: textStyles.bodyLargeRegular.copyWith(
                      color: colors.foregroundDefault,
                    ),
                    subtitleStyle: textStyles.bodySmallRegular.copyWith(
                      color: colors.foregroundSoft,
                    ),
                    title: l10n.voiceInstruction,
                    subtitle: _subtitleVoiceInstruction,
                    actionWidget: ContentRowActionOptions(
                      actionIcon: AppIcons(
                        iconData: SystemIcons.arrowCornerRightLarge,
                        color: context.colors.foregroundMuted,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
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
              ],
            ),
            Spacing.$3x.heightBox,
            ContentRow(
              onTap: () => context.router.push(const NavigatorSettingsRoute()),
              options: ContentRowOptions(
                titleStyle: textStyles.bodyLargeRegular.copyWith(
                  color: colors.foregroundDefault,
                ),
                wrapperColor: context.colors.staticWhite,
                wrapperEnabled: true,
                title: l10n.navigatorSettings,
                leadingIcon: Icon(
                  SystemIcons.settings,
                  color: colors.foregroundSoft,
                ),
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(
                    iconData: SystemIcons.arrowCornerRightLarge,
                    color: context.colors.foregroundMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
