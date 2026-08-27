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
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/share_eta/ui/share_eta_btn.dart';
import 'package:mapness/pages/navigator_settings/utils/sound_type_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/text_utils/voice_settings_utils.dart';
import 'package:mapness/widgets/path_nav/ui/better_route_button.dart';
import 'package:mapness/widgets/path_nav/ui/countdown_banner.dart';
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
  final VoidCallback onSwitchToPedestrian;
  final VoidCallback onCancelSwitchToPedestrian;
  final ToggleSheetController sheetController;
  final bool isLandscape;
  final bool isHomeOrWork;
  final bool showPedestrianPrompt;
  final Duration pedestrianPromptAutoDismiss;
  final ValueNotifier<bool> isSwitchingToFoot;

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
    required this.onSwitchToPedestrian,
    required this.onCancelSwitchToPedestrian,
    required this.sheetController,
    required this.isLandscape,
    required this.isHomeOrWork,
    required this.showPedestrianPrompt,
    required this.pedestrianPromptAutoDismiss,
    required this.isSwitchingToFoot,
    super.key,
  });

  @override
  ConsumerState<NaviSheetPanel> createState() => _NaviPanelLandscapeState();
}

class _NaviPanelLandscapeState extends ConsumerState<NaviSheetPanel> {
  MapTapHandler? _mapTapHandler;
  Object? _mapTapDisableOwner;

  final shapeDelegate = ToggleSheetDelegate.func(
    (controller) => SmoothRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(RadiusBorder.xl),
        bottom: Radius.circular(RadiusBorder.xl * controller.interpolation),
      ),
    ),
  );

  late final barrierDelegate = ToggleSheetDelegate.func((controller) {
    if (widget.isLandscape) {
      return null;
    }
    return AppColor.black.withOpacity(0.4 * (1 - controller.interpolation));
  });

  late final paddingDelegate = ToggleSheetDelegate.func((controller) {
    final padding = MediaQuery.paddingOf(context);
    const stableInset = Spacing.$3x;
    final bottom = padding.bottom == 0 ? stableInset : padding.bottom;
    final left = widget.isLandscape ? stableInset : 0;
    return EdgeInsets.only(
      bottom: (bottom + Spacing.$3x) * controller.interpolation,
      left: left + (Spacing.$4x * controller.interpolation),
      right: Spacing.$4x * controller.interpolation,
    );
  });

  @override
  void initState() {
    super.initState();
    if (ref.read(mediaQueryInfoProvider)?.orientation == Orientation.landscape) {
      final mapTapHandler = ref.read(mapTapHandlerProvider.notifier);
      _mapTapHandler = mapTapHandler;
      _mapTapDisableOwner = mapTapHandler.acquireTapDisableOwner();
    }
  }

  @override
  void deactivate() {
    _releaseMapTapDisable();
    super.deactivate();
  }

  @override
  void dispose() {
    _releaseMapTapDisable();
    super.dispose();
  }

  void _releaseMapTapDisable() {
    final owner = _mapTapDisableOwner;
    if (owner == null) {
      return;
    }
    _mapTapDisableOwner = null;
    _mapTapHandler?.releaseTapDisableOwner(owner);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final currentRoute = ref.watch(currentRouteProvider);
    final eta = ref.watch(pathNavEtaProvider);
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final voiceName = soundSettingsModel.voiceName;
    final _voiceInstructionTypeTitle = soundSettingsNotifier.currentSoundToggleType.mapVoiceInstructionsToTitle(
      context,
    );
    final _subtitleVoiceInstruction = voiceName != null
        ? '$_voiceInstructionTypeTitle • ${localizeVoicePackageName(context, voiceName)}'
        : _voiceInstructionTypeTitle;
    final hasIntermediateRoutePoints = (currentRoute?.points.length ?? 0) > 2;

    final mediaQueryPadding = MediaQuery.paddingOf(context);
    final left = mediaQueryPadding.left;
    final right = mediaQueryPadding.right;
    final width = NaviSheetPanel.landscapeWidth + left + right;

    return SizedBox(
      width: widget.isLandscape ? width : double.infinity,
      child: ToggleSheet(
        dragger: null,
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
        topHeader: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.betterRouteDurationProfit,
              builder: (context, duration, child) => duration != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
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
            if (widget.showPedestrianPrompt)
              CountdownBanner(
                text: context.l10n.switchToPedestrianMode,
                duration: widget.pedestrianPromptAutoDismiss,
                onTap: widget.onSwitchToPedestrian,
                onClose: widget.onCancelSwitchToPedestrian,
                onTimeout: widget.onCancelSwitchToPedestrian,
                leadingIcon: switch (Directionality.of(context)) {
                  TextDirection.ltr => General16Icons.walkLTR,
                  TextDirection.rtl => General16Icons.walkRTL,
                },
              ),
          ],
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
            isSwitchingToFoot: widget.isSwitchingToFoot,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.$3x, vertical: Spacing.$4x),
        content: [
          // hide share button for multilocation route because sharing is broken for such routes
          if (!hasIntermediateRoutePoints) ...[
            ShareEtaBtn(
              sheetController: widget.sheetController,
              durationMinutes: int.tryParse(eta?.timeEta ?? '') ?? 0,
            ),
            Spacing.$3x.heightBox,
          ],
          ContentWrapper.single(
            color: colors.backgroundSurface1,
            child: ContentRow(
              onTap: () => widget.onTapRoute.call(),
              crossAxisAlignment: CrossAxisAlignment.start,
              text: ContentRowTextOptions(title: l10n.route),
              trailing: ContentRowCustomTrailingOptions(
                builder: (_) => Padding(
                  padding: ContentRow.verticalPadding + ContentRow.endPadding + ContentRow.startPadding,
                  child: ContentRowAction(
                    actionOptions: ContentRowActionOptions(
                      actionIcon: AppIcons(iconData: GeneralIcons.routeStroke, color: context.colors.foregroundMuted),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacing.$3x.heightBox,
          ContentWrapper(
            color: colors.backgroundSurface1,
            children: [
              ContentRow(
                onTap: () => context.router.push(const SoundSettingsRoute()),
                text: ContentRowTextOptions(
                  title: l10n.voiceInstruction,
                  titleOptions: ContentRowTextOption(
                    isBold:
                        textStyles.bodyLargeRegular.fontWeight?.value != null &&
                        textStyles.bodyLargeRegular.fontWeight!.value >= FontWeight.w500.value,
                    baseColor: colors.foregroundDefault,
                  ),
                  subtitle: _subtitleVoiceInstruction,
                  subtitleOptions: ContentRowTextOption(
                    isBold:
                        textStyles.bodySmallRegular.fontWeight?.value != null &&
                        textStyles.bodySmallRegular.fontWeight!.value >= FontWeight.w500.value,
                    baseColor: colors.foregroundSoft,
                  ),
                ),
                trailing: ContentRowCustomTrailingOptions(
                  builder: (_) => Padding(
                    padding: ContentRow.verticalPadding + ContentRow.endPadding + ContentRow.startPadding,
                    child: ContentRowAction(
                      actionOptions: ContentRowActionOptions(
                        actionIcon: AppIcons(
                          iconData: SystemIcons.arrowCornerRightLarge,
                          color: context.colors.foregroundMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
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
            ],
          ),
          Spacing.$3x.heightBox,
          ContentRow(
            onTap: () => context.router.push(NavigatorSettingsRoute(showDarkModeSection: false)),
            options: ContentRowOptions(
              titleStyle: textStyles.bodyLargeRegular.copyWith(color: colors.foregroundDefault),
              wrapperColor: context.colors.backgroundSurface1,
              wrapperEnabled: true,
              title: l10n.navigatorSettings,
              leadingIcon: Icon(SystemIcons.settings, color: colors.foregroundSoft),
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
    );
  }
}
