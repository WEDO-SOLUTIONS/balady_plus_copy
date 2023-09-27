import 'package:dgis_map/library.dart';

extension WeekTimeIntervalData on WeekTimeIntervalMessage {
  String displayTime() {
    final startHours = startTime.time.hours.toString().padLeft(2, "0");
    final startMinutes = startTime.time.minutes.toString().padLeft(2, "0");

    final finishHours = finishTime.time.hours.toString().padLeft(2, "0");
    final finishMinutes = finishTime.time.minutes.toString().padLeft(2, "0");

    return "$startHours:$startMinutes – $finishHours:$finishMinutes";
  }
}
