import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_marker.dart';
import 'package:mapness/features/iwish/lib/iwish_marker_mapper.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_markers.g.dart';

const iwishMarkerPrefix = 'iwish-marker-';

@riverpod
Future<List<IwishMarker>> _iwishMarkersNetwork(ref) async {
  final dio = await ref.read(dGisNetworkProvider.future);

  final raw = await dio.get('iwish');
  final response = pb.IWishMarkersResponse.fromBuffer(raw.data);

  return response.markers
      .map(
        (serverMarker) => IwishMarker(
            id: serverMarker.id,
            category: switch (serverMarker.category) {
              pb.IWishCategory.IWISH_CATEGORY_JOY_PARKS =>
                IwishCategory.joyParks,
              pb.IWishCategory.IWISH_CATEGORY_UNKNOWN => IwishCategory.unknown,
              _ => IwishCategory.unknown,
            },
            location: GeoPointMessage(
              latitude: serverMarker.location.point.latitude,
              longitude: serverMarker.location.point.longitude,
            ),
            state: switch (serverMarker.state) {
              pb.IWishState.IWISH_STATE_PLANNED => IwishState.planned,
              pb.IWishState.IWISH_STATE_COMPLETED => IwishState.completed,
              pb.IWishState.IWISH_STATE_UNKNOWN || _ => IwishState.unknown,
            }),
      )
      .toList();
}

@riverpod
class _IwishMarkers extends _$IwishMarkers {
  String? selectedMarkerId;

  void refresh() {
    ref.invalidate(_iwishMarkersNetworkProvider);
  }

  @override
  Future<List<Marker>> build() async {
    final markers = await ref.watch(_iwishMarkersNetworkProvider.future);
    return markers
        .map(
          (stateMarker) => stateMarker.toMarker(
            selectedMarkerId == stateMarker.id,
            _onMarkerTap,
          ),
        )
        .toList();
  }

  Future<void> _onMarkerTap(IwishMarker stateMarker) async {
    {
      IwishCardRoute.open(
        ref.read(goRouterProvider),
        stateMarker,
      );

      // final mapObjectManager =
      //     ref.read(mapObjectManagerProvider(named: iwishLayerName).notifier);

      /// make previous marker unselected
      // if (selectedMarkerId != null) {
      //   await mapObjectManager
      //       .removeMarkerById("$iwishMarkerPrefix$selectedMarkerId");
      //   final markers = await ref.read(_iwishMarkersNetworkProvider.future);
      //   final marker = markers
      //       .firstWhereOrNull((element) => element.id == selectedMarkerId);
      //   if (marker != null) {
      //     mapObjectManager.addMarker(
      //       marker.toMarker(
      //         false,
      //         _onMarkerTap,
      //       ),
      //     );
      //   }
      // }

      ///clear map
      // await mapObjectManager.removeAllMarkers();

      // /// select new marker
      // await mapObjectManager
      //     .removeMarkerById("$iwishMarkerPrefix${stateMarker.id}");
      // mapObjectManager.addMarker(
      //   stateMarker.toMarker(
      //     true,
      //     _onMarkerTap,
      //   ),
      // );

      // selectedMarkerId = stateMarker.id;
      // ref.invalidateSelf();
    }
  }
}

final iwishMarkersProvider = _iwishMarkersProvider;
