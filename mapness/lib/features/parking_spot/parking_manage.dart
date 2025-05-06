import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/parking_spot/model/parking_store_model.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_manage.g.dart';

const _boxName = 'parking_location';
const _keyCache = 'parking_store_model';

const parkingId = 'parking_marker';
const parkingObjectId = 10;/// This ID is needed to determine that we have opened the parking lot

@riverpod
class _ParkingManage extends _$ParkingManage {
  late final _settings = MapObjectManagerSettings.parking();

  late final _mapObjectManager = ref.watch(
    mapObjectManagerProvider(
      named: _settings.name,
      layerId: _settings.layerId,
    ).notifier,
  );

  @override
  Future<ParkingStoreModel?> build() async {
    await ref.read(dgisControllerProvider.future);

    final hive = await ref.read(hiveProvider(_boxName).future);
    final cachedData = await hive.get(_keyCache);

    if (cachedData is Map) {
      final model = ParkingStoreModel.fromJson(Map<String, dynamic>.from(cachedData));

      final isExpired = DateTime.now().difference(model.dateTime) > const Duration(hours: 24);
      if (isExpired) {
        await hive.delete(_keyCache);
        return null;
      }

      await _addMarker(model.lat, model.lon);
      return model;
    }

    return null;
  }

  Future<void> saveStore(ParkingStoreModel model) async {
    final hive = await ref.read(hiveProvider(_boxName).future);

    await hive.put(_keyCache, model.toJson());
    await _addMarker(model.lat, model.lon);
    state = AsyncValue.data(model);
  }

  Future<void> restoreMarker() async {
    final model = state.value;
    if (model != null) {
      await _addMarker(model.lat, model.lon);
    }
  }

  Future<void> clearStore() async {
    final hive = await ref.read(hiveProvider(_boxName).future);

    await hive.delete(_keyCache);
    await _mapObjectManager.removeAllMarkers();
    state = const AsyncValue.data(null);
  }

  Future<void> addPinParking(
    GeoPointWithElevationMessage? geoPoint,
    String title,
  ) async {
    final lat = geoPoint?.latitude ?? 0.0;
    final lon = geoPoint?.longitude ?? 0.0;

    await _mapObjectManager.removeAllMarkers();

    final style = await _markerStyle(title);
    await _mapObjectManager.addMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(latitude: lat, longitude: lon, elevation: 1),
        text: title,
        textStyle: style,
        icon: Markers.defaultPinNew,
        id: poiPinId,
      ),
    );
  }

  Future<MarkerTextStyleMessage> _markerStyle(String title) async {
    final darkMode = await ref.watch(darkModeProvider.future);
    final isArabic = ref.read(appLanguageProvider) == Language.arabic;
    final font = title.containsArabic() || isArabic ? poiMapFontAr : poiMapFontEn;

    return MarkerTextStyleMessage(
      fontSize: 13,
      textOffset: 4,
      color: darkMode.isDark ? 0xD3FFFFFF : 0xff1B1B1B,
      strokeColor: darkMode.isDark ? 0xff1B1B1B : 0xD3FFFFFF,
      strokeWidth: 1,
      fontName: font,
      textPlacement: MarkerTextPlacementMessage(
        placement: TextPlacementMessage.bottomCenter,
      ),
    );
  }

  Future<void> _addMarker(double lat, double lon) async {
    await _mapObjectManager.removeAllMarkers();

    await _mapObjectManager.addMarker(
      Marker(
        id: parkingId,
        options: MarkerOptionsMessage(
          position: GeoPointWithElevationMessage(
            latitude: lat,
            longitude: lon,
            elevation: 1,
          ),
          icon: Assets.icons.svg.placesNew.icParking.keyName.markerIcon(),
        ),
        onTap: () {
          ref.read(appRouterProvider).replaceOrPush(
            route: PoiCardWidgetRoute(
              closestPoint: LatLng(latitude: lat, longitude: lon),
              objectId: DgisObjectIdMessage(
                objectId: parkingObjectId,
                entranceId: 0,
              ),
            ),
            toCompareRoutes: [PoiCardWidgetRoute.page],
          );
        },
      ),
    );
  }
}

final parkingManageProvider = _parkingManageProvider;
