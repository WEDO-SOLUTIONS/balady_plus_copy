extension DateTimeExt on DateTime {
  String weekDayName() {
    return switch (weekday) {
      1 => "monday",
      2 => "tuesday",
      3 => "wednesday",
      4 => "thursday",
      5 => "friday",
      6 => "saturday",
      7 => "sunday",
      _ => '',
    };
  }

  static List<String> getAllWeekDayNames() {
    return [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
  }
}
