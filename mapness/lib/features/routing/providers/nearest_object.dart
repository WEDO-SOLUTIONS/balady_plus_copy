import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/camera_state.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearest_object.g.dart';

class NearestObject {
  NearestObject(this.nearestPoint, this.object);

  final GeoPointWithElevationMessage nearestPoint;
  final DirectoryObjectMessage object;
}

@riverpod
class _NearestObject extends _$NearestObject {
  @override
  Future<NearestObject> build() async {
    ref.listen(cameraStateProvider, (prev, next) async {
      if (next == CameraState.free) {
        state = await _loadNearest();
      } else {
        state = const AsyncValue.loading();
      }
    });

    final nearest = await _loadNearest();

    return nearest.value!;
  }

  Future<AsyncValue<NearestObject>> _loadNearest() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final objects = await dgisController.getNearestObjects();
    final dgisObjects = await Stream.fromIterable(objects)
        .asyncMap(
          (e) async => (e, await dgisController.searchByObjectId(e.object)),
        )
        .toList();
    final filteredObjects = dgisObjects
        .where((element) =>
            element.$2.types.firstOrNull?.type != ObjectTypeMessage.admDiv)
        .toList();
    if (filteredObjects.isEmpty) {
      return AsyncValue.error('No suitable objects found', StackTrace.current);
    }

    final nearest = filteredObjects.first;

    return AsyncValue.data(
      NearestObject(nearest.$1.closestMapPoint, nearest.$2),
    );
  }
}

final nearestObjectProvider = _nearestObjectProvider;
