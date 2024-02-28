import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'object_manager.g.dart';

@riverpod
class MapObjectManager extends _$MapObjectManager {
  @override
  Future<MapObjectManagerMessage> build({
    required String named,
    String? layerId = '920277',
    ClusteringMapObjectManager? clustering,
  }) async {
    final dgisController = await ref.watch(dgisControllerProvider.future);

    final manager = clustering != null
        ? await dgisController.createMapObjectManagerWithClustering(
            clustering,
            layerId: layerId,
          )
        : await dgisController.createMapObjectManager(
            layerId: layerId,
          );

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
  }

  Future<void> addPolyLines(List<Polyline> polylines) async {
    await ref.read(dgisControllerProvider).value?.addPolylines(polylines);
  }

  Future<void> addPolygons(List<Polygon> polygons) async {
    await ref.read(dgisControllerProvider).value?.addPolygons(polygons);
  }

  Future<void> addMarkers(List<Marker> markers) async {
    await ref.read(dgisControllerProvider).value?.addMarkers(
          markers,
          toManager: await future,
        );
  }

  Future<void> addMarker(Marker marker) async {
    await ref.read(dgisControllerProvider).value?.addMarker(
          marker,
          toManager: await future,
        );
  }

  Future<void> removeMarkerById(String markerId) async {
    await ref.read(dgisControllerProvider).value?.removeMarker(
          markerId,
          fromManager: await future,
        );
  }

  Future<void> removeAllPolyLines() async {
    await ref.read(dgisControllerProvider).value?.removeAllPolylines();
  }

  Future<void> removeAllPolygons() async {
    await ref.read(dgisControllerProvider).value?.removeAllPolygons();
  }
}
