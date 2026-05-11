import 'dart:async';

import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/extensions/marker_icons_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'show_map_offers_provider.g.dart';

@Riverpod(keepAlive: true)
class ShowMapOffers extends _$ShowMapOffers {
  final _hidePoi = 'hidePoi';
  final _settings = MapObjectManagerSettings.selectedMarker();

  bool toggleShowMap = false;
  Marker? _hiddenMarker;

  MapObjectManager? mapObjectManager;

  MapObjectManager get selectPinMapObjectManager =>
      ref.read(mapObjectManagerProvider(named: _settings.name, layerId: _settings.layerId).notifier);

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

  Future<void> showMarker(Marker marker, BaladyAppThemes theme) async {
    _showHiddenMarkerIfPresent();

    final position = LatLng(latitude: marker.options.position.latitude, longitude: marker.options.position.longitude);
    final isDarkMode = ref.read(darkModeProvider).value?.isDark ?? false;

    final currentSearchMarker = mapObjectManager?.markerByGeoPoint(position);
    if (currentSearchMarker != null) {
      marker.options.icon?.svgPath = currentSearchMarker.options.icon?.svgPath?.toBigIcon(isDark: isDarkMode);
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

  /// Loads offers for the map using exactly the filter context provided by
  /// the caller — BRD US-03 BR-02. This provider MUST NOT call
  /// `getPreferences()` internally; the map must mirror the offer set of
  /// the originating list. The active filter snapshot is built by the list
  /// notifier (`PrefsOffersViewNotifier.mapContext` /
  /// `OffersFiltersViewNotifier.mapContext`).
  Future<void> switchOffersVisibility({
    required bool enabled,
    required Set<String> cityIds,
    Set<Category> categories = const {},
    Set<SubCategory> subCategories = const {},
    Set<RecommendedType> recommendedTypes = const {},
    VisibleRect? visibleRect,
  }) async {
    toggleShowMap = enabled;

    final dgis = ref.read(dgisControllerProvider).value;
    unawaited(dgis?.setMapAttributeBool(_hidePoi, value: toggleShowMap));

    if (toggleShowMap == false) {
      unawaited(mapObjectManager?.removeAllMarkers());
      return;
    }

    final saudiPassRepository =
        await ref.read(saudiPassRepositoryProvider.future);

    try {
      final updatedState = <Offer>[];
      final Promotions promotions;
      if (visibleRect != null) {
        final rect = visibleRect;
        final center = rect.center();
        promotions = await saudiPassRepository.getPromotions(
          cityIds: cityIds,
          categories: categories,
          recommendedTypes: recommendedTypes,
          pageSize: null,
          mapPoint: GeoPointMessage(
            latitude: center.latitude,
            longitude: center.longitude,
          ),
          range: rect.distanceToNW().toInt(),
        );
      } else {
        final controller = await ref.read(dgisControllerProvider.future);
        final cameraPosition = await controller.getCameraPosition();
        promotions = await saudiPassRepository.getPromotions(
          cityIds: cityIds,
          categories: categories,
          subCategories: subCategories,
          recommendedTypes: recommendedTypes,
          pageSize: null,
          mapPoint: cameraPosition.point,
        );
      }

      final uniqueOffers = <String, Offer>{};
      for (final offer in promotions.records) {
        uniqueOffers[offer.id] = offer;
      }
      updatedState.addAll(uniqueOffers.values);

      state = updatedState;
    } catch (e) {
      log('Error fetching offers: ${e.toString()}');
    }
  }

  Future<void> toggleOffersOnMap({
    required Set<String> cityIds,
    Set<Category> categories = const {},
    Set<SubCategory> subCategories = const {},
    Set<RecommendedType> recommendedTypes = const {},
  }) async {
    toggleShowMap = !toggleShowMap;

    await switchOffersVisibility(
      enabled: toggleShowMap,
      cityIds: cityIds,
      categories: categories,
      subCategories: subCategories,
      recommendedTypes: recommendedTypes,
    );
  }
}
