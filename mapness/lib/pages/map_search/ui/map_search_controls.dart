import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';

class MapSearchSheetControls extends ConsumerStatefulWidget {
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
  MapSearchSheetControlsState createState() => MapSearchSheetControlsState();
}

class MapSearchSheetControlsState extends ConsumerState<MapSearchSheetControls> {
  final _scope = SearchScopeEnum.map.value;

  void _searchInArea() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.searchInThisArea,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );

    ref.read(searchInRectProvider(_scope).notifier).update();
    ref.read(searchProvider(_scope).notifier).searchInThisArea(_scope);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    bool hideControls = false;
    double bottomPadding = 16;

    // Hide controls when the bottom sheet is expanded
    final locationBottomSheet = (widget.currentSize ?? 0) > 0.75;
    hideControls = locationBottomSheet;

    final double padding = (widget.currentSize ?? 0) * screenHeight;

    // Update Padding for the bottom sheet size
    if ((widget.currentSize ?? 0) > 0.28 && (widget.currentSize ?? 0) < 0.4) {
      // for a new feature you need to change and replace the magic number, now these numbers are taken by taking into account all the indents, the height of the bottom nav bar
      bottomPadding = 16 + padding - MapSearchSheetControls.screenPadding;
    } else {
      bottomPadding = 16;
    }
    final ValueNotifier<bool> visibleSearchArea = ValueNotifier(false);
    ref.watch(searchInRectProvider(SearchScopeEnum.map.value).select((value) {
      if (visibleSearchArea.value != value.isButtonVisible) {
        visibleSearchArea.value = value.isButtonVisible;
      }
    }));

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
                          const SizedBox(height: uikit.Spacing.$2x),
                          const DimensionControl(),
                          const Spacer(),
                          const ZoomControl(),
                          const Spacer(),
                          const CompassControl(),
                          const SizedBox(height: 8),
                          ComplianceBuildingLegend(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: visibleSearchArea,
                                builder: (context, value, child) => uikit.SearchInArea(
                                  visible: !value,
                                  title: context.l10n.searchInThisArea,
                                  onTap: _searchInArea,
                                ),
                              ),
                              const Spacer(),
                              const FollowControl(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
