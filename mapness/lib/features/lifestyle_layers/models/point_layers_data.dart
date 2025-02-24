// ignore_for_file: avoid_dynamic_calls

import 'package:dgis_map/library.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';

class PointLayersData {
  final String id;
  final String name;
  final String description;
  final String type;

  final GeoPointWithElevationMessage? latLng;
  final GISMapLayers layerType;

  const PointLayersData({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.layerType,
    this.latLng,
  });
}

List<GeoPointMessage> getList(List list) {
  final paths = <GeoPointMessage>[];
  for (final pointList in list) {
    for (final point in pointList as Iterable) {
      paths.add(
        GeoPointMessage(
          latitude: double.parse(point[1].toString()),
          longitude: double.parse(point[0].toString()),
        ),
      );
    }
  }
  return paths;
}

List<GeoPointMessage> getPolyLines(List list) {
  final paths = <GeoPointMessage>[];
  for (final pointList in list) {
    for (final point in pointList as Iterable) {
      paths.add(
        GeoPointMessage(
          latitude: double.parse(point[1].toString()),
          longitude: double.parse(point[0].toString()),
        ),
      );
    }
  }
  return paths;
}

List<List<GeoPointMessage>> getGoogleList(List list) {
  final paths = <List<GeoPointMessage>>[];
  for (final pointList in list) {
    final inside = <GeoPointMessage>[];

    for (final point in pointList as Iterable) {
      inside.add(
        GeoPointMessage(
          latitude: double.parse(point[1].toString()),
          longitude: double.parse(point[0].toString()),
        ),
      );
    }
    paths.add(inside);
  }

  return paths;
}
