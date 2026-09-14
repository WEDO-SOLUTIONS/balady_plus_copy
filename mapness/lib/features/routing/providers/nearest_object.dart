import 'dart:async';

import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/camera_state.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearest_object.g.dart';

sealed class NearestObject {}

class DGisNearestObject extends NearestObject {
  DGisNearestObject(this.nearestPoint, this.object, this.levelId);

  final GeoPointWithElevationMessage nearestPoint;
  final DirectoryObjectMessage object;
  final int? levelId;
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
    final cameraPadding = ref.read(cameraPaddingProvider.notifier);
    ref
      ..onDispose(() {
        _loadOperation?.cancel();
        detach(Future<void>.microtask(cameraPadding.resetPadding), tag: 'nearestObject.microtask');
      })
      ..listen(cameraStateProvider, (prev, next) {
        if (next == CameraState.free) {
          _load().then((value) {
            if (!ref.mounted) {
              return;
            }
            state = value;
          });
        } else {
          _loadOperation?.cancel();
          if (ref.mounted) {
            state = const AsyncValue.loading();
          }
        }
      });

    final nearest = await _load();

    return nearest.requireValue;
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
    if (!ref.mounted) {
      return AsyncValue.error(StateError('nearestObjectProvider disposed'), StackTrace.current);
    }
    final objects = await dgisController.getNearestObjects();
    if (!ref.mounted) {
      return AsyncValue.error(StateError('nearestObjectProvider disposed'), StackTrace.current);
    }
    final dgisObjects = Stream.fromIterable(objects).asyncMap(
      (e) async => (e, await dgisController.searchByObjectId(e.objectId)),
    );
    final filteredObjects = await dgisObjects
        .where(
          (element) => element.$2.types.firstOrNull?.type != ObjectTypeMessage.admDiv,
        )
        .toList();
    if (!ref.mounted) {
      return AsyncValue.error(StateError('nearestObjectProvider disposed'), StackTrace.current);
    }
    if (filteredObjects.isEmpty) {
      final cameraPosition = ref.read(cameraPositionProvider);
      if (cameraPosition == null) {
        return AsyncValue.error(
          'No suitable objects found',
          StackTrace.current,
        );
      }

      return AsyncValue.data(
        CooridnatesNearestObject(
          cameraPosition.point,
        ),
      );
    }

    final nearest = filteredObjects.first;

    return AsyncValue.data(
      DGisNearestObject(nearest.$1.closestMapPoint, nearest.$2, nearest.$1.levelId),
    );
  }
}

final nearestObjectProvider = _nearestObjectProvider;
