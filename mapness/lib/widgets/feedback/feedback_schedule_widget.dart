import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/weekday_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_schedule_interval_widget.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_select_days_sheet.dart';

typedef _WorkingHours = FeedbackScheduleWorkingHoursEntity;

class FeedbackScheduleWidget extends StatelessWidget {
  final FeedbackScheduleEntity field;
  final void Function(IList<FeedbackScheduleWorkingHoursEntity>) onValueChange;

  const FeedbackScheduleWidget({
    required this.field,
    required this.onValueChange,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    final intervals = field.value ?? const IList.empty();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// working hours intervals
        for (final (intervalIndex, workingHours) in intervals.indexed)
          FeedbackScheduleIntervalWidget(
            onDelete: () => _onIntervalDelete(intervalIndex),
            onDaysChange: () async => _onDaysChange(context, intervalIndex),
            onWorkingHoursChange: (workingTime) => _onWorkingHoursChange(intervalIndex, workingTime.workingTime),
            workingHours: workingHours,
          ),

        if (_isAddModeIntervalsShown(field))
          uikit.AppButton(
            size: ButtonSize.small,
            buttonColorScheme: ButtonColorScheme.secondary,
            primaryLabel: context.l10n.feedbackScheduleAddMoreDays,
            onTap: () => _onIntervalAdd(),
          ),
      ],
    );
  }

  void _onWorkingHoursChange(int intervalIndex, TimeRange workingTime) {
    if (field.value == null) {
      return;
    }

    onValueChange(
      field.value!.replace(
        intervalIndex,
        _WorkingHours(
          workingTime: workingTime,
          days: field.value?[intervalIndex].days ?? const ISet.empty(),
        ),
      ),
    );
  }

  void _onIntervalDelete(int intervalIndex) {
    if (field.value == null) {
      return;
    }

    onValueChange(
      field.value!.removeAt(intervalIndex),
    );
  }

  void _onIntervalAdd() {
    onValueChange(
      (field.value ?? const IList.empty()).add(
        const _WorkingHours(
          workingTime: TimeRangeStartEnd(
            start: TimeOfDay(hour: 9, minute: 0),
            end: TimeOfDay(hour: 18, minute: 0),
          ),
          days: ISet.empty(),
        ),
      ),
    );
  }

  Future<void> _onDaysChange(
    BuildContext context,
    int intervalIndex,
  ) async {
    final workingHours = field.value?[intervalIndex];
    if (workingHours == null) {
      return;
    }

    /// we could change days of the selected interval, but not already picked days
    final lockedDays = ISet(
      field.value?.expand((e) => e.days).toISet().difference(workingHours.days),
    );

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.$4x),
        ),
      ),
      builder: (context) => FeedbackSelectDaysSheet(
        workingHours: workingHours,
        lockedDays: lockedDays,
        onDaysChange: (workingHours) => _onWorkingHoursChange(intervalIndex, workingHours.workingTime),
      ),
    );
  }
}

bool _isAddModeIntervalsShown(FeedbackScheduleEntity field) {
  final fieldValue = field.value ?? const IList.empty();

  final lockedDays = fieldValue.expand((e) => e.days).toISet();
  final allDays = ISet(WeekDay.values);

  return lockedDays != allDays && fieldValue.every((e) => e.days.isNotEmpty);
}
