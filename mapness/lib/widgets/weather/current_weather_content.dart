import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/widgets/weather/custom_svg_icon_widget.dart';
import 'package:mapness/widgets/weather/sunset_or_sunrise.dart';
import 'package:mapness/widgets/weather/wind_and_vision_card.dart';

class CurrentWeatherContent extends ConsumerWidget {
  const CurrentWeatherContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWeatherInfo = ref.watch(forecastWeatherProvider);
    final currentTempC = allWeatherInfo?.current?.tempC?.floor() ?? 0;
    final currentConditionText = allWeatherInfo?.current?.condition?.text ?? '';
    final currentConditionIconPath = allWeatherInfo?.current?.condition?.iconPath ?? '';
    final sunriseTime = allWeatherInfo?.forecast?.forecastday?[0].astro?.sunrise?.replaceAll('AM', '') ?? '';
    final sunsetTime = allWeatherInfo?.forecast?.forecastday?[0].astro?.sunset?.replaceAll('PM', '') ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [NonThemeColor.color68, NonThemeColor.color69],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            CustomSvgIconWidget(
              currentConditionIconPath,
              iconSize: 56,
              iconColor: Colors.white,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text('C'),
                ),
                const SizedBox(width: 1),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('°'),
                ),
                Text(
                  currentTempC.toString(),
                ),
                const SizedBox(width: 8),
                Text(
                  currentConditionText,
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
            ),
            const SizedBox(
              height: 8,
            ),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SunriseOrSunsetTime.sunrise(time: sunriseTime),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                      child: VerticalDivider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                    ),
                    SunriseOrSunsetTime.sunset(time: sunsetTime),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const WindAndWeatherCard(),
          ],
        ),
      ),
    );
  }
}
