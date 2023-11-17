import 'package:dgis_map/library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dgis_controller.dart';

part 'object_manager.g.dart';

@riverpod
class MapObjectManager extends _$MapObjectManager {
  @override
  MapObjectManagerMessage? build({
    required String named,
    ClusteringMapObjectManager? clustering,
  }) {
    ref.onDispose(() {
      if (state != null) {
        ref.read(dgisControllerProvider)?.removeMapObjectManager(state!);
      }
    });

    _load();
    return null;
  }

  Future<void> _load() async {
    final dgisController = ref.watch(dgisControllerProvider);
    final manager = clustering != null
        ? await dgisController
            ?.createMapObjectManagerWithClustering(clustering!)
        : await dgisController?.createMapObjectManager();

    state = manager;
  }

  Future<void> removeAllMarkers() async {
    if (state != null) {
      ref.read(dgisControllerProvider)?.removeAllMarkers(
            fromManager: state,
          );
    }
  }

  Future<void> addMarkers(List<Marker> markers) async {
    ref.read(dgisControllerProvider)?.addMarkers(
          markers,
          toManager: state,
        );
  }

  Future<void> addMarker(Marker marker) async {
    ref.read(dgisControllerProvider)?.addMarker(
          marker,
          toManager: state,
        );
  }
}
