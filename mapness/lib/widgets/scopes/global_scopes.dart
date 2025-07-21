import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/hajj/hajj_rcmc_provider.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/features/metro/metro_layer_provider.dart';
import 'package:mapness/features/metro/metro_layer_visible_provider.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/saudi_pass/providers/show_map_offers_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/features/stories/providers/stories_open_state.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/bearing_state.dart';
import 'package:mapness/shared/providers/map/navigator_speed_cameras_settings.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';

class GlobalScopes extends ConsumerWidget {
  const GlobalScopes({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Init global providers
    ref
      ..watch(mapTapHandlerProvider.select((_) => null))
      ..watch(etaGeoSubscriberProvider.select((_) => null))
      ..watch(websocketTypeProvider.select((_) => null))
      ..watch(etaWebsocketStatusProvider.select((_) => null))
      ..watch(etaTimerIndicatorProvider.select((_) => null))
      ..watch(shareEtaProvider.select((_) => null))
      ..watch(etaServiceProvider.select((_) => null))
      ..watch(navigatorSpeedCamerasSettingsProvider.select((_) => null))
      ..watch(locationProvider.select((_) => null))
      ..watch(bearingStateProvider.select((_) => null))
      ..watch(layersControlsProvider.select((_) => null))
      ..watch(storiesOpenStateProvider.select((_) => null))
      ..watch(trafficStateProvider.select((_) => null))
      ..watch(metroLayerProvider.select((_) => null))
      ..watch(metroLayerVisibleProvider.select((_) => null))
      ..watch(parkingManageProvider.select((_) => null))
      ..watch(showMapOffersProvider.select((_) => null))
      ..watch(hajjRcmcProvider.select((_) => null));

    return child;
  }
}
