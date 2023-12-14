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
    super.key,
    required this.forecastDay,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  final ForecastDay? forecastDay;
  final bool isExpanded;
  final Function(bool expanded) onExpansionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref
        .watch(appLanguageProvider)
        .locale;
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
      collapsedBackgroundColor: Color(0xFFF5F7FA),
      backgroundColor: Color(0xffE4F2F1),
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
              flex: 1,
              child: Text(
                dayText,
                style: style.accentM.copyWith(
                  color: colorPrimary,
                ),
                maxLines: 1,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  CustomSvgIconWidget(
                      conditionIconPath,
                      iconSize: 16,
                      iconColor: const Color(0xff4CA5B4),
                  ),
                  const SizedBox(width: 8,),
                  Text(
                    conditionText,
                    style: style.accentM.copyWith(
                      color: colorPrimary,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    child: Text(
                      maxTemp,
                      style: style.accentS.copyWith(
                        color: colorPrimary,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 38,
                    child: Text(
                      minTemp,
                      textDirection: TextDirection.ltr,
                      style: style.textXS.copyWith(
                        color: colorPrimary,
                      ),
                      maxLines: 1,
                    ),
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
                // itemCount: 24,
                // separatorBuilder: (_, __) => const SizedBox(width: 12),
                // itemBuilder: (ctx, index) {},
                children: [
                  ...?forecastDay?.hour?.where((hour) {
                    if (isToday == false) return true;
                    return DateTime
                        .parse(hour.time ?? '')
                        .hour >= nowTime.hour;
                  }).map<Widget>((hour) {
                    // var hour = forecastDay?.hour?.elementAt(index);
                    // var time = hour?.time??'';
                    final dateTime = DateTime.parse(hour.time ?? '');
                    final time = (DateFormat('hh:mm').format(dateTime));

                    final formatter = NumberFormat()
                      ..minimumFractionDigits = 0
                      ..maximumFractionDigits = 1;
                    final temperature = '${formatter.format(hour.tempC)}º';

                    return Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                color: const Color(0xff4CA5B4),
                                // color: Color(0xff4CA5B4),
                                // iconFit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: Text(
                              // ' ${hour?.time?.split(" ")[1].split(":")[0]}',
                              time,
                              style: style.textXS.copyWith(
                                color: Color(0x5B1E2A36),
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
