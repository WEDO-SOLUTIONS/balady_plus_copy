import 'dart:async';

import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_map_offers_provider.g.dart';

@Riverpod(keepAlive: true)
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
  List<Offer> build() => [];

  Future<void> fetchOffers() async {
    toggleShowMap = !toggleShowMap;

    final dgis = ref.read(dgisControllerProvider).value;
    unawaited(dgis?.setMapAttributeBool('hidePoi', value: toggleShowMap));

    if (toggleShowMap == false) {
      unawaited(objectManager.removeAllMarkers());
      return;
    }

    try {
      final repository = await ref.read(saudiPassRepositoryProvider.future);

      final updatedState = List<Offer>.from([]);
      final cityId = await ref.read(saudiPassCityIdByLocationProvider.future);
      final promotions = await repository.getPromotions(
        cityIds: {cityId},
        // we should fetch max count of offers for this licenseIds
        pageSize: 1000,
      );

      for (final offer in promotions.records) {
        updatedState.add(offer);
      }

      state = updatedState;
    } catch (_) {
      // skip, offers updating must not block other functionality
    }
  }
}
