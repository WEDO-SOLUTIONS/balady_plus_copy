/// Domain entity that represents working hours of a POI
/// [workHours] - information about today working hours
/// [breakHours] - information about today breaks or additional info
/// [days] - list of days with working hours to show it if needed
/// [additionalInfo] - additional info about working hours (Ramadan, etc.)
class PoiContentWorkTimeModel {
  /// Title of the working hours
  /// Example: "Daily 19:00 - 23:00"
  final String workHours;

  /// Subtitle of the working hours
  /// Example: "Break: 12:00 - 13:00"
  final String? breakHours;

  /// List of days with working hours to show it if needed
  /// Example: [PoiContentWorkTimeDay(dayTitle: "Monday", workHours: "10:00 - 18:00"), PoiContentWorkTimeDay(dayTitle: "Tuesday", workHours: "10:00 - 18:00")]
  final List<PoiContentWorkTimeDayModel>? days;

  /// Additional info about working hours (Ramadan, etc.)
  /// Example: "Solemn registration of marriages: Wed, Fri, Sat. Reception of citizens: Tue-Sat. Closed day: first working day of the month"
  final String? additionalInfo;

  const PoiContentWorkTimeModel({
    required this.workHours,
    this.breakHours,
    this.days,
    this.additionalInfo,
  });
}

/// [PoiContentWorkTimeDay] is a model for the working time day section of a POI card.
class PoiContentWorkTimeDayModel {
  /// Title of the day
  /// Example: "Monday"
  final String dayTitle;

  /// Work hours
  /// Example: "10:00 - 18:00"
  final String workHours;

  /// Break hours
  /// Example: "13:00 - 14:00"
  final String? breakHours;

  const PoiContentWorkTimeDayModel({
    required this.dayTitle,
    required this.workHours,
    this.breakHours,
  });
}

/// --- Old models that are not used in calculation of work time --- ///

class OpeningHoursModel {
  final bool? isAlwaysOpen;
  final bool? isDailySameOpenHours;
  final List<OpenHours>? openingHours;

  const OpeningHoursModel({
    required this.isAlwaysOpen,
    required this.isDailySameOpenHours,
    required this.openingHours,
  });
}

class OpenHours {
  final bool isWeekend;
  final String weekDay;
  final String? openHour;
  final String? closeHour;

  const OpenHours({
    required this.isWeekend,
    required this.weekDay,
    this.openHour,
    this.closeHour,
  });
}

enum WorkTimeType {
  open,
  almostClosed,
  closed,
  unknown,
}

class ContentWorkTimeModel {
  final WorkTimeType workTimeType;
  final PoiContentWorkTimeModel poiContentWorkTime;

  const ContentWorkTimeModel({
    required this.poiContentWorkTime,
    required this.workTimeType,
  });
}
