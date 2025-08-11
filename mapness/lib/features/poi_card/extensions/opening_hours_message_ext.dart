import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_working_time.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/features/poi_card/extensions/week_day_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension OpeningHoursMessageExt on OpeningHoursMessage {
  List<OpenHours> getDisplayOpenHours(
    AppLocalizations locale, {
    bool? format24,
  }) {
    try {
      // [WeekTimeIntervalMessage] list with start and finish time for each weekday
      final listOfIntervals =
          values.where((e) => e.values.isNotEmpty == true).map((e) => e.values.firstOrNull).toList();

      final allWeekDayNames = DateTimeExt.getAllWeekDayNames(locale);

      final allWeekDays = allWeekDayNames.map((weekDay) {
        // Interval of this current [weekDay] with start and finish time
        final intlWeekDay = listOfIntervals.firstWhereOrNull(
          (interval) {
            if (interval == null) {
              return false;
            }
            return interval.startTime.weekDay.displayName(locale) == weekDay;
          },
        );

        final openHour = _displayTime(time: intlWeekDay?.startTime.time);

        final closeHour = _displayTime(time: intlWeekDay?.finishTime.time);

        final isWeekend = openHour == null || closeHour == null;

        return OpenHours(
          isWeekend: isWeekend,
          weekDay: toBeginningOfSentenceCase(weekDay)!,
          openHour: openHour,
          closeHour: closeHour,
        );
      });
      return allWeekDays.toList();
    } catch (e) {
      debugPrint('OPEN TIME EXCEPTION: $e');
      return <OpenHours>[];
    }
  }

  bool defineIsDailySameOpenHours(AppLocalizations locale) {
    final groupListsBy = getDisplayOpenHours(locale, format24: true).groupListsBy(
      (element) => '${element.openHour}${element.closeHour}',
    );
    return groupListsBy.length == 1;
  }
}

/// Here we format the data to the String that will be shown to the user
/// [format24] is the parameter that changes format from e.g. 12:30 to 01:30 PM
/// [time] is the class with data
String? _displayTime({required DayTimeMessage? time, bool format24 = true}) {
  if (time == null) {
    return null;
  }
  final hours = time.hours.toString().padLeft(2, '0');
  final minutes = time.minutes.toString().padLeft(2, '0');
  final temp = DateFormat.Hm().parse('$hours:$minutes');

  return format24 ? DateFormat.Hm().format(temp) : DateFormat.jm().format(temp);
}
