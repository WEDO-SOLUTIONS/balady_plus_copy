// ignore_for_file: prefer_expression_function_bodies

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/shared/extensions/time_of_day_extension.dart';
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
  @JsonKey(name: 'San')
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
        (wh) {
          final range = switch (wh.workingTime) {
            TimeRangeStartEnd() => wh.workingTime as TimeRangeStartEnd,
            TimeRangeAllDay() => const TimeRangeStartEnd(
                start: TimeOfDay(hour: 0, minute: 0),
                end: TimeOfDay(hour: 23, minute: 59),
              ),
          };

          /// working hours segment - breaks segment
          final breaks = wh.breaks;
          final List<TimeRangePayloadDto> listOfWorkingHours;
          if (breaks != null) {
            listOfWorkingHours = [
              TimeRangePayloadDto(
                from: range.start.formatTime(),
                to: breaks.start.formatTime(),
              ),
              TimeRangePayloadDto(
                from: breaks.end.formatTime(),
                to: range.end.formatTime(),
              ),
            ];
          } else {
            listOfWorkingHours = [TimeRangePayloadDto.fromDomain(range)];
          }

          return wh.days.map(
            (day) {
              return MapEntry(
                day,
                FeedbackWorkingHoursPayloadDto(
                  workingHours: listOfWorkingHours,
                ),
              );
            },
          );
        },
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
class FeedbackWorkingHoursPayloadDto {
  final List<TimeRangePayloadDto> workingHours;

  const FeedbackWorkingHoursPayloadDto({
    required this.workingHours,
  });

  factory FeedbackWorkingHoursPayloadDto.fromList(List<TimeRangePayloadDto> hours) {
    return FeedbackWorkingHoursPayloadDto(workingHours: hours);
  }

  Map<String, dynamic> toJson() => _$FeedbackWorkingHoursPayloadDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class TimeRangePayloadDto {
  final String from;
  final String to;

  const TimeRangePayloadDto({
    required this.from,
    required this.to,
  });

  factory TimeRangePayloadDto.fromDomain(TimeRangeStartEnd timeRange) => TimeRangePayloadDto(
        from: timeRange.start.formatTime(),
        to: timeRange.end.formatTime(),
      );

  Map<String, dynamic> toJson() => _$TimeRangePayloadDtoToJson(this);
}
