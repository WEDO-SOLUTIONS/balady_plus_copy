// Bridges the transport mode carried by an external link to the routing SDK
// enum. Kept out of the intent model so the model stays free of SDK imports.

import 'package:dgis_map/library.dart';

import '../models/external_map_link_intent.dart';

extension ExternalMapTravelModeMapper on ExternalMapTravelMode {
  /// The routing option the map SDK searches with. Mirrors
  /// `ShortLinkTransportType.toMessage()` for the four modes callers can ask
  /// for; scooter/truck/taxi have no external spelling.
  RouteSearchOptionsMessage get routeSearchOption => switch (this) {
    ExternalMapTravelMode.driving => RouteSearchOptionsMessage.car,
    ExternalMapTravelMode.walking => RouteSearchOptionsMessage.pedestrian,
    ExternalMapTravelMode.transit => RouteSearchOptionsMessage.publicTransport,
    ExternalMapTravelMode.bicycle => RouteSearchOptionsMessage.bicycle,
  };
}
