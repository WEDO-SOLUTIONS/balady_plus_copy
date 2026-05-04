import 'package:dgis_map/library.dart';

class NaviManeuverController {
  const NaviManeuverController(this.events);

  /// All events without filtering
  final Stream<NaviManeuverEvent> events;

  Stream<ManeuverEvent> get maneuverEvents => events.where((event) => event is ManeuverEvent).cast<ManeuverEvent>();

  Stream<ManeuverAdditionalEvent> get additionalEvents =>
      events.where((event) => event is ManeuverAdditionalEvent).cast<ManeuverAdditionalEvent>();
}
