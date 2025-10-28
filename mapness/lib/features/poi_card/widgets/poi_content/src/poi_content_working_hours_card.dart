import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';

class PoiContentWorkingHoursCard extends StatelessWidget {
  final WorkingHours workingHours;
  final WorkStatusMessage? workStatusMessage;

  const PoiContentWorkingHoursCard({
    required this.workingHours,
    this.workStatusMessage,
    super.key,
  });

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
            leading: GeneralIcons.timeQuarter.icon(
              color: context.colors.accentDefault,
            ),
            text: ContentRowTextOptions(
              title: todayWorkingHours(),
              subtitle: todayBreaks(),
              subtitleOptions: ContentRowTextOption(
                baseColor: context.colors.foregroundSoft,
              ),
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

    final weekWorkingHoursWidgets = weekDays.map((weekday) {
      final periods = workingHours.todayHours(weekday);
      final workHours = periods.isEmpty ? l10n.weekend : formatOpenClose(periods);
      final breakHours = formatBreaks(workingHours.todayBreaks(weekday));

      return _WorkTimeItemWidget(
        dayTitle: weekday.weekDayName(l10n).toCapitalized(),
        workHours: workHours,
        breakHours: breakHours.isNotEmpty ? breakHours : null,
        showDivider: weekday != weekDays.last,
      );
    });

    return ContentWrapper(
      color: context.colors.backgroundSurface1,
      children: [
        ContentRowExpandable(
          padding: EdgeInsets.zero,
          expandIconColor: context.colors.foregroundMuted,
          // ignore: deprecated_member_use
          options: ContentRowOptions(
            title: todayWorkingHours(),
            subtitle: todayBreaks(),
            subtitleStyle: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            leadingIcon: GeneralIcons.timeQuarter.icon(
              color: context.colors.accentDefault,
            ),
          ),
          content: Column(
            children: <Widget>[
              ...weekWorkingHoursWidgets,
              if (workStatusMessage != null)
                ContentRow(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  leading: GeneralIcons.infoSquare.icon(
                    color: context.colors.foregroundMuted,
                  ),
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

class _WorkTimeItemWidget extends StatelessWidget {
  final String dayTitle;
  final String workHours;
  final String? breakHours;
  final bool showDivider;

  const _WorkTimeItemWidget(
      {required this.showDivider, required this.dayTitle, required this.workHours, this.breakHours});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.$4x + AppSizes.xxs + Spacing.$3x,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(6),
                  1: FlexColumnWidth(8),
                },
                children: [
                  TableRow(
                    children: [
                      Text(dayTitle, style: context.textStyles.bodyLargeRegular),
                      Text(workHours, style: context.textStyles.bodyLargeRegular),
                    ],
                  ),
                  if (breakHours != null)
                    TableRow(children: [
                      const SizedBox(),
                      Text(
                        breakHours!,
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                      ),
                    ]),
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
  Widget build(BuildContext context) => Divider(
        color: context.colors.borderSoft,
        height: 8,
        thickness: 1,
      );
}
