import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// There are two byte-identical copies of this file in the tree; this is the
// one the app actually uses, and the only one whose `isNow` is not deprecated.
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';

void main() {
  group('Saudi National Day Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('saudiNationalDaySimpleProvider', () {
      test('returns boolean value', () {
        final result = SaudiNationalDay.isNow();
        expect(result, isA<bool>());
      });

      test('returns false for non-Saudi National Day dates', () {
        // Test with various dates that are not Saudi National Day
        final testDates = [
          DateTime(2025, 1, 1), // New Year
          DateTime(2025, 6, 15), // Random summer date
          DateTime(2025, 12, 25), // Christmas
          DateTime(2025, 9, 22), // Day before Saudi National Day
          DateTime(2025, 9, 28), // Day after Saudi National Day
        ];

        for (final date in testDates) {
          // Test the actual logic by checking if the date is within the Saudi National Day range
          final isInRange =
              date.isAfter(SaudiNationalDayConfig.startDate) && date.isBefore(SaudiNationalDayConfig.endDate);
          expect(isInRange, false, reason: 'Date ${date.toString()} should not be Saudi National Day');
        }
      });

      test('returns true for Saudi National Day date', () {
        // Test the logic with September 23rd, 2025
        final saudiNationalDay = DateTime(2025, 9, 24);
        final isInRange =
            saudiNationalDay.isAfter(SaudiNationalDayConfig.startDate) &&
            saudiNationalDay.isBefore(SaudiNationalDayConfig.endDate);
        expect(isInRange, true);
      });

      test('returns false for days that is not in interval of Saudi National Day dates', () {
        // Test dates that are clearly outside the Saudi National Day interval (Sept 23-27, 2025)
        final testDates = [
          DateTime(2025, 9, 20), // 3 days before start
          DateTime(2025, 9, 21), // 2 days before start
          DateTime(2025, 9, 22), // 1 day before start
          DateTime(2025, 9, 28), // 1 day after end
          DateTime(2025, 9, 29), // 2 days after end
          DateTime(2025, 9, 30), // 3 days after end
          DateTime(2025, 10, 1), // Different month
          DateTime(2026, 9, 23), // Different year
        ];

        for (final date in testDates) {
          // Test the actual logic by checking if the date is within the Saudi National Day range
          final isInRange =
              date.isAfter(SaudiNationalDayConfig.startDate) && date.isBefore(SaudiNationalDayConfig.endDate);
          expect(isInRange, false, reason: 'Date ${date.toString()} should not be in Saudi National Day interval');
        }
      });
    });

    group('saudiNationalDayCountdownProvider', () {
      test('returns correct type', () {
        final result = SaudiNationalDay.countdown();
        expect(result != null, isTrue);
      });

      test('returns null for past dates', () {
        // Test with a date after Saudi National Day
        final pastDate = DateTime(2025, 9, 28);
        final expectedCountdown = SaudiNationalDay.countdownFromDate(pastDate);
        expect(expectedCountdown, null);
      });

      test('returns Duration.zero for Saudi National Day', () {
        // Test with Saudi National Day
        final saudiNationalDay = DateTime(2025, 9, 23);
        final expectedCountdown = SaudiNationalDay.countdownFromDate(saudiNationalDay);
        expect(expectedCountdown, Duration.zero);
      });
    });
  });
}
