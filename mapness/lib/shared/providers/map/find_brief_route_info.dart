import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_brief_route_info.g.dart';

@riverpod
class _BriefRouteInfo extends _$BriefRouteInfo {
  @override
  List<BriefRouteInfoMessage>? build({
    required RouteSearchPointMessage finishPoint,
    RouteSearchPointMessage? startPoint,
    required RouteSearchOptionsMessage navType,
  }) {
    final controller = ref.watch(dgisControllerProvider);
    controller
        ?.findBriefRouteInfos(
      startPoint: startPoint,
      options: navType,
      finishPoint: finishPoint,
    )
        .then((value) {
      // state = value.whereType<BriefRouteInfoMessage>().toList();
    }).onError((error, stackTrace) => state = null);

    print("flag");
    return null;
  }
}

const briefRouteInfoProvider = _briefRouteInfoProvider;
