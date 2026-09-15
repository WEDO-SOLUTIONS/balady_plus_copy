import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/external_map_links/lib/external_map_link_parser.dart';
import 'package:mapness/features/external_map_links/models/external_map_link_intent.dart';

void main() {
  group('ExternalMapLinkParser.handlesScheme', () {
    test('claims the two map schemes, case-insensitively', () {
      for (final scheme in ['baladymaps', 'geo', 'BALADYMAPS', 'GEO', 'BaladyMaps', 'Geo']) {
        expect(ExternalMapLinkParser.handlesScheme(scheme), isTrue, reason: scheme);
      }
    });

    test('leaves every existing link to the legacy handler', () {
      for (final scheme in ['https', 'http', 'insiderbaladyapp', 'com.momra.balady', '']) {
        expect(ExternalMapLinkParser.handlesScheme(scheme), isFalse, reason: scheme);
      }
    });
  });

  group('baladymaps:// search', () {
    test('q yields a search without a bias', () {
      final intent = _parse<ExternalMapSearchIntent>('baladymaps://?q=coffee');
      expect(intent.query, 'coffee');
      expect(intent.near, isNull);
    });

    test('text is an alias of q', () {
      final intent = _parse<ExternalMapSearchIntent>('baladymaps://?text=coffee%20shop');
      expect(intent.query, 'coffee shop');
    });

    test('query keys are case-insensitive', () {
      expect(_parse<ExternalMapSearchIntent>('baladymaps://?Q=coffee').query, 'coffee');
    });

    test('the query is trimmed', () {
      expect(_parse<ExternalMapSearchIntent>('baladymaps://?q=%20%20coffee%20%20').query, 'coffee');
    });

    test('arabic survives the single utf-8 decode', () {
      final intent = _parse<ExternalMapSearchIntent>(
        'baladymaps://?q=%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6',
      );
      expect(intent.query, 'الرياض');
    });

    test('escaped separators stay inside the query', () {
      final intent = _parse<ExternalMapSearchIntent>('baladymaps://?q=Caf%C3%A9%20%26%20Bar%2C%20Riyadh');
      expect(intent.query, 'Café & Bar, Riyadh');
    });

    test('percent signs are decoded exactly once', () {
      // Double decoding would turn this into 'الرياض'.
      final intent = _parse<ExternalMapSearchIntent>('baladymaps://?q=%25D8%25A7%25D9%2584');
      expect(intent.query, '%D8%A7%D9%84');
    });

    test('a valid near becomes the search bias', () {
      final intent = _parse<ExternalMapSearchIntent>('baladymaps://?q=coffee&near=24.7136,46.6753');
      _expectPoint(intent.near, 24.7136, 46.6753);
    });

    test('an out-of-range near is dropped but the search still runs', () {
      final intent = _parse<ExternalMapSearchIntent>('baladymaps://?q=coffee&near=91.0,46.6753');
      expect(intent.query, 'coffee');
      expect(intent.near, isNull);
    });

    test('a malformed near is dropped but the search still runs', () {
      for (final near in ['abc', '24.7136', '24,7136', '24.7136,181.0']) {
        final intent = _parse<ExternalMapSearchIntent>('baladymaps://?q=coffee&near=$near');
        expect(intent.near, isNull, reason: near);
      }
    });
  });

  group('baladymaps:// point', () {
    test('ll alone opens the point card', () {
      final intent = _parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7136,46.6753');
      _expectPoint(intent.point, 24.7136, 46.6753);
      expect(intent.label, isNull);
      expect(intent.zoom, isNull);
    });

    test('label and zoom are carried over', () {
      final intent = _parse<ExternalMapShowLocationIntent>(
        'baladymaps://?ll=24.7136,46.6753&label=Balady%20HQ&z=14',
      );
      expect(intent.label, 'Balady HQ');
      expect(intent.zoom, 14);
    });

    test('signed coordinates are accepted', () {
      // `%2B` keeps a literal plus: a bare `+` decodes to a space in a query.
      final intent = _parse<ExternalMapShowLocationIntent>('baladymaps://?ll=-33.85,%2B151.21');
      _expectPoint(intent.point, -33.85, 151.21);
    });

    test('zoom is clamped into 1..20 and dropped when unparsable', () {
      expect(_parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7,46.6&z=0').zoom, 1);
      expect(_parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7,46.6&z=99').zoom, 20);
      expect(_parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7,46.6&z=13.5').zoom, 13.5);
      expect(_parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7,46.6&z=abc').zoom, isNull);
      expect(_parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7,46.6&z=').zoom, isNull);
    });

    test('a blank label is dropped and a long one is truncated', () {
      expect(_parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7,46.6&label=%20%20').label, isNull);

      final long = 'x' * 200;
      final intent = _parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7,46.6&label=$long');
      expect(intent.label, hasLength(ExternalMapLinkParser.maxLabelLength));
    });

    test('a malformed ll kills the whole link', () {
      const malformed = [
        '24,7136', // comma decimal separator
        '%D9%A2%D9%A4.%D9%A7%D9%A1%D9%A3%D9%A6,%D9%A4%D9%A6.%D9%A6%D9%A7%D9%A5%D9%A3', // arabic-indic digits
        '24.7136', // single component
        '91.0,46.6753', // |lat| > 90
        '24.7136,181.0', // |lng| > 180
        'abc',
        '24.7136;46.6753',
      ];
      for (final ll in malformed) {
        expect(_intent('baladymaps://?ll=$ll'), isNull, reason: ll);
      }
    });

    test('a malformed ll is never downgraded to the q search', () {
      expect(_intent('baladymaps://?ll=abc&q=coffee'), isNull);
    });

    test('ll wins over q', () {
      final intent = _parse<ExternalMapShowLocationIntent>('baladymaps://?ll=24.7136,46.6753&q=coffee');
      _expectPoint(intent.point, 24.7136, 46.6753);
    });
  });

  group('baladymaps:// directions', () {
    test('a coordinate daddr routes to that point from my location', () {
      final intent = _parse<ExternalMapDirectionsIntent>('baladymaps://?daddr=24.6877,46.7219');
      final destination = intent.destination;
      expect(destination, isA<ExternalMapPlacePoint>());
      _expectPoint((destination as ExternalMapPlacePoint).point, 24.6877, 46.7219);
      expect(intent.source, isNull);
      expect(intent.mode, ExternalMapTravelMode.driving);
    });

    test('a free-text daddr stays text for the geocoder', () {
      final intent = _parse<ExternalMapDirectionsIntent>('baladymaps://?daddr=Kingdom%20Centre%2C%20Riyadh');
      final destination = intent.destination;
      expect(destination, isA<ExternalMapPlaceQuery>());
      expect((destination as ExternalMapPlaceQuery).query, 'Kingdom Centre, Riyadh');
    });

    test('saddr current or empty means my location', () {
      for (final saddr in ['current', 'Current', 'CURRENT', '', '%20']) {
        final intent = _parse<ExternalMapDirectionsIntent>('baladymaps://?daddr=24.6877,46.7219&saddr=$saddr');
        expect(intent.source, isNull, reason: 'saddr=$saddr');
      }
    });

    test('a coordinate saddr becomes the route start', () {
      final intent = _parse<ExternalMapDirectionsIntent>(
        'baladymaps://?daddr=24.6877,46.7219&saddr=24.7136,46.6753',
      );
      final source = intent.source;
      expect(source, isA<ExternalMapPlacePoint>());
      _expectPoint((source! as ExternalMapPlacePoint).point, 24.7136, 46.6753);
    });

    test('a free-text saddr stays text', () {
      final intent = _parse<ExternalMapDirectionsIntent>('baladymaps://?daddr=24.6877,46.7219&saddr=Olaya');
      expect((intent.source! as ExternalMapPlaceQuery).query, 'Olaya');
    });

    test('mode tokens map onto the travel modes, unknown falls back to driving', () {
      const cases = <String, ExternalMapTravelMode>{
        'walking': ExternalMapTravelMode.walking,
        'transit': ExternalMapTravelMode.transit,
        'bicycle': ExternalMapTravelMode.bicycle,
        'hovercraft': ExternalMapTravelMode.driving,
        'driving': ExternalMapTravelMode.driving,
      };
      for (final entry in cases.entries) {
        final intent = _parse<ExternalMapDirectionsIntent>(
          'baladymaps://?daddr=24.6877,46.7219&mode=${entry.key}',
        );
        expect(intent.mode, entry.value, reason: entry.key);
      }
    });

    test('an absent mode is driving', () {
      expect(
        _parse<ExternalMapDirectionsIntent>('baladymaps://?daddr=24.6877,46.7219').mode,
        ExternalMapTravelMode.driving,
      );
    });

    test('daddr wins over ll and q', () {
      final intent = _parse<ExternalMapDirectionsIntent>(
        'baladymaps://?daddr=24.6877,46.7219&ll=24.7136,46.6753&q=coffee',
      );
      expect(intent.destination, isA<ExternalMapPlacePoint>());
    });
  });

  group('baladymaps:// malformed', () {
    test('a bare scheme has nothing to open', () {
      expect(_intent('baladymaps://'), isNull);
      expect(_intent('baladymaps:'), isNull);
    });

    test('unknown or empty parameters are ignored', () {
      expect(_intent('baladymaps://?foo=bar'), isNull);
      expect(_intent('baladymaps://?q=&text='), isNull);
      expect(_intent('baladymaps://?near=24.7136,46.6753'), isNull);
    });
  });

  group('geo:', () {
    test('a bare pair opens the point card', () {
      final intent = _parse<ExternalMapShowLocationIntent>('geo:24.7136,46.6753');
      _expectPoint(intent.point, 24.7136, 46.6753);
      expect(intent.label, isNull);
      expect(intent.zoom, isNull);
    });

    test('the z parameter is honoured and clamped', () {
      expect(_parse<ExternalMapShowLocationIntent>('geo:24.7136,46.6753?z=14').zoom, 14);
      expect(_parse<ExternalMapShowLocationIntent>('geo:24.7136,46.6753?z=99').zoom, 20);
    });

    test('the uncertainty suffix and the altitude component are stripped', () {
      _expectPoint(_parse<ExternalMapShowLocationIntent>('geo:24.7136,46.6753;u=35').point, 24.7136, 46.6753);
      _expectPoint(_parse<ExternalMapShowLocationIntent>('geo:24.7136,46.6753,120').point, 24.7136, 46.6753);
      _expectPoint(
        _parse<ExternalMapShowLocationIntent>('geo:24.7136,46.6753,120;u=35?z=99').point,
        24.7136,
        46.6753,
      );
    });

    test('q carrying a pair opens the point card', () {
      final intent = _parse<ExternalMapShowLocationIntent>('geo:0,0?q=24.7136,46.6753');
      _expectPoint(intent.point, 24.7136, 46.6753);
      expect(intent.label, isNull);
    });

    test('q carrying a labelled pair keeps the label', () {
      final intent = _parse<ExternalMapShowLocationIntent>('geo:0,0?q=24.7136,46.6753(Balady%20HQ)&z=17');
      _expectPoint(intent.point, 24.7136, 46.6753);
      expect(intent.label, 'Balady HQ');
      expect(intent.zoom, 17);
    });

    test('a label may contain commas and brackets', () {
      final intent = _parse<ExternalMapShowLocationIntent>(
        'geo:0,0?q=24.7136,46.6753(Coffee%2C%20Corner%20(2nd%20floor))',
      );
      _expectPoint(intent.point, 24.7136, 46.6753);
      expect(intent.label, 'Coffee, Corner (2nd floor)');
    });

    test('q carrying an address searches without a bias when the path is 0,0', () {
      final intent = _parse<ExternalMapSearchIntent>(
        'geo:0,0?q=%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6',
      );
      expect(intent.query, 'الرياض');
      expect(intent.near, isNull);
    });

    test('q carrying an address is biased by the path point', () {
      final intent = _parse<ExternalMapSearchIntent>('geo:24.7136,46.6753?q=coffee');
      expect(intent.query, 'coffee');
      _expectPoint(intent.near, 24.7136, 46.6753);
    });

    test('an unusable path point does not bias the search', () {
      expect(_parse<ExternalMapSearchIntent>('geo:abc?q=coffee').near, isNull);
    });

    test('malformed or empty geo links are ignored', () {
      for (final link in ['geo:', 'geo:abc', 'geo:0,0', 'geo:0,0?q=', 'geo:24.7136', 'geo:91.0,46.6753']) {
        expect(_intent(link), isNull, reason: link);
      }
    });
  });

  group('helpers', () {
    test('parseCoordinatePair accepts only dot decimals and ascii digits', () {
      _expectPoint(ExternalMapLinkParser.parseCoordinatePair(' 24.7136 , 46.6753 '), 24.7136, 46.6753);
      expect(ExternalMapLinkParser.parseCoordinatePair('24,7136'), isNull);
      expect(ExternalMapLinkParser.parseCoordinatePair('٢٤.٧١٣٦,٤٦.٦٧٥٣'), isNull);
      expect(ExternalMapLinkParser.parseCoordinatePair('24.7136'), isNull);
      expect(ExternalMapLinkParser.parseCoordinatePair('abc'), isNull);
      expect(ExternalMapLinkParser.parseCoordinatePair(null), isNull);
      expect(ExternalMapLinkParser.parseCoordinatePair('90.0,180.0'), isNotNull);
      expect(ExternalMapLinkParser.parseCoordinatePair('-90.0,-180.0'), isNotNull);
    });

    test('parseCoordinateWithLabel splits the label off the pair', () {
      final place = ExternalMapLinkParser.parseCoordinateWithLabel('24.7136,46.6753(Home, sweet home)');
      expect(place, isNotNull);
      _expectPoint(place!.point, 24.7136, 46.6753);
      expect(place.label, 'Home, sweet home');

      expect(ExternalMapLinkParser.parseCoordinateWithLabel('24.7136,46.6753()')?.label, isNull);
      expect(ExternalMapLinkParser.parseCoordinateWithLabel('Riyadh'), isNull);
      expect(ExternalMapLinkParser.parseCoordinateWithLabel(null), isNull);
    });

    test('parseZoom clamps and rejects', () {
      expect(ExternalMapLinkParser.parseZoom('0'), ExternalMapLinkParser.minZoom);
      expect(ExternalMapLinkParser.parseZoom('-5'), ExternalMapLinkParser.minZoom);
      expect(ExternalMapLinkParser.parseZoom('99'), ExternalMapLinkParser.maxZoom);
      expect(ExternalMapLinkParser.parseZoom(' 12 '), 12);
      expect(ExternalMapLinkParser.parseZoom('abc'), isNull);
      expect(ExternalMapLinkParser.parseZoom('NaN'), isNull);
      expect(ExternalMapLinkParser.parseZoom('Infinity'), isNull);
      expect(ExternalMapLinkParser.parseZoom(null), isNull);
    });
  });
}

ExternalMapLinkIntent? _intent(String link) => ExternalMapLinkParser.parse(Uri.parse(link));

T _parse<T extends ExternalMapLinkIntent>(String link) {
  final intent = _intent(link);
  expect(intent, isA<T>(), reason: link);
  return intent! as T;
}

void _expectPoint(ExternalMapPoint? point, double latitude, double longitude) {
  expect(point, isNotNull);
  expect(point!.latitude, closeTo(latitude, 1e-9));
  expect(point.longitude, closeTo(longitude, 1e-9));
}
