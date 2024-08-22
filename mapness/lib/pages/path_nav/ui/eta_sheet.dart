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

import 'package:mapness/pages/path_nav/lib/utils.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet_wrapper.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/router_extension.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/dgis_packages.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';

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
    String? voiceName;
    final eta = ref.watch(pathNavEtaProvider);
    final soundSettingsModel = ref.watch(soundSettingsProvider);
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final arrowIcon = context.isLTR ? SystemIcons.arrowCornerRightLarge : SystemIcons.arrowCornerLeftLarge;
    final selectedVoice = ref.watch(navigatorVoiceProvider);

    final voicePackages = ref.watch(voicePackagesProvider);

    if (voicePackages.isNotEmpty) {
      voiceName = voicePackages.map((e) => e.packageMessage).where((e) => e.id == selectedVoice).first.info.name;
    }

    final _subtitleVoiceInstruction =
        voiceName != null ? '${context.l10n.announcedEvents} • $voiceName' : context.l10n.announcedEvents;

    return EtaSheetWrapper(
      isExpanded: _isExpanded,
      onSizeChanged: widget.onSizeChanged,
      betterRouteDurationProfit: widget.betterRouteDurationProfit,
      onBetterRouteAccept: widget.onBetterRouteAccept,
      onBetterRouteReject: widget.onBetterRouteReject,
      backgroundColor: context.colorsV2.backgroundSurface4,
      child: BaseRoadPanel(
        roadPanelModel: RoadPanelModelEnable(
          contentColor: context.colorsV2.backgroundSurface4,
          enabledHeader: _isExpanded,
          distanceChild: NaviChildModel(
            description: eta != null ? eta.distanceEtaUnits.getDescription(context) : '--',
            title: eta != null ? formatDistance(eta.distanceEta) : '--',
          ),
          arrivalChild: NaviChildModel(
            description: context.l10n.arrival,
            title: eta != null ? eta.arrivalTime : '--',
          ),
          drivingChild: NaviChildModel(
            description: eta != null ? eta.timeEtaUnits.getDescription(context) : '--',
            title: eta != null ? eta.timeEta : '--',
          ),
          contentRows: [
            ContentRow(
              onTap: () => const SoundSettingsRoute().push(context),
              options: ContentRowOptions(
                subtitleStyle: context.textStyleV3.bodySmallRegular.copyWith(
                  color: context.color.textAndIconsBaseSecondary,
                ),
                titleStyle: context.textStyleV3.bodyLargeMedium.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
                wrapperColor: context.color.surfaceBaseTertiary,
                wrapperEnabled: true,
                title: context.l10n.voiceInstruction,
                subtitle: _subtitleVoiceInstruction,
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.$4x,
                  horizontal: Spacing.$4x,
                ),
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(
                    iconData: arrowIcon,
                    color: context.color.textAndIconsBaseTertiary,
                  ),
                ),
                bottomWidget: SegmentTabsButton(
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
            ),
            ContentRow(
              onTap: () => const NavigatorSettingsRoute().push(context),
              options: ContentRowOptions(
                titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
                wrapperColor: context.color.surfaceBaseTertiary,
                wrapperEnabled: true,
                title: context.l10n.navigatorSettings,
                leadingIcon: Icon(
                  SystemIcons.settings,
                  color: context.color.textAndIconsBaseSecondary,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.$3x,
                  horizontal: Spacing.$4x,
                ),
                actionWidget: ContentRowActionOptions(
                  actionIcon: AppIcons(
                    iconData: arrowIcon,
                    color: context.color.textAndIconsBaseTertiary,
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
              primaryLabel: context.l10n.endTrip,
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
    setState(() {
      _isExpanded = !_isExpanded;
    });
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
        setState(() {
          if (_isExpanded) {
            _isExpanded = false;
          }
        });
      }
    });
  }
}
