import 'package:mapness/shared/providers/theme_controller.dart';
import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/weather/weather_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  late final MultiStateSheetController<ThreeStateSheet> _bottomSheetController = MultiStateSheetController(
    initialState: ThreeStateSheet.open,
    behavior: FractionSnappingBehavior(fractions: {.1, _computeMiddleFraction(), .931}),
    stateMapper: const ThreeStateMapper(),
  );

  @override
  void initState() {
    ref.read(weatherMapControllerProvider().notifier).toggleWeatherMap(enable: true, type: WeatherMapType.temperature);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(forecastWeatherProvider) != null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.watch<ThemeController>().systemOverlayStyle,
        child: Material(
          type: MaterialType.transparency,
          child: WeatherDashboard(bottomSheetController: _bottomSheetController),
        ),
      );
    } else {
      return ErrorSheetWidget(
        onRetry: () => ref.invalidate(forecastWeatherProvider),
        onClose: (_) => context.router.pop(),
        buttonLabel: context.l10n.tryAgain,
      );
    }
  }

  double _computeMiddleFraction() {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;
    final height = MediaQuery.of(context).size.height;
    final bottomSafeAreaFraction = bottomPadding / height;
    const targetVisibleFraction = .27;
    return ((height - bottomPadding) * targetVisibleFraction / height) + bottomSafeAreaFraction;
  }
}
