import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_sound_provider.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet_wrapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

import 'layout_size_wrapper.dart';

class EtaSheet extends ConsumerStatefulWidget {
  const EtaSheet({
    required this.onEndTripPressed,
    required this.onRoutePressed,
    required this.onSizeChanged,
    super.key,
  });
  final VoidCallback onEndTripPressed;
  final VoidCallback onRoutePressed;
  final OnWidgetSizeChange onSizeChanged;

  @override
  ConsumerState<EtaSheet> createState() => _EtaSheetState();
}

class _EtaSheetState extends ConsumerState<EtaSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final eta = ref.watch(pathNavEtaProvider);
    final sound = ref.watch(pathNavSoundProviderProvider);
    if (eta == null) {
      return const SizedBox();
    }
    return EtaSheetWrapper(
      isExpanded: _isExpanded,
      onSizeChanged: widget.onSizeChanged,
      child: BaseRoadPanel(
        roadPanelModel: RoadPanelModelEnable(
          enabledHeader: _isExpanded,
          distanceChild: NaviChildModel(
              description: eta.distanceEtaUnits.getDescription(context),
              title: eta.distanceEta),
          arrivalChild: NaviChildModel(
              description: context.l10n.arrival, title: eta.arrivalTime),
          drivingChild: NaviChildModel(
              description: eta.timeEtaUnits.getDescription(context),
              title: eta.timeEta),
          contentRows: [
            ContentRow(
              onToggle: (_) => ref.read(darkModeProvider.notifier).toggle(),
              options: ContentRowOptions(
                padding: const EdgeInsets.symmetric(
                  vertical: NumericBase.$3x,
                  horizontal: Spacing.horizontalSpacingTabsRow,
                ),
                title: context.l10n.darkMap,
                titleStyle: context.textStyle.text
                    .copyWith(color: context.color.textAndIconsBasePrimary),
                actionWidget: ContentRowActionOptions(
                  enabledToggle: true,
                  toggleInitialValue: ref.watch(darkModeProvider),
                ),
              ),
            ),
            ContentRow(
              onToggle: (_) =>
                  ref.read(pathNavSoundProviderProvider.notifier).toggle(),
              options: ContentRowOptions(
                padding: const EdgeInsets.symmetric(
                  vertical: NumericBase.$3x,
                  horizontal: Spacing.horizontalSpacingTabsRow,
                ),
                title: context.l10n.soundSettings,
                subtitle: context.l10n.maneuvers,
                titleStyle: context.textStyle.text
                    .copyWith(color: context.color.textAndIconsBasePrimary),
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
                left: NumericBase.$4x,
                right: NumericBase.$4x,
                bottom: NumericBase.$3x,
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
  }
}
