import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_working_hours_interval_widget.dart';

class FeedbackScheduleWidget extends StatelessWidget {
  const FeedbackScheduleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const workingHours = FeedbackScheduleWorkingHoursEntity(
      workingTime: TimeRangeStartEnd(
        start: TimeOfDay(hour: 8, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
    );

    return Column(
      children: [
        FeedbackWorkingHoursIntervalWidget(
          onDelete: () {},
          onDaysChange: () {},
          onWorkingHoursChange: (workingHours) {},
          days: days,
          workingHours: workingHours,
        ),
      ],
    );
  }
}
