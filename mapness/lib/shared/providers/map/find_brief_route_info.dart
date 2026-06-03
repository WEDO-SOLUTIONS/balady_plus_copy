import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/entities/routing/route_search_point_mapper.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_brief_route_info.g.dart';

@riverpod
class BriefRouteInfo extends _$BriefRouteInfo {
  static const _refreshInterval = Duration(minutes: 10);
  int _requestId = 0;

  @override
  List<BriefRouteInfoMessage>? build({
    required RouteSearchPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
    RouteSearchPoint? startPoint,
  }) {
    final controller = ref.watch(dgisControllerProvider);

    // When startPoint is null, the SDK uses current location.
    // Refresh periodically instead of on every GPS update to avoid
    // excessive route calculations.
    if (startPoint == null) {
      final timer = Timer(_refreshInterval, () => ref.invalidateSelf());
      ref.onDispose(timer.cancel);
    }

    // Preserve previous data to avoid UI blinks during rebuilds.
    List<BriefRouteInfoMessage>? previous;
    try {
      previous = state;
    } catch (_) {}

    final requestId = ++_requestId;

    controller.value
        ?.findBriefRouteInfos(
          startPoint: startPoint?.toMessage(),
          options: navType,
          finishPoint: finishPoint?.toMessage(),
        )
        .then((value) {
          if (!ref.mounted || requestId != _requestId) {
            return;
          }
          state = value.whereType<BriefRouteInfoMessage>().toList();
        })
        .onError((error, stackTrace) {
          if (!ref.mounted || requestId != _requestId) {
            return null;
          }
          state = null;
          return null;
        });

    return previous;
  }
}
