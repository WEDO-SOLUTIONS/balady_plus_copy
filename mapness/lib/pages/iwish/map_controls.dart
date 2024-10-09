import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/eta_sharing_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/happines_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/weather/widgets/weather_control.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/routes/weather.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class MapControls extends ConsumerWidget {
  const MapControls({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsState = ref.watch(mapControlsProvider);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 12,
                  bottom: 16,
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
                        const EtaSharingControl(),
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

                            await location.checkLocationPermission().then((allowed) {
                              if (allowed) {
                                context.router.push(const KiblahRoute());
                              }
                            });
                          },
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
                        ComplianceBuildingLegend(),
                        const SizedBox(height: 8),
                        const FollowControl(),
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
                  id: QuickFilterScreen.iwish,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 74,
          ),
        ],
      ),
    );
  }
}
