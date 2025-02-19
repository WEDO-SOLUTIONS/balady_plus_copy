import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';

class WindAndWeatherCard extends ConsumerWidget {
  const WindAndWeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWeatherInfo = ref.watch(forecastWeatherProvider);

    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.white,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/svg/weather/wind_speed.svg',
                      width: 21,
                      height: 21,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${allWeatherInfo?.current?.windKph.toString() ?? ''} k/h',
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/svg/weather/humedity.svg',
                      width: 15,
                      height: 15,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        allWeatherInfo?.current?.humidity.toString() ?? '',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/svg/weather/eye.svg',
                      width: 21,
                      height: 21,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${allWeatherInfo?.current?.visKm.toString() ?? ''} km',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
