import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/navigator_settings.dart';
import 'package:mapness/app/routes/path_nav.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/features/share_eta/ui/share_eta_btn.dart';
import 'package:mapness/pages/navigator_settings/utils/sound_type_extension.dart';
import 'package:mapness/pages/path_nav/lib/utils.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet_wrapper.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/router_extension.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';

import 'layout_size_wrapper.dart';

class EtaSheet extends ConsumerStatefulWidget {
  final VoidCallback onEndTripPressed;
  final VoidCallback onRoutePressed;
  final VoidCallback onBetterRouteAccept;
  final VoidCallback onBetterRouteReject;
  final OnWidgetSizeChange onSizeChanged;
  final ValueNotifier<int?> betterRouteDurationProfit;

  const EtaSheet({
    required this.onEndTripPressed,
    required this.onRoutePressed,
    required this.onBetterRouteAccept,
    required this.onBetterRouteReject,
    required this.onSizeChanged,
    required this.betterRouteDurationProfit,
    super.key,
  });

  @override
  ConsumerState<EtaSheet> createState() => _EtaSheetState();
}

class _EtaSheetState extends ConsumerState<EtaSheet> {
  bool _isExpanded = false;

  ///TODO: discuss to team and move to riverpod provider all the same cases
  StreamSubscription<TapEvent>? _streamSubscription;

  @override
  void initState() {
    _setupTapListener();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eta = ref.watch(pathNavEtaProvider);
    _isExpanded = eta?.isExpanded ?? false;
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final voiceName = soundSettingsModel.voiceName;
    final l10n = context.l10n;
    final colorsV2 = context.colorsV2;
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

    return EtaSheetWrapper(
      isExpanded: _isExpanded,
      onSizeChanged: widget.onSizeChanged,
      betterRouteDurationProfit: widget.betterRouteDurationProfit,
      onBetterRouteAccept: widget.onBetterRouteAccept,
      onBetterRouteReject: widget.onBetterRouteReject,
      backgroundColor: colorsV2.backgroundSurface4,
      child: BaseRoadPanel(
        roadPanelModel: RoadPanelModelEnable(
          contentColor: colorsV2.backgroundSurface4,
          enabledHeader: _isExpanded,
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
            ShareEtaBtn(
              durationMinutes: int.tryParse(eta?.timeEta ?? '') ?? 0,
            ),
            ContentRow(
              onTap: () => const SoundSettingsRoute().push(context),
              options: ContentRowOptions(
                subtitleStyle: textStyleV3.bodySmallRegular.copyWith(
                  color: color.textAndIconsBaseSecondary,
                ),
                titleStyle: textStyleV3.bodyLargeMedium.copyWith(
                  color: colorsV2.foregroundDefault,
                ),
                wrapperColor: color.surfaceBaseTertiary,
                wrapperEnabled: true,
                title: l10n.voiceInstruction,
                subtitle: _subtitleVoiceInstruction,
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.$4x,
                  horizontal: Spacing.$4x,
                ),
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(
                    iconData: SystemIcons.arrowCornerRightLarge,
                    color: color.textAndIconsBaseTertiary,
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
            ContentRow(
              onTap: () => const NavigatorSettingsRoute().push(context),
              options: ContentRowOptions(
                titleStyle: textStyleV3.bodyLargeRegular.copyWith(
                  color: colorsV2.foregroundDefault,
                ),
                wrapperColor: color.surfaceBaseTertiary,
                wrapperEnabled: true,
                title: l10n.navigatorSettings,
                leadingIcon: Icon(
                  SystemIcons.settings,
                  color: color.textAndIconsBaseSecondary,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.$3x,
                  horizontal: Spacing.$4x,
                ),
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(
                    iconData: SystemIcons.arrowCornerRightLarge,
                    color: color.textAndIconsBaseTertiary,
                  ),
                ),
              ),
            ),
          ],
          buttons: [
            AppButton(
              padding: const EdgeInsets.only(
                left: Spacing.$4x,
                right: Spacing.$4x,
                bottom: Spacing.$3x,
              ),
              buttonColorScheme: ButtonColorScheme.warning,
              primaryLabel: l10n.endTrip,
              onTap: widget.onEndTripPressed,
            )
          ],
          onTapBurger: toggle,
          onTapRoute: eta != null ? widget.onRoutePressed : () {},
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

  Future<void> _setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription = dgisController.objectTapEvents.listen((_) {
      final goRouter = ref.read(goRouterProvider);

      if (goRouter.isCurrentRoute(PathNavRoute.path)) {
        if (_isExpanded) {
          ref.read(pathNavEtaProvider.notifier).toggleIsExpanded(isExpanded: false);
        }
      }
    });
  }
}
