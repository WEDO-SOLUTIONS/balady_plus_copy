import 'package:dgis_map/library.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_recreation.g.dart';

const _logTag = '[map_recreation]';

/// Monotonic counter used as the Flutter widget key on the primary [DgisMap].
///
/// Incrementing it forces the native MapView to be torn down and recreated:
/// old `Map.close()` runs, the 2GIS SDK releases process-scoped model/mesh
/// caches, and the next [DgisMap] mount runs a cold-decode chain. This is
/// currently the only knob for busting the SDK's per-process GLB cache when
/// swapping navigation car models at runtime — no public invalidate API
/// exists on 2GIS SDK 12.8.0.
///
/// Callers that need a swap should:
/// 1. Snapshot the current camera via [PendingCameraSnapshot.set].
/// 2. `ref.invalidate(dgisControllerProvider)` so the old controller's
///    Riverpod listeners drop before the widget is unmounted.
/// 3. Call [MapRecreationCounter.bump].
@Riverpod(keepAlive: true)
class MapRecreationCounter extends _$MapRecreationCounter {
  @override
  int build() => 0;

  void bump() {
    state = state + 1;
    logger.log('$_logTag bumped → $state');
  }
}

/// Camera position stashed across a MapView recreate.
///
/// [MapRecreationCounter] tears down the native map, which forgets its camera.
/// The freshly initialized [DgisController] reads this snapshot after style
/// load and applies it, then calls [clear]. Kept keepAlive so the value
/// survives the intermediate invalidation of `dgisControllerProvider`.
@Riverpod(keepAlive: true)
class PendingCameraSnapshot extends _$PendingCameraSnapshot {
  @override
  CameraPositionMessage? build() => null;

  void set(CameraPositionMessage position) {
    state = position;
    logger.log(
      '$_logTag stashed camera lat=${position.point.latitude} lon=${position.point.longitude} '
      'zoom=${position.zoom} tilt=${position.tilt} bearing=${position.bearing}',
    );
  }

  void clear() {
    if (state == null) {
      return;
    }
    state = null;
    logger.log('$_logTag cleared pending camera');
  }
}
