import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_schedule_interval_widget.dart';

class FeedbackScheduleWidget extends StatelessWidget {
  const FeedbackScheduleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final localizedDays = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];

    const workingHours = FeedbackScheduleWorkingHoursEntity(
      workingTime: TimeRangeStartEnd(
        start: TimeOfDay(hour: 8, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
    );

    return Column(
      children: [
        FeedbackScheduleIntervalWidget(
          onDelete: () {},
          onDaysChange: () {},
          onWorkingHoursChange: (workingHours) {},
          days: localizedDays,
          workingHours: workingHours,
        ),
      ],
    );
  }
}
