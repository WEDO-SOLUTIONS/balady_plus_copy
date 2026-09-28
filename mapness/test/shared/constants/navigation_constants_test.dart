import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';

/// Guards against silently dropping the SDK's speedRangeToStyleZoomSequence:
/// see the invariants documented at NavigationConstants.navigationSpeedRangeZooms.
void main() {
  group('NavigationConstants.navigationSpeedRangeZooms', () {
    final zooms = NavigationConstants.navigationSpeedRangeZooms;

    test('is not empty and starts at speed 0', () {
      expect(zooms, isNotEmpty);
      expect(zooms.first.minSpeedRange, 0);
    });

    test('consecutive ranges are sorted by minSpeedRange', () {
      for (var i = 0; i < zooms.length - 1; i++) {
        expect(zooms[i].minSpeedRange, lessThanOrEqualTo(zooms[i + 1].minSpeedRange));
      }
    });

    test('consecutive ranges overlap (maxSpeedRange[i] > minSpeedRange[i+1])', () {
      for (var i = 0; i < zooms.length - 1; i++) {
        expect(zooms[i].maxSpeedRange, greaterThan(zooms[i + 1].minSpeedRange));
      }
    });

    test('maxSpeedRange strictly increases', () {
      for (var i = 0; i < zooms.length - 1; i++) {
        expect(zooms[i].maxSpeedRange, lessThan(zooms[i + 1].maxSpeedRange));
      }
    });

    test('styleZoomValue is non-increasing as speed grows', () {
      for (var i = 0; i < zooms.length - 1; i++) {
        expect(zooms[i].styleZoomValue, greaterThanOrEqualTo(zooms[i + 1].styleZoomValue));
      }
    });
  });
}
