import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_marker.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_markers.g.dart';

@riverpod
class _IwishMarkers extends _$IwishMarkers {
  void refresh() {
    ref.invalidateSelf();
  }

  @override
  Future<List<IwishMarker>> build() async {
    final dio = ref.watch(dGisNetworkProvider);
    final raw = await dio.get('iwish');
    final response = pb.IWishMarkersResponse.fromBuffer(raw.data);
    // print(response.writeToJson());

    // final random = Random(42);

    // return List.generate(
    //   10,
    //   (index) => IwishMarker(
    //     id: 'id$index',
    //     category: IwishCategory.joyParks,
    //     location: GeoPointMessage(
    //       latitude: 24.774265 + random.nextDouble() / 10,
    //       longitude: 46.738586 + random.nextDouble() / 10,
    //     ),
    //   ),
    // );

    // print(response.writeToJson());

    return response.markers
        .map(
          (e) => IwishMarker(
            id: e.id,
            category: switch (e.category) {
              pb.IWishCategory.IWISH_CATEGORY_JOY_PARKS =>
                IwishCategory.joyParks,
              pb.IWishCategory.IWISH_CATEGORY_UNKNOWN => IwishCategory.unknown,
              _ => IwishCategory.unknown,
            },
            location: GeoPointMessage(
              latitude: e.location.point.latitude,
              longitude: e.location.point.longitude,
            ),
          ),
        )
        .toList();
  }
}

final iwishMarkersProvider = _iwishMarkersProvider;
