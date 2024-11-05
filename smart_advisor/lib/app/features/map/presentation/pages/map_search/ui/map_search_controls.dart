/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class MapSearchSheetControls extends ConsumerWidget {
  // In percent of the screen
  final double? currentSize;
  final double collapsedSize;

  // Calculate the topbar and bottom padding
  static const screenPadding = 80 + 70;

  const MapSearchSheetControls({
    required this.collapsedSize,
    this.currentSize,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;

    bool hideControls = false;
    double bottomPadding = 16;

    // Hide controls when the bottom sheet is expanded

    final locationBottomSheet = (currentSize ?? 0) > 0.75;
    hideControls = locationBottomSheet;

    final double padding = (currentSize ?? 0) * screenHeight;

    // Update Padding for the bottom sheet size

    if ((currentSize ?? 0) > 0.28 && (currentSize ?? 0) < 0.4) {
      // for a new feature you need to change and replace the magic number, now these numbers are taken by taking into account all the indents, the height of the bottom nav bar
      bottomPadding = 16 + padding - screenPadding;
    } else {
      bottomPadding = 16;
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
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
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
                          const Row(
                            children: [
                              // TODO(Sergei): uncomment when search performance is fixed
                              // uikit.SearchInArea(
                              //   visible: !visibleSearchArea,
                              //   title: context.l10n.searchInThisArea,
                              //   onTap: _searchInArea,
                              // ),
                              Spacer(),
                              FollowControl(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: collapsedSize),
            ],
          ),
        ),
      ),
    );
  }
}
*/