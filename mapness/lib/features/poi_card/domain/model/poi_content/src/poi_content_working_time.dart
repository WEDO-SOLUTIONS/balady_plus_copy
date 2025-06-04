/// [PoiContentWorkTimeModel] is a model for the working time section of a POI card.
class PoiContentWorkTimeModel {
  /// Work hours
  /// Example: "Daily: 10:00 - 18:00"
  final String workHours;

  /// Break hours
  /// Example: "13:00 - 14:00"
  final String? breakHours;

  /// List of days
  /// Example: [PoiContentWorkTimeDay(dayTitle: "Monday", workHours: "10:00 - 18:00", breakHours: "13:00 - 14:00")]
  final List<PoiContentWorkTimeDayModel>? days;

  /// Additional info
  /// Example: "This building is closed on weekends"
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
