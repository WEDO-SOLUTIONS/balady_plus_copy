import 'package:mapness/features/road_events/providers/road_events_markers.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_event_source.g.dart';

/// Explicit show/hide control for the road-events marker layer, driven by the
/// "Road Events" layer button. Markers are REST-backed (see
/// `road_events_repository.dart`/`road_events_markers.dart`) — this only
/// toggles the custom `MapObjectManager` layer's visibility, replacing what
/// used to be the native `RoadEventSource` add/remove calls.
@Riverpod(keepAlive: true)
class RoadEventSourceControl extends _$RoadEventSourceControl {
  @override
  bool build() => false;

  Future<void> show() async {
    if (state) {
      return;
    }
    await _setVisible(true);
    state = true;
  }

  Future<void> hide() async {
    if (!state) {
      return;
    }
    await _setVisible(false);
    state = false;
  }

  Future<void> _setVisible(bool isVisible) async {
    final settings = roadEventsMarkersSettings;
    final manager = ref.read(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier);
    await manager.setMapObjectManagerIsVisible(isVisible: isVisible);
  }
}
