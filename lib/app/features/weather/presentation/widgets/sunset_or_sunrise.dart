import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AppFontWeight, IconPath;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;

class SunriseOrSunsetTime extends StatelessWidget {
  const SunriseOrSunsetTime(
      {super.key, required this.time, required this.icon});

  const SunriseOrSunsetTime.sunrise({
    super.key,
    required this.time,
    this.icon = IconPath.sunrise,
  });

  const SunriseOrSunsetTime.sunset({
    super.key,
    required this.time,
    this.icon = IconPath.sunset,
  });

  final String time;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(icon),
        const SizedBox(
          height: 10,
        ),
        CustomTextWidget(
          time,
          fontSize: 14,
          fontWeight: AppFontWeight.bold,
        ),
      ],
    );
  }
}
