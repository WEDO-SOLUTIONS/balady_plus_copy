import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/zoom_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'show_map_offers_provider.g.dart';

@riverpod
class ShowMapOffers extends _$ShowMapOffers {
  final _settings = MapObjectManagerSettings.mappness();
  final _hidePoi = 'hidePoi';
  bool toggleShowMap = false;
  late MapObjectManager _objectManager;

  @override
  List<Offer> build() {
    final isRtl = ref.read(appLanguageProvider) == Language.arabic;
    final cameraPosition = ref.read(cameraPositionProvider.notifier);

    _objectManager = ref.read(
      mapObjectManagerProvider(
          named: _settings.name,
          layerId: _settings.layerId,
          clustering: ClusteringMapObjectManager(
            options: ClusteringMapObjectManagerOptionsMessage(logicalPixel: 70, maxZoom: 20),
            onTap: (simpleClusterObject) async {
              // await cameraPosition.animateToRepresentativeArea(
              //   GeometryMessage(
              //     kind: GeometryKindMessage.point,
              //     bounds: bounds,
              //     minPoint: GeoPointMessage(latitude: latitude, longitude: longitude),
              //     maxPoint: GeoPointMessage,
              //   ),
              // );
              // await dgisController?.moveCamera(
              //   CameraPositionMessage(
              //     point: GeoPointMessage(
              //       latitude: simpleClusterObject.position.latitude,
              //       longitude: simpleClusterObject.position.longitude,
              //     ),
              //     zoom: 18,
              //     tilt: 0,
              //     bearing: 0,
              //   ),
              // );
            },
            renderCluster: (objectCount) => SimpleClusterOptionsMessage(
              icon: Assets.icons.svg.icOffersClusteringMarker.keyName.markerIcon(size: 32),
              text: objectCount.toString(),
              textStyle: MarkerTextStyleMessage(
                textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.centerCenter),
                color: 0xFFFFFFFF,
                fontSize: 13,
                fontName: isRtl ? poiMapFontAr : poiMapFontEn,
              ),
            ),
          )).notifier,
    );

    ref.onDispose(() {
      final dgis = ref.read(dgisControllerProvider).value;
      unawaited(dgis?.setMapAttributeBool(_hidePoi, value: false));
      unawaited(_objectManager.removeAllMarkers());
    });
    return [];
  }

  Future<void> switchOffersVisibility(
      {required bool enabled, Set<Category>? category, Set<RecommendedType>? promotionsType}) async {
    toggleShowMap = enabled;

    final dgis = ref.read(dgisControllerProvider).value;
    unawaited(dgis?.setMapAttributeBool(_hidePoi, value: toggleShowMap));

    if (toggleShowMap == false) {
      unawaited(_objectManager.removeAllMarkers());
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
      final cityId = await ref.read(saudiPassCityIdByLocationProvider.future);

      final recommendedTypes = preferences?.recommendedTypes.toSet() ?? promotionsType ?? {};
      final categories = preferences?.categories.toSet() ?? category ?? {};
      final cities = <String>{
        if (preferences?.cities.isEmpty ?? true) cityId,
        if (preferences?.cities.isNotEmpty ?? false) ...preferences!.cities.map((city) => city.id),
      };

      final updatedState = List<Offer>.from([]);

      final promotions = await saudiPassRepository.getPromotions(
        cityIds: cities,
        categories: categories,
        recommendedTypes: recommendedTypes,
        pageSize: 10000,
      );

      for (final offer in promotions.records) {
        updatedState.add(offer);
      }

      state = updatedState;
    } catch (e) {
      log('Error fetching offers: ${e.toString()}');
    }
  }

  Future<void> toggleOffersOnMap() async {
    toggleShowMap = !toggleShowMap;

    await switchOffersVisibility(enabled: toggleShowMap);
  }
}
