import 'package:dgis_map/library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dgis_controller.dart';

part 'object_manager.g.dart';

@riverpod
class MapObjectManager extends _$MapObjectManager {
  @override
  Future<MapObjectManagerMessage> build({
    required String named,
    ClusteringMapObjectManager? clustering,
  }) async {
    print("[$named] build");

    final dgisController = await ref.watch(dgisControllerProvider.future);

    print("[$named] init");

    final manager = clustering != null
        ? await dgisController.createMapObjectManagerWithClustering(clustering)
        : await dgisController.createMapObjectManager();

    print("[$named] created manager with ${manager.id}");

    ref.onDispose(() async {
      await dgisController.removeAllMarkers(fromManager: manager);
      await dgisController.removeMapObjectManager(manager);
    });

    return manager;
  }

  Future<void> removeAllMarkers() async {
    await ref.read(dgisControllerProvider).value?.removeAllMarkers(
          fromManager: await future,
        );

    print("[$named] remove all markers from ${(await future).id}");
  }

  Future<void> addMarkers(List<Marker> markers) async {
    await ref.read(dgisControllerProvider).value?.addMarkers(
          markers,
          toManager: await future,
        );

    print("[$named] add $markers to ${(await future).id}");
  }

  Future<void> addMarker(Marker marker) async {
    await ref.read(dgisControllerProvider).value?.addMarker(
          marker,
          toManager: await future,
        );

    print("[$named] add $marker to ${(await future).id}");
  }
}
