import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(8),
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(37),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackModern900Light.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "$temperature°",
            style: AppStyle.mainTextStyle.copyWith(
              color: AppColor.blackModern900Light,
            ),
          ),
          DrawIconBasedTypeWidget(
            icon: weatherCondition.icon,
            iconSize: 40,
          ),
        ],
      ),
    );
  }
}
