import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/iset_weekday_extension.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/time_range_extension.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class FeedbackScheduleIntervalWidget extends StatelessWidget {
  final void Function()? onDelete;
  final FeedbackScheduleWorkingHoursEntity workingHours;
  final void Function() onDaysChange;
  final void Function() onWorkingHoursChange;
  final void Function() onBreaksChange;

  const FeedbackScheduleIntervalWidget({
    required this.onDelete,
    required this.onDaysChange,
    required this.onWorkingHoursChange,
    required this.workingHours,
    required this.onBreaksChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDaysEmpty = workingHours.days.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDropDownList(
          label: isDaysEmpty
              ? context.l10n.feedbackSelectDaysTitle
              : workingHours.days.sortedByIndex().map((day) => day.localizedShortName(context.l10n)).join(', '),
          onTap: onDaysChange,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            InputDropDownList(
              isEnable: !isDaysEmpty,
              label: context.l10n.digits(workingHours.workingTime.formatTimeRange()),
              onTap: onWorkingHoursChange,
            ),
            const SizedBox(width: 6),
            InputDropDownList(
              isEnable: !isDaysEmpty,
              label: _formatBreaks(context.l10n, workingHours.breaks),
              onTap: onBreaksChange,
            ),
            const SizedBox(width: 6),
            if (onDelete != null)
              AppButton.close(onTap: onDelete, buttonColorScheme: ButtonColorScheme.onColor, padding: EdgeInsets.zero),
          ],
        ),
      ],
    );
  }

  String _formatBreaks(AppLocalizations l10n, TimeRangeStartEnd? breaks) {
    if (breaks == null) {
      return l10n.feedbackNoBreaks;
    }
    return l10n.digits(breaks.formatTimeRange());
  }
}

class InputDropDownList extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isEnable;

  const InputDropDownList({required this.label, required this.onTap, this.isEnable = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: isEnable ? onTap : null,
    child: Container(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(color: context.colors.backgroundSurface1, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodySmallRegular.copyWith(
                color: isEnable ? context.colors.foregroundDefault : context.colors.foregroundMuted,
              ),
            ),
          ),
          Icon(
            SystemIcons.arrowCornerDownSmall,
            color: isEnable ? context.colors.foregroundDefault : context.colors.foregroundMuted,
          ),
        ],
      ),
    ),
  );
}
