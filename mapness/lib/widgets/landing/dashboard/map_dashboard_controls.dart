import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/shared/ui/map_controls/map_controls_column.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/dashboard_header.dart';
import 'package:mapness/widgets/landing/eta_sharing_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/tifo_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/parking_spot/parking_control.dart';
import 'package:mapness/widgets/weather/weather_control.dart';
import 'package:sheetify/sheetify.dart';

class MapDashboardControls extends ConsumerWidget {
  final MultiStateSheetController<ThreeStateSheet> scrollController;

  const MapDashboardControls(this.scrollController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNationalDay = ref.watch(saudiNationalDayProvider);

    final freeRoamState = ref.watch(freeRoamStarterProvider);
    final showLaunchingFreeRoam = freeRoamState.canStart && freeRoamState.isAutorun;
    final controlsHeight = 56 + (showLaunchingFreeRoam ? 8 : 0);

    final uiDirection = ref.watch(uiDirectionProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Directionality(
            textDirection: uiDirection,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$3x),
              child: Column(
                children: [
                  const DashboardHeader(),
                  uikit.Spacing.$2x.heightBox,
                ],
              ),
            ),
          ),

          const MapQuickFiltersDefault(
            forMap: true,
          ),
          uikit.Spacing.$4x.heightBox,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$3x),
              // Both columns get whatever height the sheet leaves above it and drop their lowest-priority
              // controls instead of overflowing while the sheet is dragged up or another sheet opens on top.
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MapControlsColumn(
                    children: [
                      MapControlsItem(
                        priority: 90,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            WeatherControl(),
                            ParkingControl(),
                          ],
                        ),
                      ),
                      MapControlsItem(priority: 50, slot: MapControlsSlot.center, child: IndoorControl()),
                    ],
                  ),
                  const Spacer(),
                  MapControlsColumn(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const MapControlsItem(priority: 80, child: LayersControl()),
                      const MapControlsItem(priority: 60, child: DimensionControl()),
                      if (ref.watch(tifoAvailableProvider)) const MapControlsItem(key: ValueKey('tifo'), priority: 50, child: TifoControl()),
                      if (ref.watch(tifoBuildingsMapLayerProvider))
                        const MapControlsItem(
                          key: ValueKey('tifoLeaderboard'),
                          priority: 45,
                          child: TifoLeaderboardControl(),
                        ),
                      // Debug-only zoom stack is the first thing to go when space runs out; pinch still zooms.
                      if (kDebugMode)
                        const MapControlsItem(
                          key: ValueKey('zoom'),
                          priority: 10,
                          slot: MapControlsSlot.center,
                          child: ZoomControl(),
                        ),
                      const MapControlsItem(priority: 70, slot: MapControlsSlot.bottom, child: CompassControl()),
                      MapControlsItem(priority: 30, slot: MapControlsSlot.bottom, child: ComplianceBuildingLegend()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$3x),
            child: Column(
              children: [
                const SizedBox(height: uikit.Spacing.$2x),
                // "Dominate with your team" belongs to this bottom control band,
                // centred between the weather chip and the follow arrow (design
                // 398:8792 / 848:10725) — on a line of its own above them it
                // read as floating loose over the map. Overlaid rather than
                // placed in the row: as a flex child it would be squeezed to a
                // third of the width and the label would break.
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Rules/support entry point — only meaningful
                                // once the player has actually turned the game
                                // on (⚽ toggle).
                                if (ref.watch(tifoBuildingsMapLayerProvider)) ...[
                                  const TifoHelpControl(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const EtaSharingControl(),
                        const Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: FollowControl(),
                          ),
                        ),
                      ],
                    ),
                    // Any session where the gate state is known AND the
                    // player still has a gate left — see `shouldOfferJoin`.
                    // Gating on `!isPlayReady` alone put the pill on screen
                    // after every relaunch, before the session had loaded.
                    if (ref.watch(tifoBuildingsMapLayerProvider) &&
                        ref.watch(tifoSessionProvider.select((s) => s.shouldOfferJoin)))
                      const TifoJoinPill(),
                  ],
                ),
                if (!isNationalDay) uikit.Spacing.$4x.heightBox,
                if (isNationalDay)
                  MultiStateSheetBuilder<ThreeStateSheet>(
                    builder: (context, state, interpolation, child) => SizedBox(
                      height: state == ThreeStateSheet.hidden
                          ? scrollController.componentSizes.topHeader * (1 - interpolation) +
                                uikit.Spacing.$12x * interpolation
                          : uikit.Spacing.$12x,
                    ),
                    defaultState: ThreeStateSheet.hidden,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
