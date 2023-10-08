import 'package:dgis_map/library.dart';
import 'package:intl/intl.dart';

extension WeekTimeIntervalData on WeekTimeIntervalMessage {
  String displayStartTime() {
    final startHours = startTime.time.hours.toString().padLeft(2, "0");
    final startMinutes = startTime.time.minutes.toString().padLeft(2, "0");
    final startTemp = DateFormat("hh:mm").parse("$startHours:$startMinutes");

    return DateFormat("hh:mm a").format(startTemp);
  }

  String displayFinishTime() {
    final finishHours = finishTime.time.hours.toString().padLeft(2, "0");
    final finishMinutes = finishTime.time.minutes.toString().padLeft(2, "0");
    final finishTemp = DateFormat("hh:mm").parse("$finishHours:$finishMinutes");

    return DateFormat("hh:mm a").format(finishTemp);
  }
}
