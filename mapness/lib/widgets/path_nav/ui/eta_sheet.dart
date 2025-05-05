import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/features/share_eta/ui/share_eta_btn.dart';
import 'package:mapness/pages/navigator_settings/utils/sound_type_extension.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/ui/measure_size.dart';
import 'package:mapness/widgets/path_nav/lib/utils.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet_wrapper.dart';

class EtaSheet extends ConsumerStatefulWidget {
  final AnimationInfo? animationInfo;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onTapRoute;
  final VoidCallback onEndTripPressed;
  final VoidCallback onBetterRouteAccept;
  final VoidCallback onBetterRouteReject;
  final OnWidgetSizeChange onSizeChanged;
  final ValueNotifier<int?> betterRouteDurationProfit;

  const EtaSheet({
    required this.onEndTripPressed,
    required this.onBetterRouteAccept,
    required this.onBetterRouteReject,
    required this.onSizeChanged,
    required this.betterRouteDurationProfit,
    this.animationInfo,
    this.onSearchPressed,
    this.onTapRoute,
    super.key,
  });

  @override
  ConsumerState<EtaSheet> createState() => _EtaSheetState();
}

class _EtaSheetState extends ConsumerState<EtaSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom + (Platform.isAndroid ? Spacing.$5x : 0.0);

    final eta = ref.watch(pathNavEtaProvider);
    final landscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    _isExpanded = eta?.isExpanded ?? false;
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final voiceName = soundSettingsModel.voiceName;
    final l10n = context.l10n;
    final colorsV3 = context.colorsV3;
    final color = context.color;
    final textStyleV3 = context.textStyleV3;
    ref
      ..watch(etaWebsocketStatusProvider.select((_) => null))
      ..watch(websocketTypeProvider.select((_) => null))
      ..watch(shareEtaProvider.select((_) => null));

    final _voiceInstructionTypeTitle =
        soundSettingsNotifier.currentSoundToggleType.mapVoiceInstructionsToTitle(context);

    final _subtitleVoiceInstruction =
        voiceName != null ? '$_voiceInstructionTypeTitle • $voiceName' : _voiceInstructionTypeTitle;

    final padding = (landscape || !_isExpanded) ? Spacing.$4x : 0.0;
    return EtaSheetWrapper(
      onSizeChanged: widget.onSizeChanged,
      betterRouteDurationProfit: widget.betterRouteDurationProfit,
      onBetterRouteAccept: widget.onBetterRouteAccept,
      onBetterRouteReject: widget.onBetterRouteReject,
      child: BaseRoadPanel(
        roadPanelModel: RoadPanelModelEnable(
          padding: EdgeInsets.only(
            left: padding,
            right: padding,
            bottom: _isExpanded ? 0.0 : bottomPadding,
          ),
          contentColor: landscape ? colorsV3.backgroundSurface1 : colorsV3.backgroundSurface4,
          enabledHeader: _isExpanded,
          animationInfo: widget.animationInfo,
          distanceChild: NaviChildModel(
            description: eta != null ? eta.distanceEtaUnits.getDescription(context) : '--',
            title: eta != null ? formatDistance(eta.distanceEta) : '--',
          ),
          arrivalChild: NaviChildModel(
            description: l10n.arrival,
            title: eta != null ? eta.arrivalTime : '--',
          ),
          drivingChild: NaviChildModel(
            description: eta != null ? eta.timeEtaUnits.getDescription(context) : '--',
            title: eta != null ? eta.timeEta : '--',
          ),
          contentRows: [
            Spacing.$3x.heightBox,
            ShareEtaBtn(
              durationMinutes: int.tryParse(eta?.timeEta ?? '') ?? 0,
            ),
            if (widget.onSearchPressed != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: Spacing.$3x,
                ),
                child: ContentRow(
                  onTap: () => widget.onTapRoute?.call(),
                  options: ContentRowOptions(
                    wrapperColor: color.surfaceBaseTertiary,
                    wrapperEnabled: true,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    title: l10n.route,
                    actionWidget: ContentRowActionOptions(
                      actionIcon: AppIcons(
                        iconData: GeneralIcons.routeStroke,
                        color: context.colorsV3.foregroundMuted,
                      ),
                    ),
                  ),
                ),
              ),
            Spacing.$3x.heightBox,
            ContentRow(
              onTap: () => context.router.push(const SoundSettingsRoute()),
              options: ContentRowOptions(
                subtitleStyle: textStyleV3.bodySmallRegular.copyWith(
                  color: color.textAndIconsBaseSecondary,
                ),
                titleStyle: textStyleV3.bodyLargeMedium.copyWith(
                  color: colorsV3.foregroundDefault,
                ),
                wrapperColor: color.surfaceBaseTertiary,
                wrapperEnabled: true,
                title: l10n.voiceInstruction,
                subtitle: _subtitleVoiceInstruction,
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(
                    iconData: SystemIcons.arrowCornerRightLarge,
                    color: context.colorsV3.foregroundMuted,
                  ),
                ),
                bottomWidget: SegmentTabsButton(
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
            ),
            Spacing.$3x.heightBox,
            ContentRow(
              onTap: () => context.router.push(const NavigatorSettingsRoute()),
              options: ContentRowOptions(
                titleStyle: textStyleV3.bodyLargeRegular.copyWith(
                  color: colorsV3.foregroundDefault,
                ),
                wrapperColor: color.surfaceBaseTertiary,
                wrapperEnabled: true,
                title: l10n.navigatorSettings,
                leadingIcon: Icon(
                  SystemIcons.settings,
                  color: color.textAndIconsBaseSecondary,
                ),
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(
                    iconData: SystemIcons.arrowCornerRightLarge,
                    color: context.colorsV3.foregroundMuted,
                  ),
                ),
              ),
            ),
          ],
          buttons: [
            AppButton(
              buttonColorScheme: ButtonColorScheme.warning,
              primaryLabel: l10n.endTrip,
              onTap: widget.onEndTripPressed,
            ),
          ],
          onTapBurger: toggle,
          isSearchShowing: !landscape,
          onTapSearch: widget.onSearchPressed,
          onTapRoute: widget.onTapRoute,
        ),
      ),
    );
  }

  void toggle() {
    ref.read(pathNavEtaProvider.notifier).toggleIsExpanded(isExpanded: !_isExpanded);
    Metrics.logEventAdvanced(MetricsConstants.navigationKeys.burgerToggle,
        group: MetricsConstants.navigationTag,
        action: MetricAction.tap.toString(),
        props: {
          'isExpanded': _isExpanded,
        });
  }
}
