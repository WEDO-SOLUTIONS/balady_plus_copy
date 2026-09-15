import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/external_map_links/lib/external_map_travel_mode_mapper.dart';
import 'package:mapness/features/external_map_links/models/external_map_link_intent.dart';

void main() {
  group('ExternalMapTravelModeMapper.routeSearchOption', () {
    test('every mode maps onto the routing SDK option', () {
      const expected = <ExternalMapTravelMode, RouteSearchOptionsMessage>{
        ExternalMapTravelMode.driving: RouteSearchOptionsMessage.car,
        ExternalMapTravelMode.walking: RouteSearchOptionsMessage.pedestrian,
        ExternalMapTravelMode.transit: RouteSearchOptionsMessage.publicTransport,
        ExternalMapTravelMode.bicycle: RouteSearchOptionsMessage.bicycle,
      };

      expect(expected.keys, containsAll(ExternalMapTravelMode.values), reason: 'a new mode needs a mapping');
      expected.forEach((mode, option) => expect(mode.routeSearchOption, option, reason: mode.name));
    });
  });

  group('ExternalMapTravelMode.fromToken', () {
    test('known tokens map onto their mode', () {
      const tokens = <String, ExternalMapTravelMode>{
        'walking': ExternalMapTravelMode.walking,
        'walk': ExternalMapTravelMode.walking,
        'pedestrian': ExternalMapTravelMode.walking,
        'foot': ExternalMapTravelMode.walking,
        'transit': ExternalMapTravelMode.transit,
        'publictransport': ExternalMapTravelMode.transit,
        'public_transport': ExternalMapTravelMode.transit,
        'bus': ExternalMapTravelMode.transit,
        'bicycle': ExternalMapTravelMode.bicycle,
        'bicycling': ExternalMapTravelMode.bicycle,
        'biking': ExternalMapTravelMode.bicycle,
        'bike': ExternalMapTravelMode.bicycle,
        'driving': ExternalMapTravelMode.driving,
      };
      for (final entry in tokens.entries) {
        expect(ExternalMapTravelMode.fromToken(entry.key), entry.value, reason: entry.key);
      }
    });

    test('tokens are trimmed and case-insensitive', () {
      expect(ExternalMapTravelMode.fromToken('  WALKING '), ExternalMapTravelMode.walking);
      expect(ExternalMapTravelMode.fromToken('Public_Transport'), ExternalMapTravelMode.transit);
    });

    test('unknown, empty and missing tokens fall back to driving', () {
      for (final token in ['hovercraft', 'car', '', '   ', null]) {
        expect(ExternalMapTravelMode.fromToken(token), ExternalMapTravelMode.driving, reason: '$token');
      }
    });
  });

  group('ExternalMapTravelMode.fromMapKit', () {
    test('MKDirections transport types map onto their mode', () {
      const types = <String?, ExternalMapTravelMode>{
        'walking': ExternalMapTravelMode.walking,
        'Walking': ExternalMapTravelMode.walking,
        'transit': ExternalMapTravelMode.transit,
        'automobile': ExternalMapTravelMode.driving,
        'any': ExternalMapTravelMode.driving,
        'teleport': ExternalMapTravelMode.driving,
        '': ExternalMapTravelMode.driving,
        null: ExternalMapTravelMode.driving,
      };
      for (final entry in types.entries) {
        expect(ExternalMapTravelMode.fromMapKit(entry.key), entry.value, reason: '${entry.key}');
      }
    });

    test('bike is not a MapKit spelling and stays driving', () {
      expect(ExternalMapTravelMode.fromMapKit('bike'), ExternalMapTravelMode.driving);
    });
  });
}
