// ignore_for_file: cascade_invocations

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/iset_weekday_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_scroll_handle_widget.dart';

typedef _FieldState = FormFieldState<IList<FeedbackScheduleWorkingHoursEntity>>;

/// TODO(Demezy): when uikit bottom sheet released, use it instead of this
class FeedbackSelectDaysSheet extends StatefulWidget {
  /// DO NOT ADD VALUES INSIDE OF IT
  final _FieldState fieldState;
  final int fieldIndex;

  FeedbackSelectDaysSheet({
    required this.fieldState,
    required this.fieldIndex,
    super.key,
  })  : assert(fieldState.value != null, 'field value should present'),
        assert(fieldState.value!.length > fieldIndex, 'field index should be withing range of fields');

  @override
  State<FeedbackSelectDaysSheet> createState() => _FeedbackSelectDaysSheetState();
}

class _FeedbackSelectDaysSheetState extends State<FeedbackSelectDaysSheet> {
  ISet<WeekDay> get lockedDays => (widget.fieldState.value ?? const IList.empty())
      // safe since collection is immutable
      .removeAt(widget.fieldIndex)
      .expand((schedule) => schedule.days)
      .toISet();

  FeedbackScheduleWorkingHoursEntity get workingHours => widget.fieldState.value![widget.fieldIndex];

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    final selectAllState = _isAllDaysState(lockedDays, workingHours.days);

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
                    lockedDays.sortedByIndex().map((day) => day.localizedShortName(context.l10n)).join(', '),
                    style: context.textStyle.footNote.copyWith(
                      color: context.colors.foregroundSoft,
                    ),
                  ),
                ],
              ),
              uikit.AppButton.close(onTap: () => context.router.popForced()),
            ],
          ),
          const SizedBox(height: Spacing.$3x),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.$4x),
              color: context.colors.backgroundSurface4,
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
                  onTap: () => _handleMarkAll(selectAllState),
                ),
                for (final day in WeekDay.values)
                  _SelectDayItem(
                    state:
                        workingHours.days.contains(day) ? BaladyCheckBoxState.checked : BaladyCheckBoxState.unchecked,
                    disable: lockedDays.contains(day),
                    dayName: day.localizedName(context.l10n),
                    onTap: () => _handleOnDayTap(day),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateFieldInState(
    int fieldIndex,
    FeedbackScheduleWorkingHoursEntity updatedField,
  ) {
    /// since this widget is in other tree we could not directly listen to updates.
    /// Fortunately there is no flow where update comes from outside => we could assume
    /// that both in sync.
    if (!mounted) {
      return;
    }
    setState(
      () {
        widget.fieldState.didChange(
          widget.fieldState.value!.replace(fieldIndex, updatedField),
        );
      },
    );
  }

  void _handleOnDayTap(WeekDay day) {
    _updateFieldInState(
      widget.fieldIndex,
      workingHours.copyWith(
        days: workingHours.days.contains(day)
            ? ISet(workingHours.days.difference({day}))
            : ISet({...workingHours.days, day}),
      ),
    );
  }

  void _handleMarkAll(
    BaladyCheckBoxState selectAllState,
  ) {
    _updateFieldInState(
      widget.fieldIndex,
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
    if (!mounted) {
      return;
    }
    setState(() {});
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
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.colors.neutralContainerActive,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dayName,
                  style: context.textStyles.bodyLargeRegular,
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
