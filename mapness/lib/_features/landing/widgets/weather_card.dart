import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/app/routes/weather.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class WeatherCard extends ConsumerStatefulWidget {
  const WeatherCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherCardState();
}

class _WeatherCardState extends ConsumerState<WeatherCard> {
  double highestTemperatures = 0;
  double lowestTemperatures = double.infinity;

  @override
  void initState() {
    super.initState();
    ref.listenManual(forecastWeatherProvider, (prevData, weatherData) {
      if (prevData?.forecast?.forecastday == weatherData?.forecast?.forecastday) {
        return;
      }
      setState(() {
        final dayTemperatures = weatherData?.forecast?.forecastday?.firstOrNull?.hour ?? [];

        for (final day in dayTemperatures) {
          if (highestTemperatures < (day.tempC ?? 0)) {
            highestTemperatures = day.tempC ?? highestTemperatures;
          } else if (lowestTemperatures > (day.tempC ?? double.infinity)) {
            lowestTemperatures = day.tempC ?? lowestTemperatures;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(forecastWeatherProvider);
    final conditionLabel = weatherData?.current?.condition?.text?.toString() ?? '-';
    final currentTemperature = weatherData?.current?.tempC?.toInt();

    final rightPadding = context.isLTR ? Spacing.none : Spacing.$4x;
    final leftPadding = context.isLTR ? Spacing.$4x : Spacing.none;

    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusBorder.xl),
      child: GestureDetector(
        onTap: () {
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.weatherIcon,
            action: MetricAction.tap.name,
            group: MetricsConstants.layersTag,
          );
          const WeatherRoute().push(context);
        },
        child: SizedBox(
          height: 118,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF42B6E7), Color(0xFF0B9EDE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Spacing.$3x, left: leftPadding, right: rightPadding),
                        child: Text(
                          '${currentTemperature ?? '-'}°',
                          style: context.textStyleV3.h2Medium.copyWith(
                            color: context.colorsV2.staticWhite,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: Spacing.$4x, left: leftPadding, right: rightPadding),
                        child: Text(
                          '$conditionLabel\n'
                          '${context.l10n.weatherTemperature(
                            highestTemperatures != 0 ? highestTemperatures.toInt() : '-',
                            lowestTemperatures != double.infinity ? lowestTemperatures.toInt() : '-',
                          )}',
                          style: context.textStyleV3.captionLargeRegular.copyWith(
                            color: context.colorsV2.staticWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                    child: SvgPicture.asset(
                      'assets/images_svg/weather-sunny.svg',
                      package: PackageConfig.packageName,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
