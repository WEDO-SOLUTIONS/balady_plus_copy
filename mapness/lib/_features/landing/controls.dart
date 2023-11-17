import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/widgets/favorites.dart';
import 'package:mapness/_features/landing/widgets/happines_control.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';

import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/_features/landing/widgets/traffic_control.dart';
import 'package:mapness/_features/landing/widgets/weather_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

class MapControls extends ConsumerWidget {
  const MapControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsState = ref.watch(mapControlsProvider);
    final currentRoute = ref.watch(currentRouteProvider);

    final controlsHidden =
        controlsState is! MapControlsStateIdle || currentRoute != '/landing';

    return IgnorePointer(
      ignoring: controlsHidden,
      child: SafeArea(
        bottom: false,
        child: AnimatedOpacity(
          opacity: controlsHidden ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                          const WeatherControl(),
                          const SizedBox(height: 8),
                          const HappinesControl(),
                          const Spacer(),
                          MapButton(
                            child: SvgPicture.asset(
                              "assets/icons/svg/ic_controls_qibla.svg",
                              semanticsLabel: 'MinApps Screen',
                              package: "mapness",
                            ),
                            onTap: () {
                              const KiblahRoute().push(context);
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayersControl(),
                          SizedBox(
                            height: 8,
                          ),
                          TrafficControl(),
                          Spacer(),
                          ZoomControl(),
                          Spacer(),
                          CompassControl(),
                          SizedBox(
                            height: 8,
                          ),
                          FollowControl(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: controlsState is MapControlsStateIdle ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Favorites(
                      background: Colors.white,
                      horizontalPadding: 4,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 74,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
