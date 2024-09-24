import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';

part 'feedback_schedule_payload_dto.g.dart';

typedef _WH = FeedbackWorkingHoursPayloadDto;

@JsonSerializable(fieldRename: FieldRename.pascal, createFactory: false)
class FeedbackSchedulePayloadDto {
  final _WH? mon;
  final _WH? tue;
  final _WH? wed;
  final _WH? thu;
  final _WH? fri;
  final _WH? sat;
  final _WH? sun;

  const FeedbackSchedulePayloadDto({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
  });

  factory FeedbackSchedulePayloadDto.fromDomain(
    IList<FeedbackScheduleWorkingHoursEntity> entities,
  ) {
    final weekDayMap = Map.fromEntries(
      entities.expand(
        (wh) => wh.days.map(
          (day) => MapEntry(
            day,
            FeedbackWorkingHoursPayloadDto.fromDomain(
              wh.workingTime,
              wh.breaks,
            ),
          ),
        ),
      ),
    );

    return FeedbackSchedulePayloadDto(
      mon: weekDayMap[WeekDay.monday],
      tue: weekDayMap[WeekDay.tuesday],
      wed: weekDayMap[WeekDay.wednesday],
      thu: weekDayMap[WeekDay.thursday],
      fri: weekDayMap[WeekDay.friday],
      sat: weekDayMap[WeekDay.saturday],
      sun: weekDayMap[WeekDay.sunday],
    );
  }

  Map<String, dynamic> toJson() => _$FeedbackSchedulePayloadDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class FeedbackWorkingHoursPayloadDto extends FromToHoursPayloadDto {
  final List<FromToHoursPayloadDto> breaks;

  const FeedbackWorkingHoursPayloadDto({
    required super.from,
    required super.to,
    required this.breaks,
  });

  factory FeedbackWorkingHoursPayloadDto.fromDomain(TimeRange timeRange, TimeRangeStartEnd? breaks) {
    final range = switch (timeRange) {
      TimeRangeStartEnd() => timeRange,
      TimeRangeAllDay() => const TimeRangeStartEnd(
          start: TimeOfDay(hour: 0, minute: 0),
          end: TimeOfDay(hour: 23, minute: 59),
        ),
    };

    return FeedbackWorkingHoursPayloadDto(
      from: range.start.toString(),
      to: range.end.toString(),
      breaks: [
        if (breaks != null) FromToHoursPayloadDto.fromDomain(breaks),
      ],
    );
  }

  @override
  Map<String, dynamic> toJson() => _$FeedbackWorkingHoursPayloadDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class FromToHoursPayloadDto {
  final String from;
  final String to;

  const FromToHoursPayloadDto({
    required this.from,
    required this.to,
  });

  factory FromToHoursPayloadDto.fromDomain(TimeRangeStartEnd timeRange) => FromToHoursPayloadDto(
        from: timeRange.start.toString(),
        to: timeRange.end.toString(),
      );

  Map<String, dynamic> toJson() => _$FromToHoursPayloadDtoToJson(this);
}
