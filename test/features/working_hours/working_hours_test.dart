// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

void main() {
  late WorkingHours workingHours;

  group('GIVEN empty working hours', () {
    setUp(() => workingHours = WorkingHours({}));

    test('THEN is temporary closed', () => expect(workingHours.isTemporaryClosed, isTrue));
  });

  group('GIVEN working hours every day 10:00-14:00 15:00-18:00', () {
    late Iterable<Hours> dayHours;
    late Iterable<Hours> dayBreaks;
    setUp(() {
      workingHours = WorkingHours({
        for (int weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++)
          Duration(days: weekday, hours: 10): Duration(hours: 4),
        for (int weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++)
          Duration(days: weekday, hours: 15): Duration(hours: 3),
      });
    });

    test('THEN has same working hours', () => expect(workingHours.isSameEveryDay, isTrue));

    group('WHEN monday', () {
      setUp(() {
        dayHours = workingHours.todayHours(DateTime.monday);
        dayBreaks = workingHours.todayBreaks(DateTime.monday);
      });
      test(
        'THEN works 10:00-14:00 15:00-18:00',
        () => expect(dayHours, [
          (from: Duration(hours: 10), till: Duration(hours: 14)),
          (from: Duration(hours: 15), till: Duration(hours: 18)),
        ]),
      );
      test(
        'THEN breaks 14:00-15:00',
        () => expect(dayBreaks, [(from: Duration(hours: 14), till: Duration(hours: 15))]),
      );
    });
  });

  group('GIVEN works 7 days 24 hours', () {
    setUp(() {
      workingHours = WorkingHours({
        for (int weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++)
          Duration(days: weekday, hours: 0): Duration(hours: 24),
      });
    });

    test('THEN same working hours every day', () => expect(workingHours.isSameEveryDay, isTrue));
    test('THEN is open 24/7', () => expect(workingHours.isOpen24x7, isTrue));
  });

  group('GIVEN working hours monday 10:00-14:00 15:00-18:00, tuesday 11:00-18:00', () {
    setUp(
      () => workingHours = WorkingHours({
        Duration(days: DateTime.monday, hours: 10): Duration(hours: 4),
        Duration(days: DateTime.monday, hours: 15): Duration(hours: 3),
        Duration(days: DateTime.tuesday, hours: 11): Duration(hours: 7),
      }),
    );

    late DateTime now;

    group('WHEN is tuesday', () {
      late Iterable<Hours> periods;
      setUp(() => periods = workingHours.todayHours(DateTime.tuesday));

      test('THEN works 11:00-18:00', () => expect(periods, [(from: Duration(hours: 11), till: Duration(hours: 18))]));
      test('THEN NOT same working hours', () => expect(workingHours.isSameEveryDay, isFalse));
      test('THEN NOT open 24/7', () => expect(workingHours.isOpen24x7, isFalse));
    });

    group(' WHEN not yet worked this day (before intervals)', () {
      setUp(() => now = DateTime(2025, 9, 1, 09, 30));
      test('THEN NOT open', () => expect(workingHours.isOpen(now), isFalse));
      test('THEN is closed', () => expect(workingHours.isClosed(now), isTrue));
      test('THEN NOT break', () => expect(workingHours.isBreak(now), isFalse));
      test(
        'THEN closed until monday 10:00',
        () => expect(workingHours.nextOpen(now), Duration(days: DateTime.monday, hours: 10)),
      );
    });

    group(' WHEN working (in first interval)', () {
      setUp(() => now = DateTime(2025, 9, 1, 10, 00));
      test('THEN is open', () => expect(workingHours.isOpen(now), isTrue));
      test('THEN NOT closed', () => expect(workingHours.isClosed(now), isFalse));
      test('THEN NOT break', () => expect(workingHours.isBreak(now), isFalse));
      test('THEN closes in 4h 0min', () => expect(workingHours.closesIn(now), Duration(hours: 4, minutes: 0)));
    });

    group(' WHEN has break (between intervals)', () {
      setUp(() => now = DateTime(2025, 9, 1, 14, 01));
      test('THEN NOT open', () => expect(workingHours.isOpen(now), isFalse));
      test('THEN is closed', () => expect(workingHours.isClosed(now), isTrue));
      test('THEN is break', () => expect(workingHours.isBreak(now), isTrue));
      test(
        'THEN break until 15:00',
        () => expect(workingHours.nextOpen(now), Duration(days: DateTime.monday, hours: 15, minutes: 0)),
      );
    });

    group(' WHEN working (in last interval)', () {
      setUp(() => now = DateTime(2025, 9, 1, 15, 42));
      test('THEN is open', () => expect(workingHours.isOpen(now), isTrue));
      test('THEN NOT closed', () => expect(workingHours.isClosed(now), isFalse));
      test('THEN NOT break', () => expect(workingHours.isBreak(now), isFalse));
      test('THEN closes in 2h 18min', () => expect(workingHours.closesIn(now), Duration(hours: 2, minutes: 18)));
    });

    group(' WHEN already closed (after intervals)', () {
      setUp(() => now = DateTime(2025, 9, 1, 18, 01));
      test('THEN NOT open', () => expect(workingHours.isOpen(now), isFalse));
      test('THEN is closed', () => expect(workingHours.isClosed(now), isTrue));
      test('THEN NOT break', () => expect(workingHours.isBreak(now), isFalse));
      test('THEN closes in 0', () => expect(workingHours.closesIn(now), Duration.zero));
      test(
        'THEN closed until tuesday 11:00',
        () => expect(workingHours.nextOpen(now), Duration(days: DateTime.tuesday, hours: 11)),
      );
      test(
        'THEN closed until tomorrow',
        () => expect(workingHours.isTomorrow(now, workingHours.nextOpen(now)), isTrue),
      );
    });

    group(' WHEN tuesday already closed', () {
      setUp(() => now = DateTime(2025, 9, 2, 21, 00));
      test(
        'THEN closed until monday 10:00',
        () => expect(workingHours.nextOpen(now), Duration(days: DateTime.monday, hours: 10)),
      );
      test(
        'THEN NOT opening tomorrow',
        () => expect(workingHours.isTomorrow(now, workingHours.nextOpen(now)), isFalse),
      );
    });
  });

  group('GIVEN working hours monday 22:00-02:00 (cross-midnight)', () {
    setUp(() => workingHours = WorkingHours({Duration(days: DateTime.monday, hours: 22): Duration(hours: 4)}));

    test('THEN monday 23:00 is open', () {
      expect(workingHours.isOpen(DateTime(2025, 9, 1, 23, 00)), isTrue);
    });

    test('THEN tuesday 01:00 is still open', () {
      expect(workingHours.isOpen(DateTime(2025, 9, 2, 01, 00)), isTrue);
    });

    test('THEN tuesday 01:00 closes in 1h', () {
      expect(workingHours.closesIn(DateTime(2025, 9, 2, 01, 00)), const Duration(hours: 1));
    });

    test('THEN tuesday 03:00 is closed and next open is monday 22:00', () {
      final now = DateTime(2025, 9, 2, 03, 00);
      expect(workingHours.isClosed(now), isTrue);
      expect(workingHours.nextOpen(now), const Duration(days: DateTime.monday, hours: 22));
    });
  });

  group('GIVEN threshold-based status states', () {
    setUp(() => workingHours = WorkingHours({Duration(days: DateTime.monday, hours: 10): Duration(hours: 8)}));

    test('THEN before opening and <=2h is closedSoon', () {
      final status = workingHours.statusType(DateTime(2025, 9, 1, 09, 10));
      expect(status, WorkingHoursStatusType.closedSoon);
    });

    test('THEN while open and >2h is open', () {
      final status = workingHours.statusType(DateTime(2025, 9, 1, 12, 00));
      expect(status, WorkingHoursStatusType.open);
    });

    test('THEN before close and <=2h is openSoon', () {
      final status = workingHours.statusType(DateTime(2025, 9, 1, 16, 10));
      expect(status, WorkingHoursStatusType.openSoon);
    });
  });
}
