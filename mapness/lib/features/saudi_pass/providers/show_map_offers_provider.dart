import 'dart:async';
import 'dart:math';

import 'package:dgis_map/library.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'show_map_offers_provider.g.dart';

@riverpod
class ShowMapOffers extends _$ShowMapOffers {
  final _hidePoi = 'hidePoi';
  final _settings = MapObjectManagerSettings.selectedMarker();

  bool toggleShowMap = false;
  Marker? _hiddenMarker;

  MapObjectManager? mapObjectManager;

  MapObjectManager get selectPinMapObjectManager => ref.read(
        mapObjectManagerProvider(
          named: _settings.name,
          layerId: _settings.layerId,
        ).notifier,
      );

  @override
  List<Offer> build() {
    ref.onDispose(() {
      final dgis = ref.read(dgisControllerProvider).value;
      unawaited(dgis?.setMapAttributeBool(_hidePoi, value: false));
      unawaited(mapObjectManager?.removeAllMarkers());
    });
    return [];
  }

  // TODO(Ayat): rewire
  Future<void> initObjectManager(MapObjectManager mapObjectManager) async {
    this.mapObjectManager = mapObjectManager;
  }

  Future<void> showMarker(Marker marker) async {
    _showHiddenMarkerIfPresent();

    final position = LatLng(
      latitude: marker.options.position.latitude,
      longitude: marker.options.position.longitude,
    );

    final currentSearchMarker = mapObjectManager?.markerByGeoPoint(position);
    if (currentSearchMarker != null) {
      marker.options.icon?.svgPath = currentSearchMarker.options.icon?.svgPath?.bigIconPath;
      _hideMarker(currentSearchMarker);
    }

    await mapObjectManager?.removeAllMarkers();
    await selectPinMapObjectManager.removeAllMarkers();
    await selectPinMapObjectManager.addMarker(marker);
  }

  Future<void> removeMarker(String id) async {
    _showHiddenMarkerIfPresent();
    await selectPinMapObjectManager.removeMarkerById(id);
  }

  Future<void> removeAllMarkers() async {
    await selectPinMapObjectManager.removeAllMarkers();
    _showHiddenMarkerIfPresent();
  }

  void _hideMarker(Marker marker) {
    _hiddenMarker = marker;
    _setMarkerIsVisible(marker, isVisible: false);
  }

  void _showHiddenMarkerIfPresent() {
    final marker = _hiddenMarker;
    if (marker != null) {
      _setMarkerIsVisible(marker, isVisible: true);
      _hiddenMarker = null;
    }
  }

  Future<void> _setMarkerIsVisible(Marker marker, {required bool isVisible}) async {
    await mapObjectManager?.setMarkerOptions(
      marker.id,
      ChangeMarkerOptionsMessage(isVisible: marker.options.isVisible = isVisible),
    );
  }

  double distanceMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // радиус Земли в метрах
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a =
        sin(deltaPhi / 2) * sin(deltaPhi / 2) + cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // расстояние в метрах
  }

  Future<void> switchOffersVisibility({
    required bool enabled,
    required String cityId,
    required bool isAll,
    VisibleRect? visibleRect,
    Set<Category>? category,
    Set<RecommendedType>? promotionsType,
  }) async {
    toggleShowMap = enabled;

    final dgis = ref.read(dgisControllerProvider).value;
    unawaited(dgis?.setMapAttributeBool(_hidePoi, value: toggleShowMap));

    if (toggleShowMap == false) {
      unawaited(mapObjectManager?.removeAllMarkers());
      return;
    }

    final saudiPassRepository = await ref.read(saudiPassRepositoryProvider.future);
    Preferences? preferences;
    try {
      preferences = await saudiPassRepository.getPreferences();
    } catch (e) {
      log('Error fetching preferences: ${e.toString()}');
    }

    try {
      final recommendedTypes = preferences?.recommendedTypes.toSet() ?? promotionsType ?? {};
      final categories = preferences?.categories.toSet() ?? category ?? {};

      final cities = isAll
          ? {
              cityId,
            }
          : {
              if (preferences?.cities.isNotEmpty ?? false) ...preferences!.cities.map((city) => city.id),
            };
      final updatedState = List<Offer>.from([]);
      Promotions promotions;
      if (visibleRect != null) {
        final rect = visibleRect;

        final neLat = rect.northEastLat;
        final neLon = rect.northEastLon;

        final swLat = rect.southWestLat;
        final swLon = rect.southWestLon;

        final centerLat = (neLat + swLat) / 2;
        final centerLon = (neLon + swLon) / 2;

        final center = rect.center();
        final northWestLat = rect.northEastLat;
        final northWestLon = rect.southWestLon;

        final distanceToNW = distanceMeters(
          center.latitude,
          center.longitude,
          northWestLat,
          northWestLon,
        );
        promotions = await saudiPassRepository.getPromotions(
          cityIds: cities,
          categories: categories,
          recommendedTypes: recommendedTypes,
          pageSize: null,
          mapPoint: GeoPointMessage(
            latitude: centerLat,
            longitude: centerLon,
          ),
          range: distanceToNW.toInt(),
        );
      } else {
        final controller = await ref.read(dgisControllerProvider.future);
        final cameraPosition = await controller.getCameraPosition();
        promotions = await saudiPassRepository.getPromotions(
          cityIds: cities,
          categories: categories,
          recommendedTypes: recommendedTypes,
          pageSize: null,
          mapPoint: cameraPosition.point,
        );
      }

      for (final offer in promotions.records) {
        updatedState.add(offer);
      }

      state = updatedState;
    } catch (e) {
      log('Error fetching offers: ${e.toString()}');
    }
  }

  Future<void> toggleOffersOnMap(String cityId, {required bool isAll}) async {
    toggleShowMap = !toggleShowMap;

    await switchOffersVisibility(enabled: toggleShowMap, isAll: isAll, cityId: cityId);
  }
}
