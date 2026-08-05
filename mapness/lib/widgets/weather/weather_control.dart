import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

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

  Widget buildContent({
    required BuildContext context,
    required VoidCallback onTap,
    AllWeatherInfoEntity? data,
  }) {
    final tempC2 = data?.current?.tempC;
    final temp = tempC2 == null ? 30 : tempC2.toInt();

    return Semantics(
      label: context.l10n.a11yWeather,
      button: true,
      child: ExcludeSemantics(
        child: uikit.WeatherControl(
          value: temp,
          onTap: onTap,
        ),
      ),
    );
  }
}
