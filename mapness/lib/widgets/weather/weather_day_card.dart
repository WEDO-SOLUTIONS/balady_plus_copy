import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/weather/expansion_tile.dart';

/// One forecast day; expands into the hourly forecast.
class WeatherDayCard extends StatelessWidget {
  const WeatherDayCard({required this.forecastDay, required this.languageCode, super.key});

  final ForecastDay forecastDay;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    final date = DateTime.tryParse(forecastDay.date ?? '');
    final isToday = date != null && DateUtils.isSameDay(date, DateTime.now());
    final dayText = isToday
        ? context.l10n.today
        : date == null
        ? ''
        : DateFormat('EEE', languageCode).format(date);
    final condition = forecastDay.day?.condition;
    final maxTemp = forecastDay.day?.maxTempC?.round();
    final minTemp = forecastDay.day?.minTempC?.round();

    return CustomExpansionTile(
      collapsedBackgroundColor: colors.backgroundSurface1,
      backgroundColor: colors.backgroundSurface1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusBorder.l)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusBorder.l)),
      clipBehavior: Clip.antiAlias,
      hasIcon: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 48),
              child: Text(
                dayText,
                maxLines: 1,
                style: styles.captionMediumRegular.copyWith(color: colors.foregroundDefault),
              ),
            ),
            const SizedBox(width: Spacing.$2x),
            _ConditionIcon(condition: condition, size: 28),
            const SizedBox(width: Spacing.$2x),
            Expanded(
              child: Text(
                condition?.text ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styles.bodySmallSemiBold.copyWith(color: colors.foregroundDefault),
              ),
            ),
            const SizedBox(width: Spacing.$2x),
            Text.rich(
              TextSpan(
                text: maxTemp == null ? '–' : '$maxTemp°',
                style: styles.bodySmallSemiBold.copyWith(color: colors.foregroundDefault),
                children: [
                  TextSpan(
                    text: minTemp == null ? '' : '  $minTemp°',
                    style: styles.captionMediumRegular.copyWith(color: colors.foregroundSoft),
                  ),
                ],
              ),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ),
      children: [
        _HourlyForecast(
          hours: _hoursToShow(isToday: isToday),
          languageCode: languageCode,
        ),
      ],
    );
  }

  /// Today starts from the current hour; past hours are of no use.
  List<Hour> _hoursToShow({required bool isToday}) {
    final hours = forecastDay.hour ?? const <Hour>[];
    if (!isToday) {
      return hours;
    }
    final currentHour = DateTime.now().hour;
    return [
      for (final hour in hours)
        if ((DateTime.tryParse(hour.time ?? '')?.hour ?? currentHour) >= currentHour) hour,
    ];
  }
}

class _HourlyForecast extends StatelessWidget {
  const _HourlyForecast({required this.hours, required this.languageCode});

  static const _itemWidth = 56.0;

  final List<Hour> hours;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    // Locale-aware hour ("14", "2 PM", "٢ م") — `hh:mm` dropped AM/PM and read ambiguously.
    final timeFormat = DateFormat.j(languageCode);

    return SizedBox(
      height: 104,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(Spacing.$4x, 0, Spacing.$4x, Spacing.$3x),
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.$2x),
        itemBuilder: (context, index) {
          final hour = hours[index];
          final time = DateTime.tryParse(hour.time ?? '');
          final temperature = hour.tempC?.round();

          return SizedBox(
            width: _itemWidth,
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusBorder.m),
                    color: colors.accentContainerDefault,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.$2x),
                    child: _ConditionIcon(condition: hour.condition, size: 32),
                  ),
                ),
                const SizedBox(height: Spacing.$1x),
                Text(
                  time == null ? '' : timeFormat.format(time),
                  maxLines: 1,
                  style: styles.captionMediumRegular.copyWith(color: colors.foregroundSoft),
                ),
                Text(
                  temperature == null ? '–' : '$temperature°',
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                  style: styles.bodySmallSemiBold.copyWith(color: colors.foregroundDefault),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Weather condition icon in its original colours; nothing if the forecast has no icon for it.
class _ConditionIcon extends StatelessWidget {
  const _ConditionIcon({required this.condition, required this.size});

  final Condition? condition;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconPath = condition?.iconPath ?? '';
    return SizedBox.square(
      dimension: size,
      child: iconPath.isEmpty ? null : SvgPicture.asset(iconPath, width: size, height: size),
    );
  }
}
