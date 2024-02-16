import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/weather/domain/entities/weather_info.dart';
import 'package:mapness/_features/weather/weather_date.dart';
import 'package:mapness/_features/weather/widgets/custom_svg_icon_widget.dart';
import 'package:mapness/_features/weather/widgets/expansion_tile.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class WeatherDayCard extends ConsumerWidget {
  const WeatherDayCard({
    required this.forecastDay,
    required this.isExpanded,
    required this.onExpansionChanged,
    super.key,
  });

  final ForecastDay? forecastDay;
  final bool isExpanded;
  // ignore: avoid_positional_boolean_parameters
  final Function(bool expanded) onExpansionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLanguageProvider).locale;
    final style = context.textStyle;
    final nowTime = DateTime.now();
    final isToday =
        WeatherDateFormatter.isToday(forecastDay?.date ?? '2022-01-01', locale);
    final dayText = isToday
        ? context.l10n.today
        : WeatherDateFormatter.getDay(
            forecastDay?.date ?? '2022-01-01', locale);
    final conditionIconPath = forecastDay?.day?.condition?.iconPath ?? '';
    final conditionText = forecastDay?.day?.condition?.text ?? '';

    final maxTemp = '${forecastDay?.day?.maxtempC.toString()}º';

    final minTemp = '${forecastDay?.day?.mintempC.toString()}º';

    return CustomExpansionTile(
      collapsedBackgroundColor: const Color(0xFFF5F7FA),
      backgroundColor: const Color(0xffE4F2F1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
        12,
      )),
      collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
        12,
      )),
      key: UniqueKey(),
      hasIcon: false,
      onExpansionChanged: onExpansionChanged,
      initiallyExpanded: isExpanded,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                dayText,
                style: style.accentM.copyWith(
                  color: colorPrimary,
                ),
                maxLines: 1,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  CustomSvgIconWidget(
                    conditionIconPath,
                    iconSize: 16,
                    iconColor: const Color(0xff4CA5B4),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      conditionText,
                      style: style.accentM.copyWith(
                        color: colorPrimary,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    maxTemp,
                    textDirection: TextDirection.ltr,
                    style: style.accentS.copyWith(
                      color: colorPrimary,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    minTemp,
                    textDirection: TextDirection.ltr,
                    style: style.textXS.copyWith(
                      color: colorPrimary,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      children: [
        SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ...?forecastDay?.hour?.where((hour) {
                    if (isToday == false) {
                      return true;
                    }
                    return DateTime.parse(hour.time ?? '').hour >= nowTime.hour;
                  }).map<Widget>((hour) {
                    final dateTime = DateTime.parse(hour.time ?? '');
                    final time = DateFormat('hh:mm').format(dateTime);

                    final formatter = NumberFormat()
                      ..minimumFractionDigits = 0
                      ..maximumFractionDigits = 1;
                    final temperature = '${formatter.format(hour.tempC)}º';

                    return Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SvgPicture.asset(
                                hour.condition?.iconPath ?? '',
                                height: 24,
                                width: 24,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xff4CA5B4),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: Text(
                              time,
                              style: style.textXS.copyWith(
                                color: const Color(0x5B1E2A36),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              temperature,
                              style: style.accentS.copyWith(
                                color: colorPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ))
      ],
    );
  }
}
