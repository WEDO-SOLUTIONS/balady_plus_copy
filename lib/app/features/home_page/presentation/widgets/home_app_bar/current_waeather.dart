import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, WeathherConditions;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show DrawIconBasedTypeWidget;

class CurrentWeather extends StatelessWidget {
  final WeathherConditions weatherCondition;
  final String temperature;

  const CurrentWeather({
    super.key,
    required this.weatherCondition,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 16),
      child: Row(
        children: [
          DrawIconBasedTypeWidget(
            icon: weatherCondition.icon,
            iconSize: 28,
          ),
          const SizedBox(width: 6),
          Column(
            children: [
              Text(
                "$temperature°",
                style: AppStyle.mainTextStyle.copyWith(
                  color: AppColor.blackModern600Light,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Text(
                weatherCondition.label.tr(),
                style: AppStyle.mainTextStyle.copyWith(
                  color: AppColor.blackModern600Light,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
