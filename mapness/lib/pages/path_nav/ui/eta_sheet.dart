import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_sound_provider.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet_wrapper.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

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

  @override
  Widget build(BuildContext context) {
    final eta = ref.watch(pathNavEtaProvider);
    final sound = ref.watch(pathNavSoundProviderProvider);
    final dark = ref.watch(darkModeProvider);
    if (eta == null) {
      return const SizedBox();
    }

    /// Distance could be in format 1544.8 and 0.8 is details compare to 1544 km
    /// So to show it right we have do throw away details
    String distance = eta.distanceEta;
    if (distance.length > 5) {
      // For different locales we can see that delimiter is comma or period
      String delimiter = '';
      if (distance.contains(',')) {
        delimiter = ',';
      }
      distance = distance.split(delimiter).first;
    }
    return EtaSheetWrapper(
      isExpanded: _isExpanded,
      onSizeChanged: widget.onSizeChanged,
      betterRouteDurationProfit: widget.betterRouteDurationProfit,
      onBetterRouteAccept: widget.onBetterRouteAccept,
      onBetterRouteReject: widget.onBetterRouteReject,
      child: BaseRoadPanel(
        roadPanelModel: RoadPanelModelEnable(
          enabledHeader: _isExpanded,
          distanceChild: NaviChildModel(description: eta.distanceEtaUnits.getDescription(context), title: distance),
          arrivalChild: NaviChildModel(description: context.l10n.arrival, title: eta.arrivalTime),
          drivingChild: NaviChildModel(description: eta.timeEtaUnits.getDescription(context), title: eta.timeEta),
          contentRows: [
            ContentRow(
              onToggle: (_) {
                ref.read(darkModeProvider.notifier).toggle();
                Metrics.logEventAdvanced(MetricsConstants.navigationKeys.darkMode,
                    group: MetricsConstants.navigationTag,
                    action: MetricAction.tap.toString(),
                    props: {
                      'dark': !dark,
                    });
              },
              options: ContentRowOptions(
                padding: const EdgeInsets.symmetric(
                  vertical: NumericBase.$3x,
                  horizontal: Spacing.horizontalSpacingTabsRow,
                ),
                title: context.l10n.darkMap,
                titleStyle: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                actionWidget: ContentRowActionOptions(
                  enabledToggle: true,
                  toggleInitialValue: dark,
                ),
              ),
            ),
            ContentRow(
              onToggle: (_) {
                ref.read(pathNavSoundProviderProvider.notifier).toggle();
                Metrics.logEventAdvanced(MetricsConstants.navigationKeys.soundMode,
                    group: MetricsConstants.navigationTag,
                    action: MetricAction.tap.toString(),
                    props: {
                      'sound': !sound,
                    });
              },
              options: ContentRowOptions(
                padding: const EdgeInsets.symmetric(
                  vertical: NumericBase.$3x,
                  horizontal: Spacing.horizontalSpacingTabsRow,
                ),
                title: context.l10n.soundSettings,
                subtitle: context.l10n.maneuvers,
                titleStyle: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                actionWidget: ContentRowActionOptions(
                  enabledToggle: true,
                  toggleInitialValue: sound,
                ),
              ),
            ),
          ],
          buttons: [
            AppButton(
              padding: const EdgeInsets.only(
                left: Spacing.horizontalPaddingInsideCell,
                right: Spacing.horizontalPaddingInsideCell,
                bottom: Spacing.verticalPaddingInsideCell,
              ),
              buttonColorScheme: ButtonColorScheme.warning,
              primaryLabel: context.l10n.endTrip,
              onTap: widget.onEndTripPressed,
            )
          ],
          onTapBurger: toggle,
          onTapRoute: widget.onRoutePressed,
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
}
