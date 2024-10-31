import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/city_contains/service_not_available.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/bearing_state.dart';
import 'package:mapness/shared/providers/map/navigator_speed_cameras_settings.dart';

class GlobalScopes extends ConsumerWidget {
  const GlobalScopes({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Init global providers
    ref
      ..watch(etaGeoSubscriberProvider.select((_) => null))
      ..watch(websocketTypeProvider.select((_) => null))
      ..watch(etaTimerIndicatorProvider.select((_) => null))
      ..watch(shareEtaProvider.select((_) => null))
      ..watch(etaServiceProvider.select((_) => null))
      ..watch(navigatorSpeedCamerasSettingsProvider.select((_) => null))
      ..watch(locationProvider.select((_) => null))
      ..watch(bearingStateProvider.select((_) => null))
      ..watch(serviceNotAvailableProvider.select((_) => null));

    return child;
  }
}
