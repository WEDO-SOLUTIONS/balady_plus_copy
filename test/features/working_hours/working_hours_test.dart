// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

void main() {
  late WorkingHours workingHours;

  group('GIVEN empty working hours', () {
    setUp(() => workingHours = WorkingHours({}));

    test('THEN is temporary closed', () => expect(workingHours.isTemporaryClosed, isTrue));
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
      test(
        'THEN closes in 8h 0min',
        () => expect(workingHours.closesIn(now), Duration(hours: 8, minutes: 0)),
      );
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
      test(
        'THEN closes in 2h 18min',
        () => expect(workingHours.closesIn(now), Duration(hours: 2, minutes: 18)),
      );
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
}
