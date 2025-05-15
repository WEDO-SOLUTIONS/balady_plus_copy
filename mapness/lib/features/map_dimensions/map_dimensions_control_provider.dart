import 'package:async/async.dart';
import 'package:mapness/shared/extensions/camera_position_message_ext.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_dimensions_control_provider.g.dart';

enum MapDimensionsState {
  twoDimensional,
  threeDimensional,
}

@Riverpod(keepAlive: true)
class MapDimensionsControl extends _$MapDimensionsControl {
  CancelableOperation? _cameraMoveOperation;

  @override
  MapDimensionsState build() {
    final cameraPoint = ref.watch(cameraPositionProvider);

    if (cameraPoint == null) {
      return MapDimensionsState.threeDimensional;
    }

    if (cameraPoint.zoom.ceil() >= 17 && cameraPoint.tilt != 0) {
      return MapDimensionsState.threeDimensional;
    }

    return MapDimensionsState.twoDimensional;
  }

  Future<void> setMapDimensions(MapDimensionsState newState) async {
    if (state == newState) {
      return;
    }

    final cameraPoint = ref.read(cameraPositionProvider);

    if (cameraPoint == null) {
      return;
    }

    await _cameraMoveOperation?.cancel();
    _cameraMoveOperation = null;

    // switch logic here
    if (newState == MapDimensionsState.threeDimensional) {
      _cameraMoveOperation = CancelableOperation.fromFuture(ref.read(cameraPositionProvider.notifier).animateTo(
            cameraPoint.copyWith(
              tilt: 100,
              zoom: cameraPoint.zoom >= 17 ? cameraPoint.zoom : 17,
            ),
          ));
    } else {
      _cameraMoveOperation = CancelableOperation.fromFuture(ref.read(cameraPositionProvider.notifier).animateTo(
            cameraPoint.copyWith(
              tilt: 0,
              zoom: cameraPoint.zoom <= 16 ? cameraPoint.zoom : 16,
            ),
          ));
    }

    state = newState;
  }

  Future<void> toggleMapDimensions() {
    final newState = state == MapDimensionsState.threeDimensional
        ? MapDimensionsState.twoDimensional
        : MapDimensionsState.threeDimensional;

    return setMapDimensions(newState);
  }
}
