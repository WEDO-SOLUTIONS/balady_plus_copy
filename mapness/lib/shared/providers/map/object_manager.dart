import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'object_manager.g.dart';

class MapObjectLayers {
  /// Default layer for map objects. Used for all objects e.g. POI.
  static const defaultLayerId = '920277';

  /// Layer for hajj markers
  static const hajjLayerId = '331464';

  /// Layer for markers that should be on the top of all other objects.
  /// E.g. My location marker because it should be on top of my location circle.
  static const priorityLayerId = '977194';

  /// Layer for metro lines.
  static const metroLayerId = '676767';
}

class MapObjectManagerSettings {
  final String name;
  final String? layerId;

  /// SDK hides markers of the same manager that are close on screen (below zoom 18).
  final bool generalization;

  const MapObjectManagerSettings._({required this.name, required this.layerId, this.generalization = true});

  factory MapObjectManagerSettings.favourites() =>
      const MapObjectManagerSettings._(name: 'favourite-markers', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.makkahPlaces() => const MapObjectManagerSettings._(
    name: 'makkah-places',
    layerId: MapObjectLayers.defaultLayerId,
  );

  factory MapObjectManagerSettings.dynamicPoi() => const MapObjectManagerSettings._(
    name: 'dynamic-poi',
    layerId: MapObjectLayers.defaultLayerId,
  );

  factory MapObjectManagerSettings.esri() =>
      const MapObjectManagerSettings._(name: 'esri_markers', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.mappness() =>
      const MapObjectManagerSettings._(name: MapnessConstants.mapLayerName, layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.search() =>
      const MapObjectManagerSettings._(name: 'balady_search', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.hajj() =>
      const MapObjectManagerSettings._(name: 'hajj_custom_marker', layerId: MapObjectLayers.hajjLayerId);

  factory MapObjectManagerSettings.myLocation() =>
      const MapObjectManagerSettings._(name: 'my_location', layerId: MapObjectLayers.priorityLayerId);

  factory MapObjectManagerSettings.cityEvent() => const MapObjectManagerSettings._(
    name: 'city_event',
    layerId: MapObjectLayers.priorityLayerId,
  );

  /// Its own manager (distinct from [cityEvent]) so the SDK's built-in
  /// generalization/decluttering — which only avoids overlap between
  /// objects within the SAME manager — never hides it against Cityscape's
  /// or Founding Day's markers when they converge on screen while zooming.
  factory MapObjectManagerSettings.leap() =>
      const MapObjectManagerSettings._(name: 'leap', layerId: MapObjectLayers.priorityLayerId);

  factory MapObjectManagerSettings.eta() =>
      const MapObjectManagerSettings._(name: 'eta', layerId: MapObjectLayers.priorityLayerId);

  factory MapObjectManagerSettings.jobs() =>
      const MapObjectManagerSettings._(name: 'jobs', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.parking() =>
      const MapObjectManagerSettings._(name: 'parking-spot', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.selectedMarker() =>
      const MapObjectManagerSettings._(name: 'selected-marker', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.metro() =>
      const MapObjectManagerSettings._(name: 'metro', layerId: MapObjectLayers.metroLayerId);

  /// Numbers of all stops stay visible at any zoom, even when they overlap.
  factory MapObjectManagerSettings.intermediateStops() => const MapObjectManagerSettings._(
    name: 'intermediate-stops',
    layerId: MapObjectLayers.priorityLayerId,
    generalization: false,
  );

  factory MapObjectManagerSettings.makkahBus() =>
      const MapObjectManagerSettings._(name: 'makkah-bus', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.jeddahBus() =>
      const MapObjectManagerSettings._(name: 'jeddah-bus', layerId: MapObjectLayers.defaultLayerId);

  factory MapObjectManagerSettings.shuttleBus() =>
      const MapObjectManagerSettings._(name: 'shuttle-bus', layerId: MapObjectLayers.defaultLayerId);

  const MapObjectManagerSettings.wrcEvent() : this._(name: 'wrc-event', layerId: MapObjectLayers.hajjLayerId);
}

@riverpod
class MapObjectManager extends _$MapObjectManager {
  @override
  Future<MapObjectManagerMessage> build({
    required String named,
    String? layerId = MapObjectLayers.defaultLayerId,
    ClusteringMapObjectManager? clustering,
    bool generalization = true,
  }) async {
    final dgisController = await ref.watch(dgisControllerProvider.future);

    final manager = clustering != null
        ? await dgisController.createMapObjectManagerWithClustering(clustering, layerId: layerId)
        : await dgisController.createMapObjectManager(layerId: layerId, generalization: generalization);

    ref.onDispose(() async {
      await dgisController.removeAllMarkers(fromManager: manager);
      await dgisController.removeAllModels(fromManager: manager);
      await dgisController.removeMapObjectManager(manager);
    });

    return manager;
  }

  /// -- MARKER --
  List<Marker> get markers => _markers;

  final _markers = <Marker>[];

  Marker? markerByGeoPoint(LatLng geoPoint) => _markers.firstWhereOrNull(
    (element) =>
        element.options.position.latitude == geoPoint.latitude &&
        element.options.position.longitude == geoPoint.longitude,
  );

  Marker? markerById(String id) => _markers.firstWhereOrNull((element) => element.id == id);

  Future<void> addMarker(Marker marker) async {
    await ref.read(dgisControllerProvider).value?.addMarker(marker, toManager: await future);

    _markers.add(marker);
  }

  Future<void> addMarkers(List<Marker> markers) async {
    await ref.read(dgisControllerProvider).value?.addMarkers(markers, toManager: await future);

    _markers.addAll(markers);
  }

  Future<void> setMapObjectManagerIsVisible({required bool isVisible}) async {
    await ref
        .read(dgisControllerProvider)
        .value
        ?.setMapObjectManagerIsVisible(isVisible: isVisible, manager: await future);
  }

  Future<void> setMarkerOptions(
    String markerId,
    ChangeMarkerOptionsMessage options,
  ) async => await ref.read(dgisControllerProvider).value?.setMarkerOptions(markerId, options);

  Future<void> removeMarkerById(String markerId) async {
    _markers.removeWhere((element) => element.id == markerId);
    final manager = await future;
    try {
      unawaited(ref.read(dgisControllerProvider).value?.removeMarker(markerId, fromManager: manager));
    } catch (ex, _) {
      logger.log('Error removing marker: ${ex.toString()}');
    }
  }

  Future<void> removeAllMarkers() async {
    await ref.read(dgisControllerProvider).value?.removeAllMarkers(fromManager: await future);

    _markers.clear();
  }

  /// --- 3D MODEL ---
  List<ModelMapObject> get models => _models;

  final _models = <ModelMapObject>[];

  Future<void> addModel(ModelMapObject model) async {
    await ref.read(dgisControllerProvider).value?.addModel(model, toManager: await future);

    _models.add(model);
  }

  Future<void> addModels(List<ModelMapObject> models) async {
    await ref.read(dgisControllerProvider).value?.addModels(models, toManager: await future);

    _models.addAll(models);
  }

  Future<void> setModelOptions(
    String modelId,
    ChangeModelMapObjectOptionsMessage options,
  ) async => await ref.read(dgisControllerProvider).value?.setModelOptions(modelId, options);

  Future<void> removeModelById(String modelId) async {
    _models.removeWhere((element) => element.id == modelId);
    final manager = await future;
    try {
      unawaited(ref.read(dgisControllerProvider).value?.removeModel(modelId, fromManager: manager));
    } catch (ex, _) {
      logger.log('Error removing model: ${ex.toString()}');
    }
  }

  Future<void> removeAllModels() async {
    await ref.read(dgisControllerProvider).value?.removeAllModels(fromManager: await future);

    _models.clear();
  }

  /// --- POLYLINE ---

  Future<void> addPolyLines(List<Polyline> polylines) async {
    await ref.read(dgisControllerProvider).value?.addPolylines(polylines, toManager: await future);
  }

  Future<void> removeAllPolyLines() async {
    await ref.read(dgisControllerProvider).value?.removeAllPolylines(fromManager: await future);
  }

  /// --- POLYGON ---

  Future<void> addPolygons(List<Polygon> polygons) async {
    await ref.read(dgisControllerProvider).value?.addPolygons(polygons, toManager: await future);
  }

  Future<void> removeAllPolygons() async {
    await ref.read(dgisControllerProvider).value?.removeAllPolygons(fromManager: await future);
  }

  Future<void> removePolygonById(String polygonId) async {
    final manager = await future;
    try {
      await ref.read(dgisControllerProvider).value?.removePolygon(polygonId, fromManager: manager);
    } catch (ex, _) {
      logger.log('Error removing polygon: ${ex.toString()}');
    }
  }

  Future<void> removeAll() async {
    await removeAllMarkers();
    await removeAllModels();
    await removeAllPolygons();
    await removeAllPolyLines();
  }
}
