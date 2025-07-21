import 'dart:async';

import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'show_map_offers_provider.g.dart';

@riverpod
class ShowMapOffers extends _$ShowMapOffers {
  final _settings = MapObjectManagerSettings.mappness();
  bool toggleShowMap = false;

  MapObjectManager get objectManager => ref.read(
        mapObjectManagerProvider(
          named: _settings.name,
          layerId: _settings.layerId,
        ).notifier,
      );

  @override
  List<Offer> build() {
    ref.onDispose(() {
      final dgis = ref.read(dgisControllerProvider).value;
      unawaited(dgis?.setMapAttributeBool('hidePoi', value: false));
      unawaited(objectManager.removeAllMarkers());
    });
    return [];
  }

  Future<void> switchOffersVisibility(
      {required bool enabled, Set<Category>? category, Set<RecommendedType>? promotionsType}) async {
    toggleShowMap = enabled;

    final dgis = ref.read(dgisControllerProvider).value;
    unawaited(dgis?.setMapAttributeBool('hidePoi', value: toggleShowMap));

    if (toggleShowMap == false) {
      unawaited(objectManager.removeAllMarkers());
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
