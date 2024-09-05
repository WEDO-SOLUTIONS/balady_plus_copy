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
      l10n.weekdayNameShortMonday,
      l10n.weekdayNameShortTuesday,
      l10n.weekdayNameShortWednesday,
      l10n.weekdayNameShortThursday,
      l10n.weekdayNameShortFriday,
      l10n.weekdayNameShortSaturday,
      l10n.weekdayNameShortSunday,
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
