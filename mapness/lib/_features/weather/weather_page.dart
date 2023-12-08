import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/weather/domain/enum/weather_enum.dart';
import 'package:mapness/_features/weather/weather_controls.dart';
import 'package:mapness/_features/weather/weather_dashboard.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/_features/weather/provider/weather_map_controller.dart';
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
    super.initState();
  }

  @override
  void deactivate() {
    ref.read(weatherMapControllerProvider.notifier).toggleWeatherMap(
          enable: false,
        );
    _streamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(weatherMapControllerProvider.notifier).toggleWeatherMap(
          type: WeatherMapType.temperature,
          enable: true,
        );

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

  void _objectTapListener(TapEvent event) {
    if (event is ObjectTapEvent) {
      if (context.mounted) {
        final currentRoute = ref.read(currentRouteProvider);

        if (currentRoute == "/poi-map") {
          context.pop();
          PoiMapRoute(dgisObjectId: event.dgisObjectId.objectId).push(context);
        } else {
          PoiMapRoute(dgisObjectId: event.dgisObjectId.objectId).push(context);
        }
      }
    }
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
