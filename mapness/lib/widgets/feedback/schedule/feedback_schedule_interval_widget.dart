import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/iset_weekday_extension.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';

class FeedbackScheduleIntervalWidget extends StatelessWidget {
  final void Function()? onDelete;
  final FeedbackScheduleWorkingHoursEntity workingHours;
  final void Function() onDaysChange;
  final void Function(FeedbackScheduleWorkingHoursEntity) onWorkingHoursChange;

  const FeedbackScheduleIntervalWidget({
    required this.onDelete,
    required this.onDaysChange,
    required this.onWorkingHoursChange,
    required this.workingHours,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDropDownList(
              label: workingHours.days.sortedByIndex().map((day) => day.localizedShortName(context.l10n)).join(', '),
              onTap: onDaysChange,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                InputDropDownList(
                  label: switch (workingHours.workingTime) {
                    TimeRangeStartEnd() => _formatTimeRange(workingHours.workingTime as TimeRangeStartEnd),
                    _ => '00:00 - 24:00',
                  },
                  onTap: () {},
                ),
                const SizedBox(width: 6),
                InputDropDownList(
                  label: _formatBreaks(context.l10n, workingHours.breaks),
                  onTap: () {},
                ),
                const SizedBox(width: 6),
                if (onDelete != null)
                  AppButton.close(
                    onTap: onDelete,
                    buttonColorScheme: ButtonColorScheme.onColor,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ],
        ),
      );

  String _formatTimeRange(TimeRangeStartEnd timeRange) {
    final range = timeRange;
    return '${_formatTime(range.start)} - ${_formatTime(range.end)}';
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _formatBreaks(AppLocalizations l10n, TimeRangeStartEnd? breaks) {
    if (breaks == null) {
      return l10n.feedbackNoBreaks;
    }
    return _formatTimeRange(breaks);
  }
}

class InputDropDownList extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const InputDropDownList({required this.label, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: context.colorsV2.backgroundSurface1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyleV3.bodySmallRegular,
                ),
              ),
              const Icon(SystemIcons.arrowCornerDownSmall),
            ],
          ),
        ),
      );
}
