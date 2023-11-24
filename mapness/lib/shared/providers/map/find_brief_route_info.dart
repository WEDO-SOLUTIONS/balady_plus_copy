import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
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
    var markerPosition = data.markerPosition;
    var option = RouteSearchOptionsMessage.car;
    var result = await controller?.findBriefRouteInfos(
      options: option,
      finishPoint: RouteSearchPointMessage(
        coordinates: GeoPointMessage(
          latitude: markerPosition?.latitude ?? .0,
          longitude: markerPosition?.longitude ?? .0,
        ),
        objectId: data.id!,
      ),
    );
    if (result == null) return [];
    return result;
  }
}
