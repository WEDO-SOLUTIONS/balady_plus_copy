import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/happines_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/_features/landing/widgets/search_in_area.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/weather/widgets/weather_control.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/app/routes/weather.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class MapControls extends ConsumerStatefulWidget {
  const MapControls({
    required this.draggableScrollableController,
    required this.onScroll,
    super.key,
  });

  final DraggableScrollableController draggableScrollableController;
  final bool onScroll;

  @override
  ConsumerState<MapControls> createState() => _MapControlsState();
}

class _MapControlsState extends ConsumerState<MapControls> {
  bool _hideControls = false;
  double _bottomPadding = 16;

  @override
  void didUpdateWidget(covariant MapControls oldWidget) {
    _handleScroll();
    super.didUpdateWidget(oldWidget);
  }

  void _handleScroll() {
    if (!widget.onScroll) {
      final currentSize = widget.draggableScrollableController.size;
      final double screenHeight = MediaQuery.of(context).size.height;
      final double padding = currentSize * screenHeight;
      setState(() {
        final locationBottomSheet = currentSize > 0.90;
        _hideControls = locationBottomSheet;

        if (currentSize > 0.28 && currentSize < 0.4) {
          // for a new feature you need to change and replace the magic number, now these numbers are taken by taking into account all the indents, the height of the bottom nav bar
          _bottomPadding = 16 + padding - 74 - 80;
        } else {
          _bottomPadding = 16;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controlsState = ref.watch(mapControlsProvider);

    return IgnorePointer(
      ignoring: _hideControls,
      child: SafeArea(
        bottom: false,
        child: AnimatedOpacity(
          opacity: _hideControls ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12,
                      top: 12,
                      right: 12,
                      bottom: _bottomPadding,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WeatherControl(
                              onTap: () => const WeatherRoute().push(context),
                            ),
                            const SizedBox(height: 8),
                            const HappinesControl(),
                            const Spacer(),
                            const IndoorControl(),
                            const Spacer(),
                            Row(
                              children: [
                                MapButton(
                                  child: SvgPicture.asset(
                                    'assets/icons/svg/ic_controls_qibla.svg',
                                    semanticsLabel: 'MinApps Screen',
                                    package: 'mapness',
                                  ),
                                  onTap: () async {
                                    Metrics.logEventAdvanced(
                                      MetricsConstants.exploreKeys.qibla,
                                      action: MetricAction.tap.name,
                                      group: MetricsConstants.exploreTag,
                                    );
                                    final location = ref.read(locationProvider.notifier);

                                    await location
                                        .checkLocationPermission()
                                        .then((allowed) {
                                      if (allowed) {
                                        const KiblahRoute().push(context);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                const SearchInArea(),
                              ],
                            ),
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
                            ComplienceBuildingLegend(),
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
