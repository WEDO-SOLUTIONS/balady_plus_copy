import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/camera_state.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearest_object.g.dart';

sealed class NearestObject {}

class DGisNearestObject extends NearestObject {
  DGisNearestObject(this.nearestPoint, this.object);

  final GeoPointWithElevationMessage nearestPoint;
  final DirectoryObjectMessage object;
}

class CooridnatesNearestObject extends NearestObject {
  CooridnatesNearestObject(this.geoPoint);

  final GeoPointMessage geoPoint;
}

@riverpod
class _NearestObject extends _$NearestObject {
  CancelableOperation<AsyncValue<NearestObject>>? _loadOperation;

  @override
  Future<NearestObject> build() async {
    ref
      ..onDispose(() {
        ref.read(cameraPaddingProvider.notifier).resetPadding();
      })
      ..listen(cameraStateProvider, (prev, next) {
        if (next == CameraState.free) {
          _load().then((value) => state = value);
        } else {
          _loadOperation?.cancel();
          state = const AsyncValue.loading();
        }
      });

    final nearest = await _load();

    return nearest.value!;
  }

  Future<AsyncValue<NearestObject>> _load() {
    _loadOperation?.cancel();
    _loadOperation = CancelableOperation.fromFuture(
      _loadNearest(),
    );
    return _loadOperation!.value;
  }

  Future<AsyncValue<NearestObject>> _loadNearest() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final objects = await dgisController.getNearestObjects();
    final dgisObjects = Stream.fromIterable(objects).asyncMap(
      (e) async => (e, await dgisController.searchByObjectId(e.objectId)),
    );
    final filteredObjects = await dgisObjects
        .where(
          (element) => element.$2.types.firstOrNull?.type != ObjectTypeMessage.admDiv,
        )
        .toList();
    if (filteredObjects.isEmpty) {
      if (ref.read(cameraPositionProvider) == null) {
        return AsyncValue.error(
          'No suitable objects found',
          StackTrace.current,
        );
      }

      return AsyncValue.data(
        CooridnatesNearestObject(
          ref.read(cameraPositionProvider)!.point,
        ),
      );
    }

    final nearest = filteredObjects.first;

    return AsyncValue.data(
      DGisNearestObject(nearest.$1.closestMapPoint, nearest.$2),
    );
  }
}

final nearestObjectProvider = _nearestObjectProvider;
