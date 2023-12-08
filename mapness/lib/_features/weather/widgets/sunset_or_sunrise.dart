import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SunriseOrSunsetTime extends StatelessWidget {
  const SunriseOrSunsetTime(
      {super.key, required this.time, required this.icon});

  const SunriseOrSunsetTime.sunrise({
    super.key,
    required this.time,
    this.icon = "assets/icons/svg/weather/sunrise.svg",
  });

  const SunriseOrSunsetTime.sunset({
    super.key,
    required this.time,
    this.icon = "assets/icons/svg/weather/sunset.svg",
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
        Text(
          time,
          // fontSize: 14,
          // fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
