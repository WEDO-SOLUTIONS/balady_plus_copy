import 'package:balady_plus/app/core/utils/extensions/str_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';

Widget _makkahWorkingHoursIcon({Color? backgroundColor}) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: backgroundColor ?? const Color(0xFFD19D3F),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(Spacing.$1x),
      child: SvgPicture.asset(
        'assets/icons/makkah/clock.svg',
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(
          Color(0xFFFFFFFF),
          BlendMode.srcIn,
        ),
        matchTextDirection: true,
      ),
    ),
  );
}

/// Makkah-style working hours tile that matches _MakkahFeatureTile layout
class _MakkahWorkingHoursTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color iconBackgroundColor;
  final Color tileBackgroundColor;
  final VoidCallback? onTap;
  final bool showChevron;

  const _MakkahWorkingHoursTile({
    required this.title,
    required this.iconBackgroundColor,
    required this.tileBackgroundColor,
    this.subtitle,
    this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    const iconSize = 20.0;
    const iconContainerSize = 28.0;
    const iconSlotSize = 36.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
          color: tileBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsetsDirectional.only(
          start: 26,
          end: Spacing.$3x,
          top: Spacing.$2x,
          bottom: Spacing.$2x,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: iconSlotSize,
              height: iconSlotSize,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: SizedBox(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/makkah/clock.svg',
                        width: iconSize,
                        height: iconSize,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFFFFF),
                          BlendMode.srcIn,
                        ),
                        matchTextDirection: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _makkahWorkingHoursTextStyle(
                      context,
                      color: context.colors.foregroundDefault,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: Spacing.$0_5x),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _makkahWorkingHoursTextStyle(
                        context,
                        color: context.colors.foregroundSoft,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: context.colors.foregroundMuted,
              ),
          ],
        ),
      ),
    );
  }
}

TextStyle _makkahWorkingHoursTextStyle(BuildContext context, {required Color color}) {
  return context.textStyles.bodySmallRegular.copyWith(
    fontSize: 14,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );
}

class PoiContentWorkingHoursCard extends StatelessWidget {
  final WorkingHours workingHours;
  final WorkStatusMessage? workStatusMessage;
  final Color? makkahIconBackgroundColor;
  final Color? makkahTileBackgroundColor;
  final EdgeInsetsGeometry? makkahInnerPadding;

  const PoiContentWorkingHoursCard({
    required this.workingHours,
    this.workStatusMessage,
    this.makkahIconBackgroundColor,
    this.makkahTileBackgroundColor,
    this.makkahInnerPadding,
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

    final isMakkahMode = makkahIconBackgroundColor != null && makkahTileBackgroundColor != null;

    if (workingHours.isSameEveryDay) {
      if (isMakkahMode) {
        return _MakkahWorkingHoursTile(
          title: todayWorkingHours(),
          subtitle: todayBreaks(),
          iconBackgroundColor: makkahIconBackgroundColor!,
          tileBackgroundColor: makkahTileBackgroundColor!,
        );
      }
      return ContentWrapper(
        color: context.colors.backgroundSurface1,
        children: [
          Padding(
            padding: makkahInnerPadding ?? EdgeInsets.zero,
            child: ContentRow(
              leading: _makkahWorkingHoursIcon(backgroundColor: makkahIconBackgroundColor),
              text: ContentRowTextOptions(
                titleOptions: ContentRowTextOption(
                  builder: (context) => Text(
                    todayWorkingHours(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: _makkahWorkingHoursTextStyle(
                      context,
                      color: context.colors.foregroundDefault,
                    ),
                  ),
                ),
                subtitleOptions: todayBreaks() == null
                    ? null
                    : ContentRowTextOption(
                        builder: (context) => Text(
                          todayBreaks()!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: _makkahWorkingHoursTextStyle(
                            context,
                            color: context.colors.foregroundSoft,
                          ),
                        ),
                      ),
                title: '',
                subtitle: '',
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
          padding: makkahInnerPadding ?? EdgeInsets.zero,
          crossAxisAlignment: CrossAxisAlignment.center,
          expandIconColor: context.colors.foregroundMuted,
          // ignore: deprecated_member_use
          options: ContentRowOptions(
            title: todayWorkingHours(),
            subtitle: todayBreaks(),
            titleBuilder: (context) => Text(
              todayWorkingHours(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: _makkahWorkingHoursTextStyle(
                context,
                color: context.colors.foregroundDefault,
              ),
            ),
            subtitleBuilder: todayBreaks() == null
                ? null
                : (context) => Text(
                      todayBreaks()!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: _makkahWorkingHoursTextStyle(
                        context,
                        color: context.colors.foregroundSoft,
                      ),
                    ),
            leadingIcon: _makkahWorkingHoursIcon(backgroundColor: makkahIconBackgroundColor),
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
                      Text(
                        dayTitle,
                        style: _makkahWorkingHoursTextStyle(
                          context,
                          color: context.colors.foregroundDefault,
                        ),
                      ),
                      Text(
                        workHours,
                        style: _makkahWorkingHoursTextStyle(
                          context,
                          color: context.colors.foregroundDefault,
                        ),
                      ),
                    ],
                  ),
                  if (breakHours != null)
                    TableRow(children: [
                      const SizedBox(),
                      Text(
                        breakHours!,
                        style: _makkahWorkingHoursTextStyle(
                          context,
                          color: context.colors.foregroundSoft,
                        ),
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
