import 'package:balady_plus/app/core/utils/extensions/str_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';

class PoiContentWorkingHoursCard extends StatelessWidget {
  final WorkingHours workingHours;
  final WorkStatusMessage? workStatusMessage;

  const PoiContentWorkingHoursCard({required this.workingHours, this.workStatusMessage, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String formatOpenClose(Iterable<Hours> hours) =>
        hours.isNotEmpty ? '${hours.first.from.formatHHmm}-${hours.last.till.formatHHmm}' : '';

    String formatBreaks(Iterable<Hours> breakHours) =>
        breakHours.map((b) => '${b.from.formatHHmm}-${b.till.formatHHmm}').join(',');

    String todayWorkingHours() {
      final hours = workingHours.isOpen24x7
          ? l10n.twentyFourSeven
          : formatOpenClose(workingHours.todayHours(DateTime.now().weekday));
      final todayOrDaily = workingHours.isSameEveryDay ? l10n.daily : l10n.today;
      return '$todayOrDaily $hours';
    }

    String? todayBreaks() {
      final breaks = workingHours.todayBreaks(DateTime.now().weekday);
      if (breaks.isNotEmpty) {
        final hours = formatBreaks(breaks);
        return l10n.breakHour(hours);
      }
      return null;
    }

    if (workingHours.isSameEveryDay) {
      return ContentWrapper(
        color: context.colors.backgroundSurface1,
        children: [
          ContentRow(
            leading: GeneralIcons.timeQuarter.icon(color: context.colors.accentDefault),
            text: ContentRowTextOptions(
              title: todayWorkingHours(),
              subtitle: todayBreaks(),
              subtitleOptions: ContentRowTextOption(baseColor: context.colors.foregroundSoft),
            ),
          ),
        ],
      );
    }

    const weekDays = [
      DateTime.sunday,
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
    ];

    // Group consecutive days with the same working hours
    final groupedDays = <_DayGroup>[];
    int? groupStart;
    Iterable<Hours>? currentPeriods;
    Iterable<Hours>? currentBreaks;

    for (int i = 0; i < weekDays.length; i++) {
      final weekday = weekDays[i];
      final periods = workingHours.todayHours(weekday);
      final breaks = workingHours.todayBreaks(weekday);

      if (groupStart == null) {
        // Start a new group
        groupStart = i;
        currentPeriods = periods;
        currentBreaks = breaks;
      } else {
        // Check if this day matches the current group by comparing periods and breaks
        final periodsMatch = const DeepCollectionEquality().equals(periods, currentPeriods);
        final breaksMatch = const DeepCollectionEquality().equals(breaks, currentBreaks);

        if (periodsMatch && breaksMatch) {
          // Continue the current group
          // Do nothing, will be handled when we add the group
        } else {
          // End the current group and start a new one
          final workHours = currentPeriods!.isEmpty ? l10n.weekend : formatOpenClose(currentPeriods);
          final breakHours = formatBreaks(currentBreaks!);
          groupedDays.add(
            _DayGroup(
              startIndex: groupStart,
              endIndex: i - 1,
              workHours: workHours,
              breakHours: breakHours.isNotEmpty ? breakHours : null,
            ),
          );
          groupStart = i;
          currentPeriods = periods;
          currentBreaks = breaks;
        }
      }
    }

    // Add the last group
    if (groupStart != null) {
      final workHours = currentPeriods!.isEmpty ? l10n.weekend : formatOpenClose(currentPeriods);
      final breakHours = formatBreaks(currentBreaks!);
      groupedDays.add(
        _DayGroup(
          startIndex: groupStart,
          endIndex: weekDays.length - 1,
          workHours: workHours,
          breakHours: breakHours.isNotEmpty ? breakHours : null,
        ),
      );
    }

    final weekWorkingHoursWidgets = groupedDays.asMap().entries.map((entry) {
      final index = entry.key;
      final group = entry.value;

      String dayTitle;
      if (group.startIndex == group.endIndex) {
        // Single day - use full name
        final weekday = weekDays[group.startIndex];
        dayTitle = weekday.weekDayName(l10n).toCapitalized();
      } else {
        // Multiple days - use abbreviated names
        final startWeekday = weekDays[group.startIndex];
        final endWeekday = weekDays[group.endIndex];
        final startDay = startWeekday.weekDayNameShort(l10n);
        final endDay = endWeekday.weekDayNameShort(l10n);
        dayTitle = '$startDay-$endDay';
      }

      return _WorkTimeItemWidget(
        dayTitle: dayTitle,
        workHours: group.workHours,
        breakHours: group.breakHours,
        showDivider: index < groupedDays.length - 1,
      );
    });

    return ContentWrapper(
      color: context.colors.backgroundSurface1,
      children: [
        ContentRowExpandable(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
          expandIconColor: context.colors.foregroundMuted,
          // ignore: deprecated_member_use
          options: ContentRowOptions(
            title: todayWorkingHours(),
            subtitle: todayBreaks(),
            subtitleStyle: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            leadingIcon: GeneralIcons.timeQuarter.icon(color: context.colors.accentDefault),
          ),
          content: Column(
            children: <Widget>[
              ...weekWorkingHoursWidgets,
              if (workStatusMessage != null)
                ContentRow(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  leading: GeneralIcons.infoSquare.icon(color: context.colors.foregroundMuted),
                  text: ContentRowTextOptions(
                    title: context.l10n.extraInformation,
                    titleOptions: const ContentRowTextOption(maxLines: 99),
                    subtitle: workStatusMessage?.desc,
                    subtitleOptions: const ContentRowTextOption(maxLines: 99),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayGroup {
  final int startIndex;
  final int endIndex;
  final String workHours;
  final String? breakHours;

  const _DayGroup({required this.startIndex, required this.endIndex, required this.workHours, this.breakHours});
}

class _WorkTimeItemWidget extends StatelessWidget {
  final String dayTitle;
  final String workHours;
  final String? breakHours;
  final bool showDivider;

  const _WorkTimeItemWidget({
    required this.showDivider,
    required this.dayTitle,
    required this.workHours,
    this.breakHours,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: Spacing.$4x + AppSizes.xxs + Spacing.$3x),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
          child: Table(
            columnWidths: const {0: FlexColumnWidth(6), 1: FlexColumnWidth(8)},
            children: [
              TableRow(
                children: [
                  Text(dayTitle, style: context.textStyles.bodyLargeRegular),
                  Text(workHours, style: context.textStyles.bodyLargeRegular),
                ],
              ),
              if (breakHours != null)
                TableRow(
                  children: [
                    const SizedBox(),
                    Text(
                      breakHours!,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (showDivider) const _Divider(),
      ],
    ),
  );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Divider(color: context.colors.borderSoft.withOpacity(0.3), height: 8, thickness: 0.5);
}
