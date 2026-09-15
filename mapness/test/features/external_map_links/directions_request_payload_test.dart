import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/external_map_links/models/directions_request_payload.dart';
import 'package:mapness/features/external_map_links/models/external_map_link_intent.dart';

void main() {
  group('externalDirectionsIntentFromNative', () {
    test('a full payload becomes a point-to-point intent', () {
      final intent = _intent(<String, dynamic>{
        'destinationLatitude': 24.7136,
        'destinationLongitude': 46.6753,
        'destinationName': 'Kingdom Centre',
        'sourceIsCurrentLocation': false,
        'sourceLatitude': 21.4225,
        'sourceLongitude': 39.8262,
        'sourceName': 'Al Masjid al Haram',
        'transportType': 'automobile',
      });

      final destination = _place(intent.destination);
      _expectPoint(destination.point, 24.7136, 46.6753);
      expect(destination.label, 'Kingdom Centre');

      final source = _place(intent.source);
      _expectPoint(source.point, 21.4225, 39.8262);
      expect(source.label, 'Al Masjid al Haram');

      expect(intent.mode, ExternalMapTravelMode.driving);
    });

    test('every MapKit transport type maps onto a mode', () {
      const types = <String, ExternalMapTravelMode>{
        'automobile': ExternalMapTravelMode.driving,
        'walking': ExternalMapTravelMode.walking,
        'transit': ExternalMapTravelMode.transit,
        // `.any` is MapKit's "caller does not care" bit mask: drive them.
        'any': ExternalMapTravelMode.driving,
      };
      for (final entry in types.entries) {
        expect(_intent(_payload(transportType: entry.key)).mode, entry.value, reason: entry.key);
      }
    });

    test('a missing or unexpected transport type falls back to driving', () {
      expect(_intent(_payload()).mode, ExternalMapTravelMode.driving);
      expect(_intent(_payload(transportType: 'hovercraft')).mode, ExternalMapTravelMode.driving);
      expect(_intent(_payload(transportType: 7)).mode, ExternalMapTravelMode.driving);
    });

    test('sourceIsCurrentLocation wins over any coordinates sent with it', () {
      final intent = _intent(<String, dynamic>{
        ..._payload(),
        'sourceIsCurrentLocation': true,
        'sourceLatitude': 21.4225,
        'sourceLongitude': 39.8262,
        'sourceName': 'Al Masjid al Haram',
      });

      expect(intent.source, isNull);
    });

    test('a payload without source keys routes from my location', () {
      expect(_intent(_payload()).source, isNull);
      expect(_intent(<String, dynamic>{..._payload(), 'sourceIsCurrentLocation': false}).source, isNull);
    });

    test('a half or out-of-range source is dropped instead of failing the link', () {
      final sources = <String, Map<String, dynamic>>{
        'latitude only': <String, dynamic>{'sourceLatitude': 21.4225},
        'longitude only': <String, dynamic>{'sourceLongitude': 39.8262},
        'out of range': <String, dynamic>{'sourceLatitude': 91.0, 'sourceLongitude': 39.8262},
        'not a number': <String, dynamic>{'sourceLatitude': '21.4225', 'sourceLongitude': '39.8262'},
      };
      for (final entry in sources.entries) {
        final intent = _intent(<String, dynamic>{..._payload(), ...entry.value});
        expect(intent.source, isNull, reason: entry.key);
      }
    });

    test('an unusable destination drops the whole request', () {
      final payloads = <String, Map<String, dynamic>>{
        'empty': <String, dynamic>{},
        'latitude only': <String, dynamic>{'destinationLatitude': 24.7136},
        'longitude only': <String, dynamic>{'destinationLongitude': 46.6753},
        'latitude out of range': <String, dynamic>{'destinationLatitude': 90.5, 'destinationLongitude': 46.6753},
        'longitude out of range': <String, dynamic>{'destinationLatitude': 24.7136, 'destinationLongitude': -180.5},
        'not a number': <String, dynamic>{'destinationLatitude': '24.7136', 'destinationLongitude': '46.6753'},
        'null': <String, dynamic>{'destinationLatitude': null, 'destinationLongitude': null},
        'not finite': <String, dynamic>{'destinationLatitude': double.nan, 'destinationLongitude': double.infinity},
      };
      for (final entry in payloads.entries) {
        expect(
          externalDirectionsIntentFromNative(<String, dynamic>{...entry.value, 'transportType': 'automobile'}),
          isNull,
          reason: entry.key,
        );
      }
    });

    test('the coordinate bounds themselves are accepted', () {
      final intent = _intent(<String, dynamic>{
        'destinationLatitude': -90.0,
        'destinationLongitude': 180.0,
        'transportType': 'walking',
      });
      _expectPoint(_place(intent.destination).point, -90, 180);
    });

    test('int coordinates from the codec are accepted', () {
      final intent = _intent(<String, dynamic>{
        'destinationLatitude': 24,
        'destinationLongitude': 46,
        'sourceLatitude': 21,
        'sourceLongitude': 39,
        'transportType': 'walking',
      });

      _expectPoint(_place(intent.destination).point, 24, 46);
      _expectPoint(_place(intent.source).point, 21, 39);
      expect(intent.mode, ExternalMapTravelMode.walking);
    });

    test('names are trimmed and an empty one leaves the label unset', () {
      expect(_place(_intent(_payload(destinationName: '  Kingdom Centre  ')).destination).label, 'Kingdom Centre');
      for (final name in <Object?>['', '   ', null, 42]) {
        final intent = _intent(_payload(destinationName: name));
        expect(_place(intent.destination).label, isNull, reason: '$name');
      }
    });
  });
}

Map<String, dynamic> _payload({Object? transportType, Object? destinationName}) => <String, dynamic>{
  'destinationLatitude': 24.7136,
  'destinationLongitude': 46.6753,
  if (transportType != null) 'transportType': transportType,
  if (destinationName != null) 'destinationName': destinationName,
};

ExternalMapDirectionsIntent _intent(Map<String, dynamic> raw) {
  final intent = externalDirectionsIntentFromNative(raw);
  expect(intent, isNotNull, reason: '$raw');
  return intent!;
}

ExternalMapPlacePoint _place(ExternalMapPlace? place) {
  expect(place, isA<ExternalMapPlacePoint>());
  return place! as ExternalMapPlacePoint;
}

void _expectPoint(ExternalMapPoint point, double latitude, double longitude) {
  expect(point.latitude, closeTo(latitude, 1e-9));
  expect(point.longitude, closeTo(longitude, 1e-9));
}
