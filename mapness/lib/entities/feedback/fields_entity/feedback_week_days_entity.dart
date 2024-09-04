part of '../feedback_base_entity.dart';

class FeedbackWorkingHoursEntity extends FeedbackBaseEntity<List<FeedbackWeekDayWorkingHoursEntity>> {
  final String label;
  final List<String> variants;

  const FeedbackWorkingHoursEntity({
    required super.id,
    required super.isRequired,
    required this.label,
    required this.variants,
    required super.isHidden,
    List<FeedbackWeekDayWorkingHoursEntity>? value,
  }) : super(value: value);

  @override
  FeedbackWorkingHoursEntity updatedValue(List<FeedbackWeekDayWorkingHoursEntity> value) => FeedbackWorkingHoursEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        variants: variants,
        value: value,
        isHidden: isHidden,
      );
}

/// represents single day of the week
class FeedbackWeekDayWorkingHoursEntity {
  final TimeRange workingTime;
  final List<TimeRange> breaks;

  const FeedbackWeekDayWorkingHoursEntity({
    required this.workingTime,
    this.breaks = const [],
  });
}

/// represents time range interval
sealed class TimeRange {
  const TimeRange();
}

/// represents time range interval if it's not all day
class TimeRangeStartEnd extends TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeRangeStartEnd({
    required this.start,
    required this.end,
  });
}

/// represents all day time range
class TimeRangeAllDay extends TimeRange {}
