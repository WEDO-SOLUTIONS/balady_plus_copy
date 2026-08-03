import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/features/road_events/ui/report_road_event_map_select_control.dart';
import 'package:mapness/features/stream_audio/ui/widgets/radio_contextual_button.dart';
import 'package:mapness/pages/free_roam/ui/traffic_parking_control.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/path_nav_ext.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/route_control.dart';
import 'package:mapness/widgets/landing/sound_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';

part 'landscape_map_controls.dart';
part 'portrait_map_controls.dart';

// TODO(Ayat) change controls and take them from uikit
class PathNavMapControls extends StatelessWidget {
  final ValueNotifier<double> bottomHeightNotifier;
  final ValueNotifier<PathNavState> navigationState;

  final RouteSearchOptionsMessage navType;
  final ValueNotifier<bool> showControls;
  final VoidCallback? onRoutePressed;
  final VoidCallback? onUserActivity;

  static const padding = EdgeInsets.symmetric(horizontal: uikit.Spacing.$4x);

  const PathNavMapControls({
    required this.bottomHeightNotifier,
    required this.navigationState,
    required this.showControls,
    required this.navType,
    this.onRoutePressed,
    this.onUserActivity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const compassControlWidget = CompassControl();
    const pathNavFollowControlWidget = FollowControl();

    final maneuverAndLimitWidget = Directionality(
      // Here we set the text direction according to the current locale to display the correct direction of the widget.
      textDirection: Directionality.of(context),
      child: Consumer(
        builder: (context, ref, child) {
          final message = ref.watch(pathNavMessageProvider);
          final maneuver = ref.watch(pathNavManeuverProvider);
          final isPedestrian = navType != RouteSearchOptionsMessage.car;
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
    );

    return Builder(
      builder: (context) {
        if (MediaQuery.orientationOf(context) == Orientation.landscape) {
          return _LandscapeLayout(
            navType: navType,
            navigationState: navigationState,
            maneuverAndLimitWidget: maneuverAndLimitWidget,
            compassControlWidget: compassControlWidget,
            pathNavFollowControlWidget: pathNavFollowControlWidget,
            padding: padding,
            onUserActivity: onUserActivity,
            showControls: showControls,
          );
        } else {
          return _PortraitLayout(
            navType: navType,
            bottomHeightNotifier: bottomHeightNotifier,
            navigationState: navigationState,
            maneuverAndLimitWidget: maneuverAndLimitWidget,
            compassControlWidget: compassControlWidget,
            pathNavFollowControlWidget: pathNavFollowControlWidget,
            padding: padding,
            onRoutePressed: onRoutePressed,
            onUserActivity: onUserActivity,
            showControls: showControls,
          );
        }
      },
    );
  }
}
