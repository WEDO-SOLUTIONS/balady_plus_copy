import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/_features/landing/widgets/search_in_area.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class MapControls extends ConsumerWidget {
  // Calculate the topbar and bottom padding
  static const screenPadding = 80 + 70;

  final DraggableScrollableController draggableScrollableController;

  const MapControls({
    required this.draggableScrollableController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsState = ref.watch(mapControlsProvider);
    final double screenHeight = MediaQuery.of(context).size.height;

    bool hideControls = false;
    double bottomPadding = 16;

    double currentSize = 0;

    // Hide controls when the bottom sheet is expanded
    if (draggableScrollableController.isAttached) {
      currentSize = draggableScrollableController.size;
      final locationBottomSheet = currentSize > 0.75;
      hideControls = locationBottomSheet;
    }

    final double padding = currentSize * screenHeight;

    // Update Padding for the bottom sheet size
    if (draggableScrollableController.isAttached) {
      if (currentSize > 0.28 && currentSize < 0.4) {
        // for a new feature you need to change and replace the magic number, now these numbers are taken by taking into account all the indents, the height of the bottom nav bar
        bottomPadding = 16 + padding - screenPadding;
      } else {
        bottomPadding = 16;
      }
    }

    return IgnorePointer(
      ignoring: hideControls,
      child: SafeArea(
        bottom: false,
        child: AnimatedOpacity(
          opacity: hideControls ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 400),
                    padding: EdgeInsets.only(
                      left: 12,
                      top: 12,
                      right: 12,
                      bottom: bottomPadding,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const IndoorControl(),
                            Consumer(builder: (context, ref, _) => const SearchInArea()),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const LayersControl(),
                            const SizedBox(height: 8),
                            const TrafficControl(),
                            const Spacer(),
                            const ZoomControl(),
                            const Spacer(),
                            const CompassControl(),
                            const SizedBox(height: 8),
                            ComplianceBuildingLegend(),
                            const SizedBox(height: 8),
                            const FollowControl(
                              onlyFollowDirection: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: controlsState is MapControlsStateIdle ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Directionality(
                  textDirection: ref.watch(uiDirectionProvider),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: MapQuickFilters(
                      forMap: true,
                      id: QuickFilterScreen.controls,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 74),
            ],
          ),
        ),
      ),
    );
  }
}