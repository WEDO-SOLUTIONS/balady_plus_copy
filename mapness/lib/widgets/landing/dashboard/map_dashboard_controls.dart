import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/dashboard_header.dart';
import 'package:mapness/widgets/landing/eta_sharing_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/tifo_control.dart';
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
    final tifoBuildingsVisible = ref.watch(tifoBuildingsMapLayerProvider);
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const WeatherControl(),
                          uikit.Spacing.$1_5x.heightBox,
                          const ParkingControl(),
                        ],
                      ),
                      const Spacer(),
                      const IndoorControl(),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const LayersControl(),
                      // The 2D/3D toggle steps aside while the TIFO overlay is
                      // up: the camera is pinned to the bird-eye view there
                      // (BR-05) and `_reassertTopDown` flattens it again after
                      // every gesture, so switching to 3D is undone within a
                      // fraction of a second. Left out of the column rather
                      // than hidden - its own hidden state still returns a
                      // 48px box so neighbours don't jump, which would free no
                      // space and the column would keep overflowing.
                      if (!tifoBuildingsVisible) ...[
                        const SizedBox(height: uikit.Spacing.$2x),
                        const DimensionControl(),
                      ],
                      if (ref.watch(tifoAvailableProvider)) ...[
                        const SizedBox(height: uikit.Spacing.$2x),
                        const TifoControl(),
                      ],
                      if (tifoBuildingsVisible) ...[
                        const SizedBox(height: uikit.Spacing.$2x),
                        const TifoLeaderboardControl(),
                      ],
                      const SizedBox(height: uikit.Spacing.$2x),
                      // No zoom stack here. It is debug-only and two buttons
                      // tall, and this column has no room for it once the TIFO
                      // controls join - it was the first thing to overflow.
                      // Zoom stays reachable by pinching.
                      const Spacer(),
                      const CompassControl(),
                      const SizedBox(height: uikit.Spacing.$2x),
                      ComplianceBuildingLegend(),
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
                                if (tifoBuildingsVisible) ...[
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
                    if (tifoBuildingsVisible && ref.watch(tifoSessionProvider.select((s) => s.shouldOfferJoin)))
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
