import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show WeatherDateFormatter;
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/weather/presentation/widgets/expansion_tile.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/weather_date.dart';
import '../../../_shared_feature_/shared_feature_exports.dart' show CustomAutoSizeTextWidget, CustomTextWidget;

class WeatherDayCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: CustomExpansionTile(
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
                  child: CustomTextWidget(
                    WeatherDateFormatter.isToday(forecastDay?.date ?? '2022-01-01')
                        ? 'today'.tr()
                        : WeatherDateFormatter.getDay(forecastDay?.date ?? '2022-01-01'),
                    fontColor: AppColor.blackModern800Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 16,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      CustomSvgIconWidget(forecastDay?.day?.condition?.iconPath ?? '', iconSize: 26),
                      CustomAutoSizeTextWidget(
                        forecastDay?.day?.condition?.text ?? '',
                        fontColor: AppColor.blackModern800Light,
                        fontWeight: AppFontWeight.bold,
                        minFontSize: 10,
                        maxFontSize: 13,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CustomTextWidget(
                      '${forecastDay?.day?.maxtempC.toString()} º',
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(width: 20),
                    CustomTextWidget(
                      '${forecastDay?.day?.mintempC.toString()} º',
                      fontColor: AppColor.blackModern600Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 14,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.separated(
                  separatorBuilder: (_, _) => const SizedBox(width: 24),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    var hour = forecastDay?.hour?.elementAt(index);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          ' ${hour?.time?.split(" ")[1].split(":")[0].tr()}',
                          fontColor: AppColor.blackModern600Light,
                          fontWeight: AppFontWeight.bold,
                          fontSize: 10,
                        ),
                        const SizedBox(height: 4),
                        CustomSvgIconWidget(hour?.condition?.iconPath ?? '', iconSize: 40),
                        const SizedBox(height: 4),
                        CustomTextWidget(
                          '${hour?.tempC.toString()} º',
                          fontColor: AppColor.blackModern600Light,
                          fontSize: 14,
                          fontWeight: AppFontWeight.bold,
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
