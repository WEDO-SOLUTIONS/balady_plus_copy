import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_spot_map.g.dart';

@riverpod
class _ParkingSpotMap extends _$ParkingSpotMap {
  late Completer<DgisMapController> _completer;
  late final _settings = MapObjectManagerSettings.parking();
  late final _mapObjectManager =
      ref.read(mapObjectManagerProvider(named: _settings.name, layerId: _settings.layerId)).value;

  @override
  Future<DgisMapController> build() {
    _completer = Completer();

    return _completer.future;
  }

  Future<void> onMapCreated(DgisMapController controller) async {
    await controller.initialize();
    final activeCityEvent = ref.read(activeCityEventProvider);
    print('onMapCreated activeCityEvent: ${activeCityEvent?.name}');
    print('onMapCreated style: ${activeCityEvent?.stylePath ?? MapnessConstants.mapStylesPath}');
    await controller.loadStyles(activeCityEvent?.stylePath ?? MapnessConstants.mapStylesPath);

    // Appearance
    await controller.setZoomRestrictions(min: 5.5);
    await controller.overrideLocales(ref.read(appLanguageProvider) == Language.arabic ? ['ar-SA'] : ['en-SA']);
    await controller.setAppearance(
      (await ref.read(darkModeProvider.future)).isDark ? MapAppearanceMessage.night : MapAppearanceMessage.day,
    );
    await controller.setBetterRouteSettings(BetterRouteSettings.prod);

    if (!_completer.isCompleted) {
      _completer.complete(controller);
    }
  }

  Future<void> setCameraPosition(GeoPointWithElevationMessage markerPosition) async => (await future).setCameraPosition(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: markerPosition.latitude, longitude: markerPosition.longitude),
          zoom: 14,
          tilt: 0,
          bearing: 0,
        ),
      );

  Future<void> addMarker(Marker marker) async {
    await (await future).removeAllMarkers(fromManager: _mapObjectManager);
    return (await future).addMarker(marker, toManager: _mapObjectManager);
  }

  Future<void> deleteMarkers() async => (await future).removeAllMarkers(fromManager: _mapObjectManager);
}

final parkingSpotMapProvider = _parkingSpotMapProvider;
