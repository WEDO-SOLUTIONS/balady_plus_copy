import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/pages/free_roam/ui/traffic_parking_control.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/path_nav_ext.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_follow_control.dart';

class PathNavMapControlsLandscape extends StatelessWidget {
  final ValueNotifier<double> bottomHeightNotifier;
  final ValueNotifier<PathNavState> navigationState;
  final ValueNotifier<bool> expansionNotifier;
  final RouteSearchOptionsMessage navType;

  static const padding = EdgeInsets.symmetric(horizontal: uikit.Spacing.$4x);

  const PathNavMapControlsLandscape({
    required this.bottomHeightNotifier,
    required this.navigationState,
    required this.expansionNotifier,
    required this.navType,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: navigationState,
            builder: (context, state, child) {
              if (state == PathNavState.finished) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    final value = expansionNotifier.value;
                    if (value) {
                      expansionNotifier.value = !value;
                    }
                  },
                  child: const SizedBox.expand(),
                );
              }
              return const SizedBox();
            },
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
                  child: Directionality(
                    // Here we set the text direction according to the current locale to display the correct direction of the widget.
                    textDirection: Directionality.of(context),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final message = ref.watch(pathNavMessageProvider);
                        final maneuver = ref.watch(pathNavManeuverProvider);
                        final isPedestrian = navType == RouteSearchOptionsMessage.pedestrian;
                        final info = ref.watch(pathNavSpeedInfoProvider);

                        // This made to remove yellow lines under the text
                        return Material(
                          type: MaterialType.transparency,
                          color: Colors.transparent,
                          child: uikit.BaladyManeuverAndLimit(
                            isPedestrian: isPedestrian,
                            speedInfo: uikit.LimitsModel(
                              speed: info.speed,
                              speedExceed: info.speedExceed,
                              speedLimit: info.speedLimit,
                            ),
                            maneuver: maneuver != null
                                ? uikit.BaladyManeuverModel(
                                    distance: maneuver.distance,
                                    instruction: maneuver.instruction?.toUIKit(),
                                    roadName: maneuver.roadName,
                                    unit: maneuver.unit,
                                  )
                                : null,
                            message: message != null
                                ? uikit.ManeuverMessageModel(
                                    comment: message.state.toMessage(context.l10n),
                                    state: message.state.toUIKit(),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: uikit.Spacing.$3x),
                  const Padding(
                    padding: padding,
                    child: TrafficParkingControl(
                      trafficVisible: false,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: padding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (navType == RouteSearchOptionsMessage.pedestrian)
                          const IndoorControl()
                        else
                          const SizedBox.shrink(),
                        const ZoomControl(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: padding,
                    child: CompassControl(),
                  ),
                  const SizedBox(height: uikit.Spacing.$2x),
                  const Padding(
                    padding: padding,
                    child: PathNavFollowControl(),
                  ),
                  const SizedBox(height: uikit.Spacing.$4x),
                ],
              ),
            ],
          ),
        ],
      );
}
