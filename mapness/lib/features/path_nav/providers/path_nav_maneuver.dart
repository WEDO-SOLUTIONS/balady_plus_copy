import 'package:dgis_map/library.dart';
import 'package:mapness/entities/path_nav/models/path_nav_maneuver.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_maneuver.g.dart';

@riverpod
class _PathNavManeuver extends _$PathNavManeuver {
  @override
  PathNavManeuver? build() {
    final mapController = ref.watch(dgisControllerProvider);

    final subscription = mapController.value?.naviManeuverController.maneuverEvents.listen((event) {
      if (event is ManeuverEventHidden) {
        state = null;
      }
      state = PathNavManeuver(
        instruction: event.instruction,
        roadName: event.roadName,
        distance: event.distance,
        unit: event.unit,
      );
    });

    ref.onDispose(() {
      subscription?.cancel();
    });

    return null;
  }
}

final pathNavManeuverProvider = _pathNavManeuverProvider;
