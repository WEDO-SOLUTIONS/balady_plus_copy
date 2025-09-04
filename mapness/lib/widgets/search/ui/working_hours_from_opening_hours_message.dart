import 'package:dgis_map/library.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

extension WorkingHoursFromOpeningHoursMessage on OpeningHoursMessage {
  WorkingHours toWorkingHours() {
    if (isOpen24x7) {
      return WorkingHours(
        Map.fromEntries(
          [
            for (int day = DateTime.monday; day <= DateTime.sunday; day++)
              const MapEntry(Duration.zero, Duration(hours: 24)),
          ],
        ),
      );
    }

    final flatWeekTimeIntervals =
    values.fold(<WeekTimeIntervalMessage>[], (combined, value) => [...combined, ...value.values]);
    final map = Map.fromEntries(flatWeekTimeIntervals.map((weekTimeInterval) => weekTimeInterval.mapEntry));
    return WorkingHours(map);
  }
}

extension on WeekTimeIntervalMessage {
  MapEntry<Duration, Duration> get mapEntry {
    final start = startTime.duration;
    final finish = finishTime.duration;
    final effectiveFinish = finish < start ? finish + const Duration(days: 1) : finish;
    final duration = effectiveFinish - start;
    return MapEntry(start, duration);
  }
}

extension on WeekDayMessage {
  int toDateTimeWeekday() =>
      switch (this) {
        WeekDayMessage.monday => DateTime.monday,
        WeekDayMessage.tuesday => DateTime.tuesday,
        WeekDayMessage.wednesday => DateTime.wednesday,
        WeekDayMessage.thursday => DateTime.thursday,
        WeekDayMessage.friday => DateTime.friday,
        WeekDayMessage.saturday => DateTime.saturday,
        WeekDayMessage.sunday => DateTime.sunday,
      };
}

extension on WeekTimeMessage {
  Duration get duration =>
      Duration(
        days: weekDay.toDateTimeWeekday(),
        hours: time.hours,
        minutes: time.minutes,
      );
}
