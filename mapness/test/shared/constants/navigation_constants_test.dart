import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';

/// Mirrors the SDK's speedRangeToStyleZoomSequence validation: violating any of
/// these rules makes the whole sequence silently rejected (SDK default zoom stays active).
List<String> _sdkSequenceViolations(List<SpeedRangeZoom> zooms) {
  final violations = <String>[];
  if (zooms.isEmpty) {
    return ['sequence is empty'];
  }
  if (zooms.first.minSpeedRange != 0) {
    violations.add('first minSpeedRange must be 0');
  }

  for (var i = 0; i < zooms.length - 1; i++) {
    if (zooms[i].minSpeedRange > zooms[i + 1].minSpeedRange) {
      violations.add('index $i: not sorted by minSpeedRange');
    }
    if (!(zooms[i].maxSpeedRange > zooms[i + 1].minSpeedRange)) {
      violations.add('index $i: maxSpeedRange must be > next minSpeedRange (overlap)');
    }
    if (!(zooms[i].maxSpeedRange < zooms[i + 1].maxSpeedRange)) {
      violations.add('index $i: maxSpeedRange must strictly increase');
    }
    if (i + 2 < zooms.length && zooms[i].maxSpeedRange > zooms[i + 2].minSpeedRange) {
      violations.add('index $i: maxSpeedRange must not exceed minSpeedRange two ranges ahead');
    }
    if (zooms[i].styleZoomValue < zooms[i + 1].styleZoomValue) {
      violations.add('index $i: styleZoomValue must be non-increasing');
    }
  }
  return violations;
}

void main() {
  group('NavigationConstants.navigationSpeedRangeZooms', () {
    test('satisfies the SDK speedRangeToStyleZoomSequence validation rules', () {
      final violations = _sdkSequenceViolations(NavigationConstants.navigationSpeedRangeZooms);
      expect(violations, isEmpty, reason: violations.join('; '));
    });
  });
}
