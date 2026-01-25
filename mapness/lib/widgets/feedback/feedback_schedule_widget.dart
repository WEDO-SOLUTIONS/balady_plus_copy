// ignore_for_file: prefer_expression_function_bodies, unused_local_variable, unused_import

import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/feedback/dto/feedback_field_payload_dto.dart';
import 'package:mapness/entities/feedback/dto/feedback_schedule_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';
import 'package:mapness/shared/providers/map/directory_object_from_dgis_id.dart';
import 'package:mapness/widgets/feedback/schedule/drum_picker_widget.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_schedule_interval_widget.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_select_days_sheet.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_time_select_sheet.dart';
import 'package:mapness/widgets/feedback/schedule/gradiented_opacity_widget.dart';

typedef _WorkingHours = FeedbackScheduleWorkingHoursEntity;
typedef _FieldPayload = IList<_WorkingHours>;
typedef _FieldState = FormFieldState<_FieldPayload>;

class FeedbackScheduleWidget extends ConsumerWidget {
  final FeedbackScheduleEntity field;
  final int? objectId;

  const FeedbackScheduleWidget({
    required this.field,
    this.objectId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderField<_FieldPayload>(
        name: field.id,
        valueTransformer: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }

          final sourceWorkingHours = objectId != null
              ? ref
                  .read(directoryObjectFromDgisIdProvider(DgisObjectId(objectId: objectId!, entranceId: 0)))
                  .value
                  ?.openingHours
              : null;
          final days = FeedbackSchedulePayloadDto.fromDomain(value, sourceWorkingHours);
          return days.toJson();
        },
        validator: (value) {
          /// not required => may be empty
          if (!field.isRequired && (value?.isEmpty ?? true)) {
            return null;
          }
          if (value == null) {
            // no message is displayed
            return 'should be not empty';
          }
          return null;
        },
        initialValue: IList(const [
          FeedbackScheduleWorkingHoursEntity(
            workingTime: TimeRange.standard,
            days: ISet.empty(),
          )
        ]),
        builder: (fieldState) {
          final intervals = fieldState.value ?? const IList.empty();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// working hours intervals
              for (final (intervalIndex, workingHours) in intervals.indexed)
                FeedbackScheduleIntervalWidget(
                  onDelete: intervalIndex == 0 ? null : () => fieldState.didChange(intervals.removeAt(intervalIndex)),
                  onDaysChange: () async => _onDaysChange(context, intervalIndex, fieldState),
                  onWorkingHoursChange: () => _showWorkingHoursSheet(
                    context,
                    intervalIndex,
                    fieldState,
                  ),
                  workingHours: workingHours,
                  onBreaksChange: () => _showBreaksSheet(context, intervalIndex, fieldState),
                ),

              if (_isAddModeIntervalsShown(intervals))
                SizedBox(
                  width: double.infinity,
                  child: uikit.AppButton(
                    size: ButtonSize.small,
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    primaryLabel: context.l10n.feedbackScheduleAddMoreDays,
                    onTap: () => _onIntervalAdd(fieldState),
                  ),
                ),
            ],
          );
        });
  }

  Future<void> _showBreaksSheet(
    BuildContext context,
    int intervalIndex,
    _FieldState fieldState,
  ) async {
    final value = fieldState.value?[intervalIndex];
    if (value == null || fieldState.value == null) {
      return;
    }

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.$4x),
        ),
      ),
      builder: (context) => FeedbackTimeSelectSheet(
        initialValue: value.breaks,
        onSave: (timeRange) {
          fieldState.didChange(
            fieldState.value!.replace(
              intervalIndex,
              value.copyWith(breaks: timeRange),
            ),
          );
        },
        startDrumTitle: context.l10n.feedbackBreaksSheetStartOfBreak,
        endDrumTitle: context.l10n.feedbackBreaksSheetEndOfBreak,
        toggleTitle: context.l10n.feedbackBreaksSheetNoBreaks,
      ),
    );
  }

  Future<void> _showWorkingHoursSheet(
    BuildContext context,
    int intervalIndex,
    _FieldState fieldState,
  ) async {
    final value = fieldState.value?[intervalIndex];
    if (value == null || fieldState.value == null) {
      return;
    }

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.$4x),
        ),
      ),
      builder: (context) => FeedbackTimeSelectSheet(
        initialValue: switch (value.workingTime) {
          TimeRangeStartEnd() => value.workingTime as TimeRangeStartEnd,
          TimeRangeAllDay() => null,
        },
        onSave: (timeRange) {
          fieldState.didChange(
            fieldState.value!.replace(
              intervalIndex,
              value.copyWith(workingTime: timeRange ?? const TimeRangeAllDay()),
            ),
          );
        },
        startDrumTitle: context.l10n.feedbackWorkingHoursSheetStartOfWork,
        endDrumTitle: context.l10n.feedbackWorkingHoursSheetEndOfWork,
        toggleTitle: context.l10n.feedbackWorkingHoursSheetAllDay,
      ),
    );
  }

  void _onIntervalAdd(_FieldState fieldState) {
    final value = fieldState.value ?? const IList.empty();
    fieldState.didChange(
      value.add(
        const _WorkingHours(
          workingTime: TimeRange.standard,
          days: ISet.empty(),
        ),
      ),
    );
  }

  Future<void> _onDaysChange(
    BuildContext context,
    int intervalIndex,
    _FieldState fieldState,
  ) async {
    final intervals = fieldState.value;
    if (intervals == null || intervals.length < intervalIndex) {
      return;
    }

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.$4x),
        ),
      ),
      builder: (context) => FeedbackSelectDaysSheet(
        fieldState: fieldState,
        fieldIndex: intervalIndex,
      ),
    );
  }
}

bool _isAddModeIntervalsShown(_FieldPayload intervals) {
  final lockedDays = intervals.expand((e) => e.days).toISet();
  final allDays = ISet(WeekDay.values);

  return lockedDays != allDays && intervals.every((e) => e.days.isNotEmpty);
}
