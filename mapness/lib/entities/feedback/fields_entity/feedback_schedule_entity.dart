part of '../feedback_base_entity.dart';

class FeedbackScheduleEntity extends FeedbackBaseEntity {
  const FeedbackScheduleEntity({
    required super.id,
    required super.isRequired,
    required super.isHidden,
  });
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

  static const standard = FeedbackScheduleWorkingHoursEntity(
    workingTime: TimeRange.standard,
    days: ISet.empty(),
  );

  FeedbackScheduleWorkingHoursEntity copyWith({
    TimeRange? workingTime,
    TimeRangeStartEnd? breaks,
    Iterable<WeekDay>? days,
  }) =>
      FeedbackScheduleWorkingHoursEntity(
        workingTime: workingTime ?? this.workingTime,
        breaks: breaks,

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

@freezed
sealed class TimeRange with _$TimeRange {
  const TimeRange._();

  /// represents time range interval if it's not all day
  const factory TimeRange.startEnd({
    required TimeOfDay start,
    required TimeOfDay end,
  }) = TimeRangeStartEnd;

  /// represents all day time range
  const factory TimeRange.allDay() = TimeRangeAllDay;

  static const TimeRangeStartEnd standard = TimeRangeStartEnd(
    start: TimeOfDay(hour: 9, minute: 0),
    end: TimeOfDay(hour: 18, minute: 0),
  );
}
