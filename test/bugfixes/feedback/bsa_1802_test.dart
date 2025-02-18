import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

///BSA-1802 Can't return no breaks in working hours
void main() {
  group('GIVEN working hours has break set', () {
    late FeedbackScheduleWorkingHoursEntity workingHoursWithBreaks;

    setUp(() {
      final breakTime = TimeRangeStartEnd(
        start: TimeOfDay.fromDateTime(DateTime(2025)),
        end: TimeOfDay.fromDateTime(DateTime(2025)),
      );

      workingHoursWithBreaks = FeedbackScheduleWorkingHoursEntity.standard.copyWith(breaks: breakTime);
    });

    group('WHEN reset to no breaks', () {
      late FeedbackScheduleWorkingHoursEntity workingHoursWithoutBreaks;
      setUp(() => workingHoursWithoutBreaks = workingHoursWithBreaks.copyWith(breaks: null));

      test('THEN has no breaks', () => expect(workingHoursWithoutBreaks.breaks, isNull));
    });
  });
}
