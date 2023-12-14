import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/_features/poi_card/extensions/week_day_ext.dart';
import 'package:mapness/_features/poi_card/extensions/week_time_interval_ext.dart';

extension OpeningHoursMessageExt on OpeningHoursMessage {
  List<OpenHours> getDisplayOpenHours({bool? format24}) {
    try {
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

        var displayStartTime =
        weekTimeInterval?.displayStartTime(format24: true);

        var displayFinishTime =
        weekTimeInterval?.displayFinishTime(format24: true);

        return OpenHours(
          isWeekend: (displayStartTime == null || displayFinishTime == null),
          weekDay: toBeginningOfSentenceCase(weekDay)!,
          openHour: displayStartTime,
          closeHour: displayFinishTime,
        );
      });
      return allWeekDays.toList();
    }catch(e){
      debugPrint("OPEN TIME EXCEPTION: $e");
      return <OpenHours>[];
    }
  }

  String getTodayOpeningInfo() {
    final todayName = DateTime.now().weekDayName();

    final todayOpenHoursData = getDisplayOpenHours().firstWhere(
      (e) => e.weekDay.toLowerCase() == todayName.toLowerCase(),
    );
    return 'Today ${todayOpenHoursData.openHour}';
  }

  bool defineIsDailySameOpenHours() {
    var groupListsBy = getDisplayOpenHours(format24: true).groupListsBy(
      (element) => '${element.openHour}${element.closeHour}',
    );
    return groupListsBy.length == 1;
  }
}
