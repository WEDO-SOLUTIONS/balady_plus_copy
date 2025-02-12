import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SunriseOrSunsetTime extends StatelessWidget {
  final String time;
  final String icon;

  const SunriseOrSunsetTime({
    required this.time,
    required this.icon,
    super.key,
  });

  const SunriseOrSunsetTime.sunrise({
    required this.time,
    super.key,
    this.icon = 'assets/icons/svg/weather/sunrise.svg',
  });

  const SunriseOrSunsetTime.sunset({
    required this.time,
    super.key,
    this.icon = 'assets/icons/svg/weather/sunset.svg',
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(
            height: 10,
          ),
          Text(
            time,
            // fontSize: 14,
            // fontWeight: FontWeight.bold,
          ),
        ],
      );
}
