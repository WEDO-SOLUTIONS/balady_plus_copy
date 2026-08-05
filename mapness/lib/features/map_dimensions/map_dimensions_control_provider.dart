import 'dart:async';

import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/extensions/camera_position_message_ext.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_dimensions_control_provider.g.dart';

enum MapDimensionsState { twoDimensional, threeDimensional, hide }

@Riverpod(keepAlive: true)
class MapDimensionsControl extends _$MapDimensionsControl {
  CancelableOperation? _cameraMoveOperation;
  bool _didApplyInitial3D = false;

  @override
  MapDimensionsState build() {
    final cameraPoint = ref.watch(cameraPositionProvider);
    final userLocation = ref.watch(locationProvider);

    if (cameraPoint == null) {
      return MapDimensionsState.hide;
    }

    if (!_didApplyInitial3D) {
      _didApplyInitial3D = true;

      // The very first camera event may be produced by an explicit camera
      // move (e.g. a cold-start POI deep link animating to the shared point).
      // Recentering on the user here would yank the camera away from that
      // target, so the initial 3D tilt stands down entirely.
      if (!ref.read(dgisControllerProvider.notifier).startupRecenterSuppressed) {
        // Wait until we have the user's actual GPS location before applying
        // the initial 3D tilt so the camera centers on the user, not the
        // default Kingdom Tower position.
        Future.microtask(() {
          // Re-check: an explicit move may have landed between the camera
          // event and this microtask.
          if (ref.read(dgisControllerProvider.notifier).startupRecenterSuppressed) {
            return;
          }
          if (userLocation != null) {
            ref
                .read(cameraPositionProvider.notifier)
                .animateTo(
                  cameraPoint.copyWith(
                    point: GeoPointMessage(
                      latitude: userLocation.latitude,
                      longitude: userLocation.longitude,
                    ),
                    tilt: 90,
                    zoom: cameraPoint.zoom,
                  ),
                );
          } else {
            ref
                .read(cameraPositionProvider.notifier)
                .animateTo(
                  cameraPoint.copyWith(
                    tilt: 90,
                    zoom: cameraPoint.zoom,
                  ),
                );
          }
        });
        return MapDimensionsState.threeDimensional;
      }
    }

    if (cameraPoint.zoom.floor() <= 16) {
      return MapDimensionsState.hide;
    }

    if (cameraPoint.zoom.floor() > 16 && (cameraPoint.tilt.abs() > 5)) {
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
      _cameraMoveOperation = CancelableOperation.fromFuture(
        ref
            .read(cameraPositionProvider.notifier)
            .animateTo(
              cameraPoint.copyWith(
                tilt: 50,
                zoom: 17.5,
              ),
            ),
      );
    } else {
      _cameraMoveOperation = CancelableOperation.fromFuture(
        ref
            .read(cameraPositionProvider.notifier)
            .animateTo(
              cameraPoint.copyWith(
                tilt: 0,
              ),
            ),
      );
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
