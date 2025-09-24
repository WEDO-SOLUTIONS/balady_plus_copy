// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late WorkingHours workingHours;
  late MockAppLocalizations appLocalizations;
  late String closedStatus;

  setUpAll(() {
    appLocalizations = MockAppLocalizations();
    when(() => appLocalizations.temporarilyClosed).thenReturn('Temporarily closed');
    when(() => appLocalizations.breakUntil).thenReturn('Break until');
    when(() => appLocalizations.closedUntill).thenReturn('Closed until');
    when(() => appLocalizations.closesIn).thenReturn('Closes in ');
    when(() => appLocalizations.minutes).thenReturn('minutes');
    when(() => appLocalizations.weekdayNameMonday).thenReturn('Monday');
    when(() => appLocalizations.tomorrow).thenReturn('tomorrow');
  });

  void createStatusFor(DateTime now) {
    closedStatus = workingHours.closedStatus(now, appLocalizations);
  }

  group('GIVEN empty working hours', () {
    setUp(() => workingHours = WorkingHours({}));
    final monday = DateTime(2025, 9, 1);

    test(
      'THEN any day is Temporary closed',
      () {
        for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
          expect(
            workingHours.closedStatus(monday.add(Duration(days: day, hours: 9)), appLocalizations),
            'Temporarily closed',
          );
        }
      },
    );
  });

  group('GIVEN working hours monday 10:00-14:00 15:00-18:00, tuesday 11:00-18:00', () {
    setUp(() => workingHours = WorkingHours({
          Duration(days: DateTime.monday, hours: 10): Duration(hours: 4),
          Duration(days: DateTime.monday, hours: 15): Duration(hours: 3),
          Duration(days: DateTime.tuesday, hours: 11): Duration(hours: 7),
        }));

    group(' WHEN not yet worked this day (before intervals)', () {
      setUp(() => createStatusFor(DateTime(2025, 9, 1, 09, 30)));
      test('THEN Closed until 10:00', () => expect(closedStatus, 'Closed until 10:00'));
    });

    group(' WHEN has break (between intervals)', () {
      setUp(() => createStatusFor(DateTime(2025, 9, 1, 14, 01)));
      test('THEN Break until 15:00', () => expect(closedStatus, 'Break until 15:00'));
    });

    group(' WHEN less than 30min before close', () {
      setUp(() => createStatusFor(DateTime(2025, 9, 1, 17, 42)));
      test('THEN Closes in 18 minutes', () => expect(closedStatus, 'Closes in 18 minutes'));
    });

    group(' WHEN tuesday already closed', () {
      setUp(() => createStatusFor(DateTime(2025, 9, 2, 21, 00)));
      test('THEN Closed until monday 10:00', () => expect(closedStatus, 'Closed until Monday 10:00'));
    });

    group('WHEN monday already closed', () {
      setUp(() => createStatusFor(DateTime(2025, 9, 1, 18, 01)));
      test('THEN Closed until tomorrow 11:00', () => expect(closedStatus, 'Closed until tomorrow 11:00'));
    });

    group('WHEN sunday not working', () {
      setUp(() => createStatusFor(DateTime(2025, 9, 7, 09, 00)));
      test('THEN Closed until tomorrow 10:00', () => expect(closedStatus, 'Closed until tomorrow 10:00'));
    });

    group('WHEN friday now working', () {
      setUp(() => createStatusFor(DateTime(2025, 9, 5, 09, 00)));
      test('THEN Closed until monday 10:00', () => expect(closedStatus, 'Closed until Monday 10:00'));
    });
  });
}

class MockAppLocalizations extends Mock implements AppLocalizations {}
