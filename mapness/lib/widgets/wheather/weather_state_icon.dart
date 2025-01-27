import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/wheather/weather_enum.dart';
import 'package:mapness/features/weather/helpers/widget_ref_weather_extension.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class WeatherStateIcon extends ConsumerWidget {
  const WeatherStateIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherMapState = ref.watch(weatherMapControllerProvider());
    final type = weatherMapState.type;

    final iconRes = switch (type) {
      WeatherMapType.temperature => WeatherMapType.precipitation.iconRes(),
      WeatherMapType.precipitation => WeatherMapType.temperature.iconRes(),
    };

    return MapButton(
      onTap: () {
        ref.toggleWeatherMap(
          type: type == WeatherMapType.temperature ? WeatherMapType.precipitation : WeatherMapType.temperature,
          enable: true,
        );
      },
      child: SvgPicture.asset(
        iconRes,
        semanticsLabel: 'weather page',
        package: 'mapness',
      ),
    );
  }
}
