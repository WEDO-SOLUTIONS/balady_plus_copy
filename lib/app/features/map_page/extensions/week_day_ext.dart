import 'package:dgis_map/library.dart';

extension WeekDayName on WeekDayMessage {
  String displayName() {
    return switch (this) {
      WeekDayMessage.monday => "Mon",
      WeekDayMessage.tuesday => "Tue",
      WeekDayMessage.wednesday => "Wed",
      WeekDayMessage.thursday => "Thu",
      WeekDayMessage.friday => "Fri",
      WeekDayMessage.saturday => "Sat",
      WeekDayMessage.sunday => "Sun"
    };
  }
}
