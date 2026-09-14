part of 'poi_makkah_widget_page.dart';

/// Makkah-style working hours tile that matches _MakkahOpenHoursCard layout
class _MakkahWorkingHoursTile extends StatelessWidget {
  final _MakkahPoiColors colors;
  final String title;
  final String? subtitle;

  const _MakkahWorkingHoursTile({
    required this.colors,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final displaySubtitle = (subtitle != null && subtitle!.isNotEmpty) ? subtitle : null;

    return _MakkahContentCard(
      colors: colors,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.iconBackground,
              borderRadius: BorderRadius.circular(RadiusBorder.baseSharp),
            ),
            child: Center(
              child: SvgPicture.asset(
                MakkahPoiConstants.clockIconPath,
                width: MakkahPoiConstants.addressIconSize,
                height: MakkahPoiConstants.addressIconSize,
                colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                matchTextDirection: true,
              ),
            ),
          ),
          const SizedBox(width: Spacing.$3x),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: colors.titleColor,
                    fontSize: 16,
                    height: 20 / 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (displaySubtitle != null) ...[
                  const SizedBox(height: Spacing.$0_5x),
                  Text(
                    displaySubtitle,
                    style: context.textStyles.bodySmallRegular.copyWith(
                      color: colors.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MakkahPoiWorkingHoursCard extends StatelessWidget {
  final WorkingHours workingHours;
  final _MakkahPoiColors colors;
  final String? workhoursHint;

  const MakkahPoiWorkingHoursCard({
    required this.workingHours,
    required this.colors,
    this.workhoursHint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final saudiWeekday = saudiTimeNow().weekday;

    String formatOpenClose(Iterable<Hours> hours) =>
        hours.map((h) => '${h.from.formatHHmm}-${h.till.formatHHmm}').join(',');

    String formatBreaks(Iterable<Hours> breakHours) =>
        breakHours.map((b) => '${b.from.formatHHmm}-${b.till.formatHHmm}').join(',');

    String todayWorkingHours() {
      final hours = workingHours.isOpen24x7
          ? l10n.twentyFourSeven
          : formatOpenClose(workingHours.todayHoursForDisplay(saudiWeekday));
      final todayOrDaily = workingHours.isSameEveryDay ? l10n.daily : l10n.today;
      return '$todayOrDaily $hours';
    }

    String? todayBreaks() {
      final breaks = workingHours.todayBreaksForDisplay(saudiWeekday);
      if (breaks.isNotEmpty) {
        final hours = formatBreaks(breaks);
        return l10n.breakHour(hours);
      }
      return null;
    }

    if (workingHours.isSameEveryDay) {
      return _MakkahWorkingHoursTile(
        colors: colors,
        title: todayWorkingHours(),
        subtitle: todayBreaks(),
      );
    }

    return _MakkahWorkingHoursExpandable(
      colors: colors,
      title: todayWorkingHours(),
      subtitle: todayBreaks(),
      workingHours: workingHours,
      formatOpenClose: formatOpenClose,
      formatBreaks: formatBreaks,
      workhoursHint: workhoursHint,
    );
  }
}

class _MakkahWorkingHoursExpandable extends StatefulWidget {
  final _MakkahPoiColors colors;
  final String title;
  final String? subtitle;
  final WorkingHours workingHours;
  final String Function(Iterable<Hours>) formatOpenClose;
  final String Function(Iterable<Hours>) formatBreaks;
  final String? workhoursHint;

  const _MakkahWorkingHoursExpandable({
    required this.colors,
    required this.title,
    this.subtitle,
    required this.workingHours,
    required this.formatOpenClose,
    required this.formatBreaks,
    this.workhoursHint,
  });

  @override
  State<_MakkahWorkingHoursExpandable> createState() => _MakkahWorkingHoursExpandableState();
}

class _MakkahWorkingHoursExpandableState extends State<_MakkahWorkingHoursExpandable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displaySubtitle = (widget.subtitle != null && widget.subtitle!.isNotEmpty) ? widget.subtitle : null;

    const weekDays = [
      DateTime.sunday,
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
    ];

    return _MakkahContentCard(
      colors: widget.colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: widget.colors.iconBackground,
                    borderRadius: BorderRadius.circular(RadiusBorder.baseSharp),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      MakkahPoiConstants.clockIconPath,
                      width: MakkahPoiConstants.addressIconSize,
                      height: MakkahPoiConstants.addressIconSize,
                      colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                      matchTextDirection: true,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.$3x),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: widget.colors.titleColor,
                          fontSize: 16,
                          height: 20 / 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (displaySubtitle != null) ...[
                        const SizedBox(height: Spacing.$0_5x),
                        Text(
                          displaySubtitle,
                          style: context.textStyles.bodySmallRegular.copyWith(
                            color: widget.colors.secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                    color: widget.colors.secondaryTextColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: Spacing.$3x),
            ...weekDays.map((weekday) {
              final periods = widget.workingHours.todayHoursForDisplay(weekday);
              final workHours = periods.isEmpty ? l10n.weekend : widget.formatOpenClose(periods);
              final breakHours = widget.formatBreaks(widget.workingHours.todayBreaksForDisplay(weekday));

              return _MakkahWorkTimeRow(
                colors: widget.colors,
                dayTitle: weekday.weekDayName(l10n).toCapitalized(),
                workHours: workHours,
                breakHours: breakHours.isNotEmpty ? breakHours : null,
                showDivider: weekday != weekDays.last,
              );
            }),
            if (widget.workhoursHint != null && widget.workhoursHint!.isNotEmpty) ...[
              const SizedBox(height: Spacing.$2x),
              _MakkahWorkHoursHintTile(colors: widget.colors, hint: widget.workhoursHint!),
            ],
          ],
        ],
      ),
    );
  }
}

class _MakkahWorkTimeRow extends StatelessWidget {
  final _MakkahPoiColors colors;
  final String dayTitle;
  final String workHours;
  final String? breakHours;
  final bool showDivider;

  const _MakkahWorkTimeRow({
    required this.colors,
    required this.dayTitle,
    required this.workHours,
    this.breakHours,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 50),
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
                    style: context.textStyles.bodySmallRegular.copyWith(
                      color: colors.titleColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    workHours,
                    style: context.textStyles.bodySmallRegular.copyWith(
                      color: colors.titleColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (breakHours != null)
                TableRow(
                  children: [
                    const SizedBox(),
                    Text(
                      breakHours!,
                      style: context.textStyles.bodySmallRegular.copyWith(
                        color: colors.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: colors.secondaryTextColor.withOpacity(0.2),
            height: 1,
            thickness: 1,
          ),
      ],
    ),
  );
}

class _MakkahWorkHoursHintTile extends StatelessWidget {
  final _MakkahPoiColors colors;
  final String hint;

  const _MakkahWorkHoursHintTile({required this.colors, required this.hint});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        color: colors.featureTileBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/makkah/info.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(colors.iconBackground, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.extraInformation,
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: colors.titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Spacing.$0_5x),
                Text(
                  hint,
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: colors.secondaryTextColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
