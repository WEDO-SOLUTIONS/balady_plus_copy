import 'dart:async';

import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/extensions/marker_icons_ext.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'show_map_offers_provider.g.dart';

@Riverpod(keepAlive: true)
class ShowMapOffers extends _$ShowMapOffers {
  static const _pageSize = 20;
  static const _maxMapPages = 5;

  final _hidePoi = 'hidePoi';
  final _settings = MapObjectManagerSettings.selectedMarker();
  int _requestId = 0;

  bool toggleShowMap = false;
  Marker? _hiddenMarker;

  MapObjectManager? mapObjectManager;

  MapObjectManager get selectPinMapObjectManager =>
      ref.read(mapObjectManagerProvider(named: _settings.name, layerId: _settings.layerId).notifier);

  @override
  List<Offer> build() {
    final dgis = ref.read(dgisControllerProvider).value;
    ref.onDispose(() {
      _requestId++;
      unawaited(dgis?.setMapAttributeBool(_hidePoi, value: false));
      unawaited(mapObjectManager?.removeAllMarkers());
    });
    return [];
  }

  // TODO(Ayat): rewire
  Future<void> initObjectManager(MapObjectManager mapObjectManager) async {
    this.mapObjectManager = mapObjectManager;
  }

  Future<void> showMarker(Marker marker, BaladyAppThemes theme) async {
    _showHiddenMarkerIfPresent();

    final position = LatLng(latitude: marker.options.position.latitude, longitude: marker.options.position.longitude);
    final isDarkMode = ref.read(darkModeProvider).value?.isDark ?? false;

    final currentSearchMarker = mapObjectManager?.markerByGeoPoint(position);
    if (currentSearchMarker != null) {
      if (marker.options.icon?.svgPath == Markers.defaultPinNew) {
        marker.options.icon?.svgPath = currentSearchMarker.options.icon?.svgPath?.toBigIcon(isDark: isDarkMode);
      }
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

  Future<void> switchOffersVisibility({
    required bool enabled,
    required String cityId,
    required bool isAll,
    VisibleRect? visibleRect,
    Set<Category>? category,
    Set<SubCategory>? subCategory,
    Set<RecommendedType>? promotionsType,
  }) async {
    final requestId = ++_requestId;
    toggleShowMap = enabled;

    final dgis = ref.read(dgisControllerProvider).value;
    unawaited(dgis?.setMapAttributeBool(_hidePoi, value: toggleShowMap));

    if (toggleShowMap == false) {
      unawaited(mapObjectManager?.removeAllMarkers());
      return;
    }

    final saudiPassRepository = await ref.read(saudiPassRepositoryProvider.future);
    if (!_isCurrentRequest(requestId)) {
      return;
    }
    Preferences? preferences;
    try {
      preferences = await saudiPassRepository.getPreferences();
      if (!_isCurrentRequest(requestId)) {
        return;
      }
    } catch (e) {
      log('Error fetching preferences: ${e.toString()}');
    }

    try {
      final recommendedTypes = preferences?.recommendedTypes.toSet() ?? promotionsType ?? {};
      final categories = preferences?.categoriesOnly.toSet() ?? category ?? {};
      final subCategories = preferences?.subCategoriesOnly.toSet() ?? subCategory ?? {};

      final cities = isAll
          ? {cityId}
          : {
              // If user has cities in preferences, use them; otherwise fall back to cityId
              if (preferences?.cities.isNotEmpty ?? false) ...preferences!.cities.map((city) => city.id),
              if (preferences?.cities.isEmpty ?? true)
                cityId, // Fall back to location-based city if no city in preferences
            };
      final GeoPointMessage mapPoint;
      final int range;
      if (visibleRect != null) {
        final rect = visibleRect;
        final center = rect.center();
        mapPoint = GeoPointMessage(latitude: center.latitude, longitude: center.longitude);
        range = rect.distanceToNW().toInt();
      } else {
        final controller = await ref.read(dgisControllerProvider.future);
        if (!_isCurrentRequest(requestId)) {
          return;
        }
        final cameraPosition = await controller.getCameraPosition();
        if (!_isCurrentRequest(requestId)) {
          return;
        }
        mapPoint = cameraPosition.point;
        range = 10000;
      }

      final uniqueOffers = <String, Offer>{};
      var pageNumber = 0;
      var pagesCount = 1;
      do {
        final promotions = await saudiPassRepository.getPromotions(
          cityIds: cities,
          categories: categories,
          subCategories: subCategories,
          recommendedTypes: recommendedTypes,
          pageNumber: pageNumber,
          pageSize: _pageSize,
          mapPoint: mapPoint,
          range: range,
        );
        if (!_isCurrentRequest(requestId)) {
          return;
        }
        for (final offer in promotions.records) {
          uniqueOffers[offer.id] = offer;
        }
        pagesCount = promotions.pagingStatus.pagesCount;
        pageNumber++;
      } while (pageNumber < pagesCount && pageNumber < _maxMapPages);

      if (!_isCurrentRequest(requestId)) {
        return;
      }

      state = uniqueOffers.values.toList(growable: false);
    } catch (e) {
      log('Error fetching offers: ${e.toString()}');
    }
  }

  Future<void> toggleOffersOnMap(String cityId, {required bool isAll}) async {
    toggleShowMap = !toggleShowMap;

    await switchOffersVisibility(enabled: toggleShowMap, isAll: isAll, cityId: cityId);
  }

  bool _isCurrentRequest(int requestId) => ref.mounted && requestId == _requestId && toggleShowMap;
}
