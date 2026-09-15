// Guards the deep-link dispatcher split: `openAppLink` routes a URI to the new
// external-map branch purely by `ExternalMapLinkParser.handlesScheme`, so every
// link shape that shipped before BE-334 must still answer `false` here and keep
// flowing to the short-link lookup and the legacy query parser.

import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/external_map_links/lib/external_map_link_parser.dart';

void main() {
  group('legacy links keep the old path', () {
    const legacyLinks = [
      // Share link whose `q` is a `lat,lon` pair — the legacy parser owns it.
      'https://plus.balady.gov.sa/#/poi-map?q=24.7,46.6',
      'https://plus.balady.gov.sa/#/poi-map?lat=24.7&lon=46.6',
      // Short links: a single path segment resolved by the short-link service.
      'https://go.balady.gov.sa/abc123',
      'http://go.balady.gov.sa/abc123',
      // Universal links and the in-app schemes.
      'https://plus.balady.gov.sa/app/snapandsend',
      'https://plus.balady.gov.sa/search?filter=food',
      'http://plus.balady.gov.sa/stories?id=42',
      'insiderbaladyapp://deeplink',
      'com.momra.balady://poi-map?q=24.7,46.6',
    ];

    for (final link in legacyLinks) {
      test('$link is not an external map link', () {
        expect(ExternalMapLinkParser.handlesScheme(Uri.parse(link).scheme), isFalse);
      });
    }
  });

  group('the new schemes are claimed', () {
    const externalLinks = [
      'baladymaps://?q=coffee',
      'baladymaps://?ll=24.7136,46.6753&label=Test&z=14',
      'BALADYMAPS://?daddr=24.6877,46.7219&mode=walking',
      'geo:24.7136,46.6753',
      'geo:0,0?q=Riyadh',
      'GEO:24.7136,46.6753',
    ];

    for (final link in externalLinks) {
      test('$link is an external map link', () {
        expect(ExternalMapLinkParser.handlesScheme(Uri.parse(link).scheme), isTrue);
      });
    }
  });
}
