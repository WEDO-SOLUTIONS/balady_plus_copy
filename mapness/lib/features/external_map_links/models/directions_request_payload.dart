// Converts the `MKDirectionsRequest` payload that `DirectionsRequestChannel`
// sends over the method channel into the shared intent model.
//
// Pure Dart, like the rest of `models/`: the method-channel codec hands us a
// plain map, so the conversion stays unit-testable without Flutter. Values may
// arrive as `int` or `double` depending on what MapKit produced, and anything
// we cannot read is dropped rather than guessed.

import 'external_map_link_intent.dart';

/// Turns the raw native payload into a directions intent, or `null` when the
/// destination coordinate is missing or unusable — the only part of the
/// request we cannot act without.
ExternalMapDirectionsIntent? externalDirectionsIntentFromNative(Map<String, dynamic> raw) {
  final destination = _point(raw['destinationLatitude'], raw['destinationLongitude']);
  if (destination == null) {
    return null;
  }

  final transportType = raw['transportType'];
  return ExternalMapDirectionsIntent(
    destination: ExternalMapPlacePoint(point: destination, label: _label(raw['destinationName'])),
    source: _source(raw),
    mode: ExternalMapTravelMode.fromMapKit(transportType is String ? transportType : null),
  );
}

/// `null` means "start from where I am": either the caller said so explicitly
/// or it sent no usable source, and the routing page resolves that itself.
ExternalMapPlace? _source(Map<String, dynamic> raw) {
  if (raw['sourceIsCurrentLocation'] == true) {
    return null;
  }

  final point = _point(raw['sourceLatitude'], raw['sourceLongitude']);
  if (point == null) {
    return null;
  }
  return ExternalMapPlacePoint(point: point, label: _label(raw['sourceName']));
}

/// Accepts both codec spellings of a number and rejects anything outside the
/// ±90 / ±180 envelope, mirroring `CLLocationCoordinate2DIsValid` on the
/// native side.
ExternalMapPoint? _point(Object? rawLatitude, Object? rawLongitude) {
  final latitude = rawLatitude is num ? rawLatitude.toDouble() : null;
  final longitude = rawLongitude is num ? rawLongitude.toDouble() : null;
  if (latitude == null || longitude == null) {
    return null;
  }
  if (!latitude.isFinite || !longitude.isFinite) {
    return null;
  }
  if (latitude.abs() > 90 || longitude.abs() > 180) {
    return null;
  }
  return ExternalMapPoint(latitude: latitude, longitude: longitude);
}

String? _label(Object? raw) {
  if (raw is! String) {
    return null;
  }
  final label = raw.trim();
  return label.isEmpty ? null : label;
}
