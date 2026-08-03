import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_event_source.g.dart';

/// Explicit show/hide control for the native `RoadEventSource` (2GIS road-restriction icons),
/// driven by the "Road Events" layer button. Independent of — and in addition to — the automatic
/// add/remove already wired to the Traffic toggle in the native TrafficAndParkingControlHandler.
@Riverpod(keepAlive: true)
class RoadEventSourceControl extends _$RoadEventSourceControl {
  @override
  bool build() => false;

  Future<void> show() async {
    if (state) {
      return;
    }
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.addRoadEventSource();
    state = true;
  }

  Future<void> hide() async {
    if (!state) {
      return;
    }
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.removeRoadEventSource();
    state = false;
  }
}
