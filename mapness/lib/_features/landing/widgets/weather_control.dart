import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';

import '../../../shared/ui/buttons/map_button.dart';

class WeatherControl extends ConsumerWidget {
  const WeatherControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapButton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/svg/ic_weather_sun.svg',
            package: PackageConfig.packageName,
            width: 16,
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              "53°",
              textAlign: TextAlign.center,
              style: PackageFonts.frutigerArabic(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                // letterSpacing: 0.18,
              ),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
