import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/provider/current_weather_provider.dart';
import 'package:mapness/shared/config/package_config.dart';

import '../../../shared/ui/buttons/map_button.dart';

class WeatherControl extends ConsumerWidget {
  final VoidCallback? onTap;

  const WeatherControl({this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(currentWeatherProvider);

    return buildContent(
        context: context, data: weatherData, onTap: () => onTap?.call());
  }

  MapButton buildContent({
    required BuildContext context,
    AllWeatherInfoModel? data,
    required VoidCallback onTap,
  }) {
    var tempC2 = data?.current?.tempC;
    var temp = tempC2 == null ? '30°' : '${tempC2.toInt()}°';
    return MapButton(
      onTap: onTap,
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
              temp,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textM
                  .copyWith(
                    color: const Color(0xFF1E2A36),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
