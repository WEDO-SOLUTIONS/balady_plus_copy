import 'package:dgis_map/library.dart';

extension WeekDayName on WeekDayMessage {
  String displayName() {
    return switch (this) {
      WeekDayMessage.monday => "monday",
      WeekDayMessage.tuesday => "tuesday",
      WeekDayMessage.wednesday => "wednesday",
      WeekDayMessage.thursday => "thursday",
      WeekDayMessage.friday => "friday",
      WeekDayMessage.saturday => "saturday",
      WeekDayMessage.sunday => "sunday",
    };
  }
}
