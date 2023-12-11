import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/weather/weather_controls.dart';
import 'package:mapness/_features/weather/weather_dashboard.dart';
import 'package:mapness/_features/weather/wiidget_ref_extension.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  StreamSubscription<TapEvent>? _streamSubscription;

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
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        bottom: false,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                const WeatherControls(),
                LayoutBuilder(builder: (context, constraints) {
                  return WeatherDashboard(
                    biggestHeight: constraints.biggest.height,
                    biggestWidth: constraints.biggest.width,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherPageContent extends StatefulWidget {
  const WeatherPageContent({super.key});

  @override
  State<WeatherPageContent> createState() => _WeatherPageContentState();
}

class _WeatherPageContentState extends State<WeatherPageContent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
