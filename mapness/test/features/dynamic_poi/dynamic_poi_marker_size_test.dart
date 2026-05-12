import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_marker_size.dart';

void main() {
  group('sizeForZoom with default thresholds (medium=13, large=18)', () {
    test('zoom below medium → small', () {
      expect(sizeForZoom(0), DynamicPoiMarkerSize.small);
      expect(sizeForZoom(12.99), DynamicPoiMarkerSize.small);
    });

    test('zoom at medium threshold → medium (inclusive lower bound)', () {
      expect(sizeForZoom(13), DynamicPoiMarkerSize.medium);
      expect(sizeForZoom(15), DynamicPoiMarkerSize.medium);
      expect(sizeForZoom(17.99), DynamicPoiMarkerSize.medium);
    });

    test('zoom at large threshold → large', () {
      expect(sizeForZoom(18), DynamicPoiMarkerSize.large);
      expect(sizeForZoom(22), DynamicPoiMarkerSize.large);
      expect(sizeForZoom(100), DynamicPoiMarkerSize.large);
    });
  });

  group('sizeForZoom with custom thresholds', () {
    const tight = DynamicPoiSizeThresholds(medium: 10, large: 14);

    test('uses provided thresholds verbatim', () {
      expect(sizeForZoom(9.99, thresholds: tight), DynamicPoiMarkerSize.small);
      expect(sizeForZoom(10, thresholds: tight), DynamicPoiMarkerSize.medium);
      expect(sizeForZoom(13.99, thresholds: tight), DynamicPoiMarkerSize.medium);
      expect(sizeForZoom(14, thresholds: tight), DynamicPoiMarkerSize.large);
    });
  });
}
