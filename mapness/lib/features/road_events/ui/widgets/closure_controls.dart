import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/happines_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/weather/widgets/weather_control.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/app/routes/weather.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class ClosureControls extends ConsumerWidget {
  const ClosureControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        bottom: false,
        child: Directionality(
          textDirection: TextDirection.ltr,
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
                            const KiblahRoute().pushReplacement(context);
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
                    const FollowControl(
                      onlyFollowDirection: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
