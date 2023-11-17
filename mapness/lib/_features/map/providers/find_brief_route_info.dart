import 'package:dgis_map/library.dart';
import 'package:mapness/_features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_brief_route_info.g.dart';

@riverpod
class FindBriefRouteInfo extends _$FindBriefRouteInfo {
  @override
  List<void> build() {
    return [];
  }

  Future<List<BriefRouteInfoMessage?>> findBriefRouteInfo(
    DirectoryObjectMessage? data,
  ) async {
    final controller = ref.watch(dgisControllerProvider);
    if (data == null) return [];
    final kingdomTower =
        GeoPointMessage(latitude: 24.712301, longitude: 46.674175);
    var markerPosition = data.markerPosition;

    var option = RouteSearchOptionsMessage.car;

    var list = [
      BriefRouteInfoSearchPointsMessage(
          startPoint: RouteSearchPointMessage(
            coordinates: kingdomTower,
            objectId: DgisObjectIdMessage(
              objectId: 0,
              entranceId: 0,
            ),
          ),
          finishPoint: RouteSearchPointMessage(
            coordinates: GeoPointMessage(
              latitude: markerPosition?.latitude ?? .0,
              longitude: markerPosition?.longitude ?? .0,
            ),
            objectId: data.id!,
          )),
    ];

    var result = await controller?.findBriefRouteInfos(option, list);
    if (result == null) return [];
    return result;
  }
}
