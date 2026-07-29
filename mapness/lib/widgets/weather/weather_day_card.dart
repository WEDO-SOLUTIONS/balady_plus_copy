import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/features/weather/helpers/weather_date.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/weather/custom_svg_icon_widget.dart';
import 'package:mapness/widgets/weather/expansion_tile.dart';

class WeatherDayCard extends ConsumerWidget {
  final ForecastDay? forecastDay;
  final bool isExpanded;
  // ignore: avoid_positional_boolean_parameters
  final Function(bool expanded) onExpansionChanged;

  const WeatherDayCard({
    required this.forecastDay,
    required this.isExpanded,
    required this.onExpansionChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLanguageProvider).locale;
    final styles = context.textStyles;
    final nowTime = DateTime.now();
    final isToday = WeatherDateFormatter.isToday(forecastDay?.date ?? '2022-01-01', locale);
    final dayText = isToday
        ? context.l10n.today
        : WeatherDateFormatter.getDay(forecastDay?.date ?? '2022-01-01', locale);
    final conditionIconPath = forecastDay?.day?.condition?.iconPath ?? '';
    final conditionText = forecastDay?.day?.condition?.text ?? '';

    final maxTemp = context.digits('${forecastDay?.day?.maxTempC}º');

    final minTemp = context.digits('${forecastDay?.day?.minTempC}º');

    return CustomExpansionTile(
      collapsedBackgroundColor: context.colors.backgroundSurface1,
      backgroundColor: context.colors.backgroundSurface1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusBorder.l)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusBorder.l)),
      key: UniqueKey(),
      hasIcon: false,
      onExpansionChanged: onExpansionChanged,
      initiallyExpanded: isExpanded,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      dayText,
                      style: styles.captionMediumRegular.copyWith(color: context.colors.foregroundDefault),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  CustomSvgIconWidget(conditionIconPath, iconSize: 24, iconColor: context.colors.accentOnContainer),
                  const SizedBox(width: Spacing.$1x),
                  Expanded(
                    child: AutoSizeText(
                      conditionText,
                      style: styles.bodySmallSemiBold.copyWith(color: context.colors.foregroundDefault),
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
                    style: styles.bodySmallSemiBold.copyWith(color: context.colors.foregroundDefault),
                    maxLines: 1,
                  ),
                  const SizedBox(width: Spacing.$1_5x),
                  Text(
                    minTemp,
                    textDirection: TextDirection.ltr,
                    style: styles.captionMediumRegular.copyWith(color: context.colors.foregroundDefault),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      children: [
        SizedBox(
          height: 100,
          child: ListView(
            padding: const EdgeInsets.only(right: Spacing.$4x, left: Spacing.$1x),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              ...?forecastDay?.hour
                  ?.where((hour) {
                    if (isToday == false) {
                      return true;
                    }
                    return DateTime.parse(hour.time ?? '').hour >= nowTime.hour;
                  })
                  .map<Widget>((hour) {
                    final dateTime = DateTime.parse(hour.time ?? '');
                    final time = context.digits(DateFormat('hh:mm').format(dateTime));

                    final formatter = NumberFormat()
                      ..minimumFractionDigits = 0
                      ..maximumFractionDigits = 1;
                    final temperature = context.digits('${formatter.format(hour.tempC?.toInt())}ºC');

                    return Padding(
                      padding: const EdgeInsets.only(left: Spacing.$3x),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: context.colors.accentContainerDefault,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SvgPicture.asset(
                                hour.condition?.iconPath ?? '',
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(context.colors.accentOnContainer, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          Spacing.$0_5x.heightBox,
                          Center(
                            child: Text(
                              time,
                              style: styles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
                            ),
                          ),
                          Spacing.$0_5x.heightBox,
                          Center(
                            child: Text(
                              temperature,
                              style: styles.bodySmallSemiBold.copyWith(color: context.colors.foregroundDefault),
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
