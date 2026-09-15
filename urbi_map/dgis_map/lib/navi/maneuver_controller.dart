import 'package:dgis_map/library.dart';

/// Splits the one maneuver stream into the banner's two lines.
class NaviManeuverController {
  /// Creates the controller over the raw maneuver [events].
  const NaviManeuverController(this.events);

  /// All events without filtering
  final Stream<NaviManeuverEvent> events;

  /// The turn to show in the main line of the banner.
  Stream<ManeuverEvent> get maneuverEvents => events.where((event) => event is ManeuverEvent).cast<ManeuverEvent>();

  /// The exit number or following turn shown under the main line.
  Stream<ManeuverAdditionalEvent> get additionalEvents =>
      events.where((event) => event is ManeuverAdditionalEvent).cast<ManeuverAdditionalEvent>();
}
