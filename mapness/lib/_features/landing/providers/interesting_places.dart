import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:geobase/geobase.dart' as gb;
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interesting_places.g.dart';

@riverpod
class InterestingPlaces extends _$InterestingPlaces {

  final _places = <InterestingPlace>[];
  StreamSubscription? _visibleRectSub;

  @override
  List<InterestingPlace> build() {
    ref.onDispose(() {
      _visibleRectSub?.cancel();
      _visibleRectSub = null;
    });

    if (_visibleRectSub == null) {
      startListen();
    }

    return _places.toList();
  }

  void startListen() async {
    final map = ref.read(dgisControllerProvider.notifier);
    _visibleRectSub = map.visibleRectEvents.listen(_mapVisibleRectUpdate);
  }

  void _mapVisibleRectUpdate(VisibleRectEvent event) async {
    _update(event.visibleRect);
  }

  Future<void> _update(VisibleRect rect) async {
    final dio = await ref.read(dGisNetworkProvider.future);
    final box = gb.Box.create(
      minX: rect.southWestLon,
      minY: rect.southWestLat,
      maxX: rect.northEastLon,
      maxY: rect.northEastLat,
    );

    final corners = box.corners2D.toList();
    final List<gb.Position> positions = [...corners, corners[0]]
        .map((e) => gb.Position.create(x: e.x, y: e.y))
        .toList();

    final polygon = gb.Polygon.from(
      [positions],
      bounds: box,
    );

    final wkt = polygon.toText(format: gb.WKT.geometry);

    // TODO(nogipx): remove stubs
    try {
      final response = await dio.get('/interesting-places?bound=$wkt');
      final places = proto.InterestingPlacesResponse.fromBuffer(response.data)
          .interestingPlaces;
      _places
        ..clear()
        ..addAll(places);
    } catch (error) {
      _places
        ..clear()
        ..addAll(_placesStub);
    }

    ref.invalidateSelf();
  }
}

// TODO: remove stubs
extension InterestingPlaceX on InterestingPlace {
  String titleOrFallback({required AppLocalizations locale}) => switch (id) {
        '70000001079215988' => locale.poi_boulevard_riyadh_city,
        '70030076256609771' => locale.poi_kingdom_center,
        '70030076201501940' => locale.poi_faisaliya_tower,
        '70000001079216136' => locale.poi_masmak_fortress,
        '70030076419526924' => locale.poi_masmak_fortress,
        _ => preview.title,
      };
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
