part of '../feedback_base_entity.dart';

class FeedbackScheduleEntity extends FeedbackBaseEntity<IList<FeedbackScheduleWorkingHoursEntity>> {
  const FeedbackScheduleEntity({
    required super.id,
    required super.isRequired,
    required super.isHidden,
    IList<FeedbackScheduleWorkingHoursEntity>? value,
  }) : super(value: value);

  @override
  bool get isValid {
    if (isRequired) {
      final days = value?.expand((e) => e.days).toList() ?? List.empty();
      return days.isNotEmpty && (days.toSet().length == days.length);
    }
    return true;
  }

  @override
  FeedbackScheduleEntity updatedValue(IList<FeedbackScheduleWorkingHoursEntity> value) => FeedbackScheduleEntity(
        id: id,
        isRequired: isRequired,
        value: value,
        isHidden: isHidden,
      );
}

/// represents single day of the week
@immutable
class FeedbackScheduleWorkingHoursEntity {
  final TimeRange workingTime;
  final TimeRangeStartEnd? breaks;
  final ISet<WeekDay> days;

  const FeedbackScheduleWorkingHoursEntity({
    required this.workingTime,
    required this.days,
    this.breaks,
  });

  FeedbackScheduleWorkingHoursEntity copyWith({
    TimeRange? workingTime,
    TimeRangeStartEnd? breaks,
    Iterable<WeekDay>? days,
  }) =>
      FeedbackScheduleWorkingHoursEntity(
        workingTime: workingTime ?? this.workingTime,
        breaks: breaks ?? this.breaks,

        /// it is fast -> https://pub.dev/packages/fast_immutable_collections#26-iterables-to-create-iIList-fields
        days: ISet(days ?? this.days),
      );

  @override
  String toString() => '_WorkingHors(workingTime: $workingTime, breaks: $breaks, days: $days)';

  @override
  int get hashCode => Object.hashAll([workingTime, breaks, days]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackScheduleWorkingHoursEntity &&
          workingTime == other.workingTime &&
          breaks == other.breaks &&
          days == other.days;
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
