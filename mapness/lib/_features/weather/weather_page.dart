import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/weather/weather_controls.dart';
import 'package:mapness/_features/weather/weather_dashboard.dart';
import 'package:mapness/_features/weather/wiidget_ref_extension.dart';

@RoutePage()
class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  StreamSubscription<TapEvent>? _streamSubscription;
  late final StatefulBottomSheetController<ThreeStateBottomSheet> _bottomSheetController =
      StatefulBottomSheetController(
    initialState: ThreeStateBottomSheet.open,
    behavior: AspectRatioSnappingBehavior(aspectRatios: {.1, .38, .931}),
    stateMapper: const ThreeStateMapper(),
  );

  @override
  void initState() {
    ref.toggleWeatherMap(
      type: WeatherMapType.temperature,
      enable: true,
    );
    super.initState();
  }

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              WeatherControls(
                bottomSheetController: _bottomSheetController,
              ),
              LayoutBuilder(
                builder: (context, constraints) => WeatherDashboard(
                  biggestHeight: constraints.biggest.height,
                  biggestWidth: constraints.biggest.width,
                  bottomSheetController: _bottomSheetController,
                ),
              ),
            ],
          ),
        ),
      );
}

class WeatherPageContent extends StatefulWidget {
  const WeatherPageContent({super.key});

  @override
  State<WeatherPageContent> createState() => _WeatherPageContentState();
}

class _WeatherPageContentState extends State<WeatherPageContent> {
  @override
  Widget build(BuildContext context) => const Placeholder();
}
