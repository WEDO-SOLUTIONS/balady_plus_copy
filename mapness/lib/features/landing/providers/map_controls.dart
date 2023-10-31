import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_controls.g.dart';

sealed class MapControlsState {
  bool get controlsVisible;
}

class MapControlsStateIdle extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateDashboard extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateNavigation extends MapControlsState {
  @override
  bool get controlsVisible => false;
}

class MapControlsStateHappinessMap extends MapControlsState {
  @override
  bool get controlsVisible => false;
}

class MapControlsStateLayers extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStatePoI extends MapControlsState {
  @override
  bool get controlsVisible => false;

  final DgisObjectIdMessage objectId;

  MapControlsStatePoI(this.objectId);
}

@riverpod
class MapControls extends _$MapControls {
  @override
  MapControlsState build() {
    final controller = ref.watch(dgisControllerProvider);
    final objectTapSubscription =
        controller?.objectTapEvents.listen(_objectTapListener);

    ref.onDispose(
      () {
        objectTapSubscription?.cancel();
      },
    );

    return MapControlsStateIdle();
  }

  void update(MapControlsState value) => state = value;

  void _objectTapListener(TapEvent event) {
    print("_objectTapListener $event");
    if (event is ObjectTapEvent) {
      state = MapControlsStatePoI(
        DgisObjectIdMessage(
          objectId: event.dgisObjectId.objectId,
          entranceId: event.dgisObjectId.entranceId,
        ),
      );
    }
  }
}
