import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show IconPath, WeatherDateFormatter;
import 'package:balady_plus/app/features/weather/presentation/widgets/expansion_tile.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/weather_date.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: CustomExpansionTile(
          key: UniqueKey(),
          hasIcon: false,
          onExpansionChanged: onExpansionChanged,
          initiallyExpanded: isExpanded,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextWidget(
                  WeatherDateFormatter.isToday(
                          forecastDay?.date ?? '2022-01-01')
                      ? 'today'.tr()
                      : WeatherDateFormatter.getDay(
                          forecastDay?.date ?? '2022-01-01'),
                  fontColor: AppColor.blackModern700Light,
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Image.network(
                  'https:${forecastDay?.day?.condition?.icon}',
                  height: 26,
                  width: 26,
                ),
              ),
              Row(
                children: [
                  CustomTextWidget(
                    '${forecastDay?.day?.maxtempC.toString()} º',
                    fontColor: Colors.black,
                    fontSize: 14,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomTextWidget(
                    '${forecastDay?.day?.mintempC.toString()} º',
                    fontColor: Colors.black,
                    fontSize: 14,
                    textDirection: TextDirection.ltr,
                  ),
                ],
              )
            ],
          ),
          children: [
            SizedBox(
                height: 155,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    var hour = forecastDay?.hour?.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextWidget(
                            ' ${hour?.time?.split(" ")[1].split(":")[0].tr()}',
                            fontColor: Colors.black,
                            fontSize: 10,
                          ),
                          Image.network(
                            'https:${hour?.condition?.icon}',
                          ),
                          CustomTextWidget(
                            '${hour?.tempC.toString()} º',
                            fontColor: Colors.black,
                            fontSize: 14,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
