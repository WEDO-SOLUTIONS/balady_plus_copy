import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class WeatherControl extends ConsumerWidget {
  const WeatherControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWeatherInfoModel = ref.watch(forecastWeatherProvider);

    return buildContent(
      context: context,
      data: allWeatherInfoModel,
      onTap: () {
        Metrics.logEventAdvanced(
          MetricsConstants.exploreKeys.weatherIcon,
          action: MetricAction.tap.name,
          group: MetricsConstants.exploreTag,
        );

        context.router.push(const WeatherRoute());
      },
    );
  }

  MapButton buildContent({
    required BuildContext context,
    required VoidCallback onTap,
    AllWeatherInfoModel? data,
  }) {
    final tempC2 = data?.current?.tempC;
    final temp = tempC2 == null ? '30°' : '${tempC2.toInt()}°';
    return MapButton(
      onTap: onTap,
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/svg/weather/sun.svg',
            package: PackageConfig.packageName,
            width: 16,
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1),
            child: Text(
              temp,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: context.textStyle.text.copyWith(
                color: context.color.textAndIconsBasePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
