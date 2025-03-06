import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:geobase/geobase.dart' as gb;
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/constants/info_mock.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interesting_places.g.dart';

@riverpod
class InterestingPlaces extends _$InterestingPlaces {
  @override
  Future<List<InterestingPlace>> build() async {
    state = const AsyncValue.loading();

    final dio = await ref.watch(dGisNetworkProvider.future);

    final subscription = ref.read(dgisControllerProvider.notifier).visibleRectSubject.listen((event) async {
      await _update(dio, event?.visibleRect);
    });

    ref.onDispose(subscription.cancel);

    await _update(dio);
    return state.value ?? [];
  }

  Future<void> _update(Dio dio, [VisibleRect? rect]) async {
    final polygon = rect != null ? CommonFunctions.getPolygonFromRect(rect) : null;
    final data = await _fetch(dio, polygon);
    state = AsyncValue.data(data);
  }

  Future<List<InterestingPlace>> _fetch(Dio dio, [gb.Polygon? polygon]) async {
    final wkt = polygon != null ? polygon.toText(format: gb.WKT.geometry) : '';

    try {
      final response = await dio.get(
        wkt.isNotEmpty ? '/interesting-places?bound=$wkt' : '/interesting-places',
        options: defaultCacheOptions,
      );
      final places = InterestingPlacesResponse.fromBuffer(response.data as List<int>).interestingPlaces;
      return places;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      return [];
    }
  }
}

// TODO: remove stubs
extension InterestingPlaceX on InterestingPlace {
  String titleOrFallback({required AppLocalizations locale}) {
    final intId = int.tryParse(entity.id);

    // print('FLAG: intID $intId');

    if (intId != null) {
      final mock = nameMock(
        intId,
        switch (locale.localeName) {
          'ar' => Language.arabic,
          _ => Language.english,
        },
      );
      // print('FLAG: mock $mock');
      if (mock != null) {
        return mock;
      }
    }
    return switch (entity.id) {
      '70000001079215988' => locale.poi_boulevard_riyadh_city,
      '70030076256609771' => locale.poi_kingdom_center,
      '70030076201501940' => locale.poi_faisaliya_tower,
      '70000001079216136' => locale.poi_masmak_fortress,
      '70030076419526924' => locale.poi_masmak_fortress,
      _ => preview.title,
    };
  }
}
