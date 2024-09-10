import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/weekday_entity.dart';
import 'package:mapness/shared/extensions/persistent_structs.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_schedule_interval_widget.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_select_days_sheet.dart';

class FeedbackScheduleWidget extends StatefulWidget {
  const FeedbackScheduleWidget({Key? key}) : super(key: key);

  @override
  State<FeedbackScheduleWidget> createState() => _FeedbackScheduleWidgetState();
}

class _FeedbackScheduleWidgetState extends State<FeedbackScheduleWidget> {
  final selectedDaysNotifier = ValueNotifier<PSet<WeekDay>>(PSet({}));

  @override
  Widget build(BuildContext context) {
    const workingHours = FeedbackScheduleWorkingHoursEntity(
      workingTime: TimeRangeStartEnd(
        start: TimeOfDay(hour: 8, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
      // breaks: TimeRangeStartEnd(
      //   start: TimeOfDay(hour: 12, minute: 0),
      //   end: TimeOfDay(hour: 13, minute: 0),
      // ),
    );

    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedDaysNotifier,
          builder: (context, selectedDays, child) => FeedbackScheduleIntervalWidget(
            onDelete: () {},
            onDaysChange: () async => _onDaysChange(
              [
                WeekDay.monday,
                WeekDay.tuesday,
                WeekDay.wednesday,
              ],
            ),
            onWorkingHoursChange: (workingHours) {},
            workingHours: workingHours,
            days: selectedDays,
          ),
        ),
      ],
    );
  }

  Future<void> _onDaysChange(List<WeekDay> lockedDays) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.$4x),
        ),
      ),
      builder: (context) => FeedbackSelectDaysSheet(
        selectedDaysNotifier: selectedDaysNotifier,
        lockedDays: lockedDays,
      ),
    );
  }
}
