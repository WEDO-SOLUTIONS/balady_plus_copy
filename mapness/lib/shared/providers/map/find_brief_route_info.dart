import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/entities/routing/route_search_point_mapper.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_brief_route_info.g.dart';

@riverpod
class BriefRouteInfo extends _$BriefRouteInfo {
  @override
  List<BriefRouteInfoMessage>? build({
    required RouteSearchPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
    RouteSearchPoint? startPoint,
  }) {
    final controller = ref.watch(dgisControllerProvider);
    controller.value
        ?.findBriefRouteInfos(
          startPoint: startPoint?.toMessage(),
          options: navType,
          finishPoint: finishPoint?.toMessage(),
        )
        .then((value) {
          state = value.whereType<BriefRouteInfoMessage>().toList();
        })
        .onError((error, stackTrace) => state = null);

    return null;
  }
}
