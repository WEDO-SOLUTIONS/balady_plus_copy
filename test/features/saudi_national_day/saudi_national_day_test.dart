import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_config.dart';

void main() {
  group('SaudiNationalDayRemoteConfig', () {
    SaudiNationalDayRemoteConfig configWith({bool enabled = true, bool appIconEnabled = true}) =>
        SaudiNationalDayRemoteConfig(
          enabled: enabled,
          startDate: DateTime(2026, 9, 22),
          endDate: DateTime(2026, 9, 24, 23, 59, 59),
          anniversary: 96,
          appIconEnabled: appIconEnabled,
        );

    group('isActiveAt', () {
      test('is active on every day of the window, including both bounds', () {
        final config = configWith();

        expect(config.isActiveAt(DateTime(2026, 9, 22)), isTrue, reason: 'start bound is inclusive');
        expect(config.isActiveAt(DateTime(2026, 9, 23, 12)), isTrue);
        expect(config.isActiveAt(DateTime(2026, 9, 24, 23, 59, 58)), isTrue, reason: 'end bound is inclusive');
      });

      test('is inactive outside the window', () {
        final config = configWith();

        final outside = [
          DateTime(2026, 9, 21, 23, 59, 59), // moment before start
          DateTime(2026, 9, 25), // moment after end
          DateTime(2026, 1, 1),
          DateTime(2025, 9, 23), // last year's National Day
          DateTime(2027, 9, 23), // next year's
        ];

        for (final date in outside) {
          expect(config.isActiveAt(date), isFalse, reason: '$date should be outside the window');
        }
      });

      test('the enabled flag kills the theme without moving the dates', () {
        final config = configWith(enabled: false);
        expect(config.isActiveAt(DateTime(2026, 9, 23)), isFalse);
      });
    });

    group('isAppIconActiveAt', () {
      test('requires both the window and the icon gate', () {
        final midWindow = DateTime(2026, 9, 23);

        expect(configWith().isAppIconActiveAt(midWindow), isTrue);
        expect(configWith(appIconEnabled: false).isAppIconActiveAt(midWindow), isFalse);
        expect(configWith(enabled: false).isAppIconActiveAt(midWindow), isFalse);
      });

      test('is inactive outside the window even when the icon gate is on', () {
        expect(configWith().isAppIconActiveAt(DateTime(2026, 9, 25)), isFalse);
      });
    });

    group('CityEventDateRange mapping', () {
      // Mirrors the mapping in saudiNationalDayResolvedConfigProvider: the
      // remote `to` is an inclusive date-only bound, so it must be extended
      // to the last instant of that day.
      SaudiNationalDayRemoteConfig fromRange(CityEventDateRange range) => SaudiNationalDayRemoteConfig(
        enabled: range.enabled ?? true,
        startDate: DateTime(range.from.year, range.from.month, range.from.day),
        endDate: DateTime(range.to.year, range.to.month, range.to.day, 23, 59, 59),
        anniversary: SaudiNationalDayRemoteConfig.bundledDefault.anniversary,
        appIconEnabled: SaudiNationalDayRemoteConfig.bundledDefault.appIconEnabled,
      );

      test('parses the dd-MM-yy remote format used by app_env_config', () {
        final range = CityEventDateRange.fromJson({
          'from': '22-09-26',
          'to': '24-09-26',
          'enabled': true,
        }, CityEventDateRange.saudiNationalDayDefault());

        expect(range.from, DateTime(2026, 9, 22));
        expect(range.to, DateTime(2026, 9, 24));
      });

      test('keeps the whole final day of the window active', () {
        final config = fromRange(CityEventDateRange(DateTime(2026, 9, 22), DateTime(2026, 9, 24)));

        expect(config.isActiveAt(DateTime(2026, 9, 24, 20)), isTrue, reason: 'last day must stay active');
        expect(config.isActiveAt(DateTime(2026, 9, 25)), isFalse);
      });

      test('an absent enabled flag means "just use the dates"', () {
        final config = fromRange(CityEventDateRange(DateTime(2026, 9, 22), DateTime(2026, 9, 24)));

        expect(config.enabled, isTrue);
        expect(config.isActiveAt(DateTime(2026, 9, 23)), isTrue);
      });

      test('enabled:false switches the theme off inside its own window', () {
        final config = fromRange(CityEventDateRange(DateTime(2026, 9, 22), DateTime(2026, 9, 24), enabled: false));

        expect(config.isActiveAt(DateTime(2026, 9, 23)), isFalse);
      });

      test('falls back to the bundled default when the remote key is absent', () {
        final range = CityEventDateRange.fromJson(null, CityEventDateRange.saudiNationalDayDefault());

        // The shipped default is year-relative, so it must at least parse and
        // produce a usable window rather than throwing.
        expect(range.from.month, 9);
        expect(range.to.month, 9);
      });
    });

    group('bundled default', () {
      test('targets the 2026 window agreed for this release', () {
        final config = SaudiNationalDayRemoteConfig.bundledDefault;

        expect(config.startDate, DateTime(2026, 9, 22));
        expect(config.endDate, DateTime(2026, 9, 24, 23, 59, 59));
        expect(config.anniversary, 96);
        expect(config.isActiveAt(DateTime(2026, 9, 23)), isTrue);
      });
    });
  });
}
