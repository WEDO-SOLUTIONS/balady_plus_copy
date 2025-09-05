// ignore_for_file: prefer_const_constructors

import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_from_opening_hours_message.dart';

void main() {
  late OpeningHoursMessage openingHoursMessage;
  late WorkingHours workingHours;

  group('GIVEN working hours ends on next day. Monday 08:00-01:00(next day)', () {
    setUp(() {
      openingHoursMessage = OpeningHoursMessage(
        isOpen24x7: false,
        values: [
          WeekTimeIntervalListMessage(
            values: [
              WeekTimeIntervalMessage(
                startTime: WeekTimeMessage(weekDay: WeekDayMessage.monday, time: DayTimeMessage(hours: 8, minutes: 0)),
                finishTime: WeekTimeMessage(weekDay: WeekDayMessage.monday, time: DayTimeMessage(hours: 1, minutes: 0)),
              ),
            ],
          ),
        ],
      );
    });

    group('WHEN map', () {
      setUp(() => workingHours = openingHoursMessage.toWorkingHours());

      test('THEN working hours mapped well', () {
        final key = Duration(days: DateTime.monday, hours: 8);
        expect(workingHours.map.containsKey(key), isTrue);
        expect(workingHours.map[key], Duration(hours: 17));
      });
    });
  });

  group('GIVEN is24x7 AND empty values', () {
    setUp(() {
      openingHoursMessage = OpeningHoursMessage(
        isOpen24x7: true,
        values: [],
      );
    });

    group('WHEN map', () {
      setUp(() => workingHours = openingHoursMessage.toWorkingHours());

      test('THEN monday to sunday(every day) working 00:00-24:00', () {
        for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
          final opening = Duration(days: DateTime.monday, hours: 0);
          expect(workingHours.map.containsKey(opening), isTrue);
          expect(workingHours.map[opening], Duration(hours: 24));
        }
      });
    });
  });
}
