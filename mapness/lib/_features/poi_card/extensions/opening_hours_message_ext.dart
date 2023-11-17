import 'package:dgis_map/library.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/_features/poi_card/extensions/week_day_ext.dart';
import 'package:mapness/_features/poi_card/extensions/week_time_interval_ext.dart';

extension OpeningHoursMessageExt on OpeningHoursMessage {
  List<OpenHours> getDisplayOpenHours({bool? format24}) {
    final list = values
        .where((e) => e?.values.isNotEmpty == true)
        .map((e) => e?.values.first)
        .toList();

    var allWeekDayNames = DateTimeExt.getAllWeekDayNames();

    final allWeekDays = allWeekDayNames.map((weekDay) {
      final weekTimeInterval = list.firstWhere(
        (e) {
          if (e == null) return false;
          return e.startTime.weekDay.displayName() == weekDay;
        },
        orElse: () => null,
      );

      var displayStartFinishTime =
          weekTimeInterval?.displayStartFinishTime(format24: true);
      final timeString = displayStartFinishTime ?? 'weekend';

      return OpenHours(
        isWeekend: displayStartFinishTime == null,
        weekDay: toBeginningOfSentenceCase(weekDay)!,
        openHours: timeString,
      );
    });
    return allWeekDays.toList();
  }

  String getTodayOpeningInfo() {
    final todayName = DateTime.now().weekDayName();

    final todayOpenHoursData = getDisplayOpenHours().firstWhere(
      (e) => e.weekDay.toLowerCase() == todayName.toLowerCase(),
    );

    return 'Today ${todayOpenHoursData.openHours}';
  }
}
