import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/weather/weather_type_ext.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class WeatherStateIcon extends ConsumerWidget {
  const WeatherStateIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherMapState = ref.watch(weatherMapControllerProvider());
    final type = weatherMapState.type;

    final iconRes = switch (type) {
      WeatherMapType.temperature => WeatherMapType.precipitation.iconRes(),
      WeatherMapType.precipitation => WeatherMapType.temperature.iconRes(),
    };

    return MapButton(
      semanticsLabel: context.l10n.a11yWeather,
      onTap: () {
        ref
            .read(weatherMapControllerProvider().notifier)
            .toggleWeatherMap(
              enable: true,
              type: type == WeatherMapType.temperature ? WeatherMapType.precipitation : WeatherMapType.temperature,
            );
      },
      child: ExcludeSemantics(
        child: SvgPicture.asset(
          iconRes,
          color: context.colors.foregroundDefault,
        ),
      ),
    );
  }
}
