import 'package:collection/collection.dart';
import 'package:mapness/_features/poi_card/extensions/date_time_ext.dart';

class OpeningHoursModel {
  bool? isOpen24x7;
  List<OpenHours>? openingHours;
  String? todayOpeningInfo;

  OpeningHoursModel({
    required this.isOpen24x7,
    required this.openingHours,
    required this.todayOpeningInfo,
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
  String openHours;

  OpenHours({
    required this.isWeekend,
    required this.weekDay,
    required this.openHours,
  });
}
