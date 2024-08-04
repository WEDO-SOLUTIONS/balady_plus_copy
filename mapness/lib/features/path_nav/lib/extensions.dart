import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/features/path_nav/lib/enums.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

extension DistanceUnitsExt on DistanceUnits {
  String getDescription(BuildContext context) => switch (this) {
        DistanceUnits.km => context.l10n.km,
        DistanceUnits.m => context.l10n.meter,
      };
}

extension TimeunitsExt on TimeUnits {
  String getDescription(BuildContext context) => switch (this) {
        TimeUnits.min => context.l10n.min,
        TimeUnits.hours => context.l10n.hours,
      };
}

extension PathNavManeuverStateExt on NaviMessageEventState {
  PathNavMessage? getNaviMessage() => switch (this) {
        NaviMessageEventState.gpsLost => const PathNavMessage(state: PathNavMessageState.gpsConnectionLost),
        NaviMessageEventState.routeResearch => const PathNavMessage(state: PathNavMessageState.reroute),
        NaviMessageEventState.none => null,
      };
}

extension RouteSearchOptionsMessageExt on RouteSearchOptionsMessage {
  static RouteSearchOptionsMessage fromString(String value) => switch (value) {
        'car' => RouteSearchOptionsMessage.car,
        'publicTransport' => RouteSearchOptionsMessage.publicTransport,
        'bicycle' => RouteSearchOptionsMessage.bicycle,
        'pedestrian' => RouteSearchOptionsMessage.pedestrian,
        'scooter' => RouteSearchOptionsMessage.scooter,
        'truck' => RouteSearchOptionsMessage.truck,
        'taxi' => RouteSearchOptionsMessage.taxi,
        _ => throw UnimplementedError(),
      };
}
