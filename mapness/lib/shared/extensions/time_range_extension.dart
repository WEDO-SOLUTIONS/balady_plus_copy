import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/shared/extensions/time_of_day_extension.dart';

extension TimeRangeExtension on TimeRange {
  String formatTimeRange() => switch (this) {
        TimeRangeAllDay() => '00:00 - 23:59',
        TimeRangeStartEnd(start: final start, end: final end) => '${start.formatTime()} - ${end.formatTime()}',
      };
}
