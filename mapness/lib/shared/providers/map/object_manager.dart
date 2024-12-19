import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'object_manager.g.dart';

class MapObjectLayers {
  /// Default layer for map objects. Used for all objects e.g. POI.
  static const defaultLayerId = '920277';

  /// Layer for markers that should be on the top of all other objects.
  /// E.g. My location marker because it should be on top of my location circle.
  static const priorityLayerId = '977194';
}

class MapObjectManagerSettings {
  final String name;
  final String? layerId;

  const MapObjectManagerSettings._({required this.name, required this.layerId});

  factory MapObjectManagerSettings.favourites() => const MapObjectManagerSettings._(
        name: 'favourite-markers',
        layerId: MapObjectLayers.defaultLayerId,
      );
  factory MapObjectManagerSettings.esri() => const MapObjectManagerSettings._(
        name: 'esri_markers',
        layerId: MapObjectLayers.defaultLayerId,
      );

  factory MapObjectManagerSettings.mappness() => const MapObjectManagerSettings._(
        name: MapnessConstants.mapLayerName,
        layerId: MapObjectLayers.defaultLayerId,
      );
  factory MapObjectManagerSettings.search() => const MapObjectManagerSettings._(
        name: 'balady_search',
        layerId: MapObjectLayers.defaultLayerId,
      );
  factory MapObjectManagerSettings.myLocation() => const MapObjectManagerSettings._(
        name: 'my_location',
        layerId: MapObjectLayers.priorityLayerId,
      );

  factory MapObjectManagerSettings.eta() => const MapObjectManagerSettings._(
        name: 'eta',
        layerId: MapObjectLayers.priorityLayerId,
      );

  factory MapObjectManagerSettings.jobs() => const MapObjectManagerSettings._(
        name: 'jobs',
        layerId: MapObjectLayers.defaultLayerId,
      );

  factory MapObjectManagerSettings.selectedMarker() => const MapObjectManagerSettings._(
        name: 'selected-marker',
        layerId: MapObjectLayers.defaultLayerId,
      );
}

@riverpod
class MapObjectManager extends _$MapObjectManager {
  @override
  Future<MapObjectManagerMessage> build({
    required String named,
    String? layerId = MapObjectLayers.defaultLayerId,
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

  /// -- MARKER --
  String? currentMarkerIcon;

  List<Marker> get markers => _markers;

  final _markers = <Marker>[];

  Marker? markerByGeoPoint(LatLng geoPoint) => _markers.firstWhereOrNull(
        (element) =>
            element.options.position.latitude == geoPoint.latitude &&
            element.options.position.longitude == geoPoint.longitude,
      );
  Future<void> addMarker(Marker marker) async {
    await ref.read(dgisControllerProvider).value?.addMarker(
          marker,
          toManager: await future,
        );

    _markers.add(marker);
    currentMarkerIcon = marker.options.icon?.svgPath;
  }

  Future<void> addMarkers(List<Marker> markers) async {
    await ref.read(dgisControllerProvider).value?.addMarkers(
          markers,
          toManager: await future,
        );

    _markers.addAll(markers);
    currentMarkerIcon = markers.firstOrNull?.options.icon?.svgPath;
  }

  Future<void> setMapObjectManagerIsVisible({required bool isVisible}) async {
    await ref.read(dgisControllerProvider).value?.setMapObjectManagerIsVisible(isVisible, await future);
  }

  Future<void> removeMarkerById(String markerId) async {
    _markers.removeWhere((element) => element.id == markerId);
    final manager = await future;
    try {
      unawaited(
        ref.read(dgisControllerProvider).value?.removeMarker(
              markerId,
              fromManager: manager,
            ),
      );
    } catch (ex, __) {
      debugPrint(ex.toString());
    }
  }

  Future<void> removeAllMarkers() async {
    await ref.read(dgisControllerProvider).value?.removeAllMarkers(
          fromManager: await future,
        );

    _markers.clear();
    currentMarkerIcon = null;
  }

  /// --- POLYLINE ---

  Future<void> addPolyLines(List<Polyline> polylines) async {
    await ref.read(dgisControllerProvider).value?.addPolylines(
          polylines,
          toManager: await future,
        );
  }

  Future<void> removeAllPolyLines() async {
    await ref.read(dgisControllerProvider).value?.removeAllPolylines(
          fromManager: await future,
        );
  }

  /// --- POLYGON ---

  Future<void> addPolygons(List<Polygon> polygons) async {
    await ref.read(dgisControllerProvider).value?.addPolygons(
          polygons,
          toManager: await future,
        );
  }

  Future<void> removeAllPolygons() async {
    await ref.read(dgisControllerProvider).value?.removeAllPolygons(
          fromManager: await future,
        );
  }

  Future<void> removeAll() async {
    await removeAllMarkers();
    await removeAllPolygons();
    await removeAllPolyLines();
  }
}
