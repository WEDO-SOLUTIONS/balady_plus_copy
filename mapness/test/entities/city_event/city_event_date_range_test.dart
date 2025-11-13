import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/city_event/city_event.dart';

void main() {
  group('CityEventDateRange', () {
    test('isDateInRange', () {
      for (final tc in _testCases) {
        tc.isDateInRangeToDateMap.forEach(
          (date, expectedIsInRange) {
            expect(tc.range.isDateInRange(date), expectedIsInRange, reason: date.toString());
          },
        );
      }
    });
  });
}

class _TestCase {
  final CityEventDateRange range;

  /// maps expected bool value for CityEventDateRange.isDateInRange for specified DateTime as a key
  final Map<DateTime, bool> isDateInRangeToDateMap;

  const _TestCase({required this.range, required this.isDateInRangeToDateMap});
}

final _testCases = [
  _TestCase(
    range: CityEventDateRange(DateTime(2025, 11, 25), DateTime(2025, 11, 29)),
    isDateInRangeToDateMap: {
      DateTime(2025, 11, 24, 23, 23, 59): false,
      DateTime(2025, 11, 25): true,
      DateTime(2025, 11, 27): true,
      DateTime(2025, 11, 29): true,
      DateTime(2025, 11, 29, 23, 23, 59): true,
      DateTime(2025, 11, 30): false,
    },
  ),
];
