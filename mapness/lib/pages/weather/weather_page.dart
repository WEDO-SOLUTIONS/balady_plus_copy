import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/weather/weather_dashboard.dart';
import 'package:provider/provider.dart';

@RoutePage()
class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  // Captured up front: the weather layer is switched off in [dispose], where `ref` is no longer usable.
  DgisMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = ref.read(dgisControllerProvider).value;
    ref.read(weatherMapControllerProvider().notifier).toggleWeatherMap(enable: true, type: WeatherMapType.temperature);
  }

  @override
  void dispose() {
    // Covers every way out (close button, system back, swipe-down), not only the close button.
    unawaited(_mapController?.toggleHeatmap(message: WeatherMapMessage(enabled: false)));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forecast = ref.watch(forecastWeatherProvider);
    if (forecast == null) {
      return ErrorSheetWidget(
        onRetry: () => ref.read(forecastWeatherProvider.notifier).forceRefresh(),
        onClose: (_) => context.router.pop(),
        buttonLabel: context.l10n.tryAgain,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.watch<ThemeController>().systemOverlayStyle,
      child: Material(
        type: MaterialType.transparency,
        child: WeatherDashboard(forecast: forecast, onClose: () => context.router.pop()),
      ),
    );
  }
}
