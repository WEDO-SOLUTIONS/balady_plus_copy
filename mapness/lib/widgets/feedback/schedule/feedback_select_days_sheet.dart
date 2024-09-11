import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/iset_weekday_extension.dart';
import 'package:mapness/entities/feedback/weekday_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_scroll_handle_widget.dart';

/// TODO(Demezy): when uikit bottom sheet released, use it instead of this
class FeedbackSelectDaysSheet extends StatelessWidget {
  final FeedbackScheduleWorkingHoursEntity workingHours;
  final void Function(FeedbackScheduleWorkingHoursEntity) onDaysChange;

  final ISet<WeekDay> lockedDays;

  const FeedbackSelectDaysSheet({
    required this.workingHours,
    required this.onDaysChange,
    required this.lockedDays,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDays = workingHours.days;
    final selectAllState = _isAllDaysState(lockedDays, selectedDays);

    return Container(
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Spacing.$4x),
          topRight: Radius.circular(Spacing.$4x),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FeedbackScrollHandle(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.feedbackSelectDaysTitle,
                    style: context.textStyle.heading2,
                  ),
                  Text(
                    lockedDays
                        .sortedByIndex()
                        .map(
                          (day) => day.localizedShortName(context.l10n),
                        )
                        .join(', '),
                    style: context.textStyle.footNote.copyWith(
                      color: context.colorsV2.foregroundSoft,
                    ),
                  ),
                ],
              ),
              uikit.AppButton.close(onTap: () => context.pop()),
            ],
          ),
          const SizedBox(height: Spacing.$3x),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.$4x),
              color: context.colorsV2.backgroundSurface4,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.$4x,
              vertical: Spacing.$2x,
            ),
            child: Column(
              children: [
                _SelectDayItem(
                  state: selectAllState,
                  disable: false,
                  dayName: context.l10n.feedbackEverydayCheckboxLabel,
                  onTap: () {
                    onDaysChange(
                      switch (selectAllState) {
                        /// if all days are selected, select none
                        BaladyCheckBoxState.checked => workingHours.copyWith(days: ISet(const {})),

                        /// if not all days are selected, select all days
                        BaladyCheckBoxState.indeterminate || BaladyCheckBoxState.unchecked => workingHours.copyWith(
                            days: ISet(
                              WeekDay.values.toSet().difference(lockedDays.toSet()),
                            ),
                          ),
                      },
                    );
                  },
                ),
                for (final day in WeekDay.values)
                  _SelectDayItem(
                    state: [...selectedDays, ...lockedDays].contains(day)
                        ? BaladyCheckBoxState.checked
                        : BaladyCheckBoxState.unchecked,
                    disable: lockedDays.contains(day),
                    dayName: day.localizedShortName(context.l10n),
                    onTap: () {
                      onDaysChange(
                        workingHours.copyWith(
                          days: selectedDays.contains(day)
                              ? ISet(selectedDays.difference({day}))
                              : ISet({...selectedDays, day}),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectDayItem extends StatelessWidget {
  final BaladyCheckBoxState state;
  final bool disable;
  final String dayName;

  final void Function() onTap;

  const _SelectDayItem({
    required this.state,
    required this.disable,
    required this.dayName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.colorsV2.neutralContainerActive,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dayName,
                style: context.textStyleV3.bodyLargeRegular,
              ),
            ),
            uikit.BaladyCheckBox(
              state: state,
              disable: disable,
              onChanged: (state) => onTap(),

              /// rebuild checkbox when state or dayName changes
              /// since weeldays does not update when everyday checked
              key: ValueKey(dayName.hashCode ^ state.hashCode),
            ),
          ],
        ),
      );
}

BaladyCheckBoxState _isAllDaysState(
  Iterable<WeekDay> lockedDays,
  Iterable<WeekDay> selectedDays,
) {
  final notLockedDays = WeekDay.values.toSet().difference(lockedDays.toSet());
  final notSelectedDays = notLockedDays.difference(selectedDays.toSet());

  return switch ((notSelectedDays.isEmpty, selectedDays.isEmpty)) {
    (true, _) => BaladyCheckBoxState.checked,
    (false, true) => BaladyCheckBoxState.unchecked,
    _ => BaladyCheckBoxState.indeterminate,
  };
}
