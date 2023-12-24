import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geobase/geobase.dart' as gb;
import 'package:mapness/_features/common/providers/map_viewport_changes.dart';
import 'package:mapness/_features/poi_card/constants/info_mock.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interesting_places.g.dart';

@riverpod
class InterestingPlaces extends _$InterestingPlaces {
  Future<Dio> get _dio => ref.read(dGisNetworkProvider.future);

  final _places = <InterestingPlace>[];

  @override
  List<InterestingPlace> build() {
    ref.listen(
      mapViewportChangesProvider,
      (_, next) async {
        await _update(next);
      },
    );

    return _places.toList();
  }

  Future<void> _update(gb.Polygon polygon) async {
    final newPlaces = await _fetch(polygon);
    _places
      ..clear()
      ..addAll(newPlaces);

    ref.invalidateSelf();
  }

  Future<List<InterestingPlace>> _fetch(gb.Polygon polygon) async {
    final wkt = polygon.toText(format: gb.WKT.geometry);

    // TODO(nogipx): remove stubs
    try {
      final response = await (await _dio).get('/interesting-places?bound=$wkt');
      final places = proto.InterestingPlacesResponse.fromBuffer(response.data)
          .interestingPlaces;
      return places;
    } catch (error) {
      return _placesStub;
    }
  }
}

// TODO: remove stubs
extension InterestingPlaceX on InterestingPlace {
  String titleOrFallback({required AppLocalizations locale}) {
    final intId = int.tryParse(id);

    if (intId != null) {
      final mock = nameMock(
        intId,
        switch (locale.localeName) {
          'ar' => Language.arabic,
          _ => Language.english,
        },
      );
      if (mock != null) {
        return mock;
      }
    }
    return switch (id) {
      '70000001079215988' => locale.poi_boulevard_riyadh_city,
      '70030076256609771' => locale.poi_kingdom_center,
      '70030076201501940' => locale.poi_faisaliya_tower,
      '70000001079216136' => locale.poi_masmak_fortress,
      '70030076419526924' => locale.poi_masmak_fortress,
      _ => preview.title,
    };
  }
}

final _placesStub = <InterestingPlace>[
  InterestingPlace(
    id: '70000001079215988',
    preview: InterestingPlace_Preview(
      title: 'Boulevard\nRiyadh City',
      image: Image(
        url: 'assets/images/poi_boulevard_riyadh_city.png',
      ),
    ),
  ),
  InterestingPlace(
    id: '70030076256609771',
    preview: InterestingPlace_Preview(
      title: 'Kingdom\nCenter',
      image: Image(
        url: 'assets/images/poi_kingdom_center.png',
      ),
    ),
  ),
  InterestingPlace(
    id: '70030076201501940',
    preview: InterestingPlace_Preview(
      title: 'Faisaliya\nTower',
      image: Image(
        url: 'assets/images/poi_faisaliya_tower.png',
      ),
    ),
  ),
  InterestingPlace(
    id: '70000001079216136',
    preview: InterestingPlace_Preview(
      title: 'Masmak\nFortress',
      image: Image(
        url: 'assets/images/poi_masmak_fortress.png',
      ),
    ),
  ),
  InterestingPlace(
    id: '70030076419526924',
    preview: InterestingPlace_Preview(
      title: 'Edge of the\nworld',
      image: Image(
        url: 'assets/images/poi_edge_of_the_world.png',
      ),
    ),
  ),
];
