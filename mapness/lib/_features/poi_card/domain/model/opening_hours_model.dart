import 'package:collection/collection.dart';
import 'package:mapness/_features/poi_card/extensions/date_time_ext.dart';

class OpeningHoursModel {
  bool? isOpen24x7;
  bool? isDailySameOpenHours;
  List<OpenHours>? openingHours;

  OpeningHoursModel({
    required this.isOpen24x7,
    required this.isDailySameOpenHours,
    required this.openingHours,
  });

  OpenHours? getTodayOpeningInfo() {
    final todayName = DateTime.now().weekDayName();
    return openingHours?.firstWhereOrNull(
      (e) => e.weekDay.toLowerCase() == todayName.toLowerCase(),
    );
  }
}

class OpenHours {
  bool isWeekend;
  String weekDay;
  String? openHour;
  String? closeHour;

  OpenHours({
    required this.isWeekend,
    required this.weekDay,
    this.openHour,
    this.closeHour,
  });
}
