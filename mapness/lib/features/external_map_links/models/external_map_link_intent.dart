// Intent model for map links handed to us by other apps: the `baladymaps://`
// scheme (Meta/WhatsApp), Android `geo:` URIs and iOS `MKDirectionsRequest`.
//
// Deliberately free of Flutter and SDK imports so that parsing stays a pure,
// unit-testable transformation; the platform mapping lives next to it in
// `lib/external_map_travel_mode_mapper.dart`.

/// A geographic point carried by an external link.
class ExternalMapPoint {
  final double latitude;
  final double longitude;

  const ExternalMapPoint({required this.latitude, required this.longitude});

  /// `geo:0,0` is the sentinel callers use for "no coordinate, see `q`",
  /// so it must never be treated as a real location or a search hint.
  bool get isNullIsland => latitude == 0 && longitude == 0;

  @override
  String toString() => 'ExternalMapPoint($latitude, $longitude)';
}

/// A place an external link points at: either an exact point or free text that
/// still has to be geocoded.
sealed class ExternalMapPlace {
  const ExternalMapPlace();
}

class ExternalMapPlacePoint extends ExternalMapPlace {
  final ExternalMapPoint point;
  final String? label;

  const ExternalMapPlacePoint({required this.point, this.label});

  @override
  String toString() => 'ExternalMapPlacePoint($point, label: $label)';
}

class ExternalMapPlaceQuery extends ExternalMapPlace {
  final String query;

  const ExternalMapPlaceQuery({required this.query});

  @override
  String toString() => 'ExternalMapPlaceQuery($query)';
}

/// Travel mode requested by the caller, independent of the routing SDK enum.
enum ExternalMapTravelMode {
  driving,
  walking,
  transit,
  bicycle;

  /// Maps the `mode` token of a `baladymaps://` link. Unknown or missing tokens
  /// fall back to [driving] — the mode third-party callers assume by default.
  static ExternalMapTravelMode fromToken(String? token) => switch (token?.trim().toLowerCase()) {
    'walking' || 'walk' || 'pedestrian' || 'foot' => walking,
    'transit' || 'publictransport' || 'public_transport' || 'bus' => transit,
    'bicycle' || 'bicycling' || 'biking' || 'bike' => bicycle,
    _ => driving,
  };

  /// Maps `MKDirectionsTransportType` as serialised by the iOS bridge.
  /// `automobile`, `any` and anything unexpected fall back to [driving].
  static ExternalMapTravelMode fromMapKit(String? type) => switch (type?.trim().toLowerCase()) {
    'walking' => walking,
    'transit' => transit,
    _ => driving,
  };
}

/// What the caller asked us to show. `null` is never produced by the parser for
/// a valid link, so every intent below is actionable as-is.
sealed class ExternalMapLinkIntent {
  const ExternalMapLinkIntent();
}

/// Run a text search, optionally biased around [near].
class ExternalMapSearchIntent extends ExternalMapLinkIntent {
  final String query;
  final ExternalMapPoint? near;

  const ExternalMapSearchIntent({required this.query, this.near});

  @override
  String toString() => 'ExternalMapSearchIntent($query, near: $near)';
}

/// Open the point card for an exact coordinate.
class ExternalMapShowLocationIntent extends ExternalMapLinkIntent {
  final ExternalMapPoint point;
  final String? label;
  final double? zoom;

  const ExternalMapShowLocationIntent({required this.point, this.label, this.zoom});

  @override
  String toString() => 'ExternalMapShowLocationIntent($point, label: $label, zoom: $zoom)';
}

/// Build a route to [destination]; a null [source] means "my location".
class ExternalMapDirectionsIntent extends ExternalMapLinkIntent {
  final ExternalMapPlace destination;
  final ExternalMapTravelMode mode;
  final ExternalMapPlace? source;

  const ExternalMapDirectionsIntent({required this.destination, required this.mode, this.source});

  @override
  String toString() => 'ExternalMapDirectionsIntent($destination, source: $source, mode: $mode)';
}
