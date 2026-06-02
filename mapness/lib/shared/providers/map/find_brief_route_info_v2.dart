import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/entities/routing/route_search_point_mapper.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_brief_route_info_v2.g.dart';

/// Difference vs [BriefRouteInfo]: this one listens for start point explicitly. I created it in fear of breaking
/// the original provider.
@riverpod
class BriefRouteInfoV2 extends _$BriefRouteInfoV2 {
  int _requestId = 0;

  @override
  List<BriefRouteInfoMessage>? build({
    required RouteSearchPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
    RouteSearchPoint? startPoint,
  }) {
    final controller = ref.watch(dgisControllerProvider);

    // When startPoint is null, the SDK uses current location.
    // Yet we need to recalculate route info when user moves.
    if (startPoint == null) {
      ref.listen<Position?>(locationProvider, (previous, next) {
        final isEqualData = previous?.latitude == next?.latitude && previous?.longitude == next?.longitude;
        if (!isEqualData) {
          _loadData(controller.value);
        }
      });
    }

    List<BriefRouteInfoMessage>? previous;
    try {
      previous = state;
    } catch (_) {}

    _loadData(controller.value);
    return previous;
  }

  void _loadData(DgisMapController? controller) {
    final requestId = ++_requestId;

    controller
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
  }
}
